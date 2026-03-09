import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/router/app_router.dart';
import '../../application/gift_packaging_bloc.dart';
import '../../model/gacha_content.dart';

// 캡슐 아이템 데이터를 담는 클래스
class GachaItemData {
  GachaItemData({required this.id, required this.color})
    : percentStr = '0.0', // 기본 확률 0%
      itemName = '';

  final int id;
  final Color color;
  XFile? imageFile;
  String itemName;
  String percentStr;
  bool percentOpen = false;

  double get percent => double.tryParse(percentStr) ?? 0.0;
}

class GachaSettingView extends StatefulWidget {
  const GachaSettingView({super.key});

  @override
  State<GachaSettingView> createState() => _GachaSettingViewState();
}

class _GachaSettingViewState extends State<GachaSettingView> {
  final List<GachaItemData> _items = <GachaItemData>[];
  int _nextId = 1;
  int? _hoveredItemId;
  int? _selectedItemId;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _playCountController = TextEditingController(
    text: '3',
  );
  String _selectedBgm = '신나는 생일';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final blocState = context.read<GiftPackagingBloc>().state;
    // BLoC에 기존 입력된 받는 분 정보가 있다면 불러오기
    if (blocState.receiverName.isNotEmpty) {
      _userNameController.text = blocState.receiverName;
    }
    // 초기 생성된 랜덤 타이틀을 서브타이틀 필드에 세팅
    if (blocState.subTitle.isNotEmpty) {
      _subTitleController.text = blocState.subTitle;
    }

    // 이름 입력란이 수정될 때마다 BLoC에도 동기화
    _userNameController.addListener(() {
      context.read<GiftPackagingBloc>().add(
        SetReceiverName(_userNameController.text),
      );
      setState(() {});
    });
    // 서브타이틀 수정 시에도 BLoC에 동기화
    _subTitleController.addListener(() {
      context.read<GiftPackagingBloc>().add(
        SetSubTitle(_subTitleController.text),
      );
      setState(() {});
    });
    _playCountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _subTitleController.dispose();
    _playCountController.dispose();
    super.dispose();
  }

  bool _canComplete() {
    if (_items.isEmpty) return false;
    if (_userNameController.text.trim().isEmpty) return false;
    if (_subTitleController.text.trim().isEmpty) return false;

    final int? playCount = int.tryParse(_playCountController.text);
    if (playCount == null || playCount < 1) return false;

    for (final item in _items) {
      final double? pct = double.tryParse(item.percentStr);
      if (item.itemName.trim().isEmpty) return false;
      if (pct == null || pct < 0.01 || pct > 100.0) return false;
    }

    final double totalPct = _getTotalPercent();
    if (totalPct < 0.01 || totalPct > 100.0) return false;

    return true;
  }

  Color _getRandomGachaColor() {
    final Random random = Random();
    // 캡슐의 하단에 들어갈 랜덤 파스텔톤 색상
    return Color.fromARGB(
      255,
      150 + random.nextInt(106),
      150 + random.nextInt(106),
      150 + random.nextInt(106),
    );
  }

  void _addItem([String? name, String? percent]) {
    setState(() {
      final GachaItemData newItem = GachaItemData(
        id: _nextId++,
        color: _getRandomGachaColor(),
      );
      if (name != null) newItem.itemName = name;
      if (percent != null) newItem.percentStr = percent;
      _items.add(newItem);
    });
  }

  void _removeAllItems() {
    setState(() {
      _items.clear();
      _hoveredItemId = null;
      _selectedItemId = null;
    });
  }

  void _removeItem(int id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
      if (_hoveredItemId == id) {
        _hoveredItemId = null;
      }
    });
  }

  double _getTotalPercent() {
    double total = 0.0;
    for (final GachaItemData item in _items) {
      total += item.percent;
    }
    return total;
  }

  // 로컬 UI 데이터를 freezed 모델로 변환 -> BLoC에 저장 -> 로그 출력 -> 완료 화면 이동
  void _completePackage() {
    final bloc = context.read<GiftPackagingBloc>();

    // 서브타이틀, BGM 저장
    bloc.add(SetSubTitle(_subTitleController.text.trim()));
    bloc.add(SetBgm(_selectedBgm));

    // 로컬 GachaItemData -> freezed GachaItem 변환
    final List<GachaItem> gachaItems = _items
        .map(
          (GachaItemData item) => GachaItem(
            itemName: item.itemName,
            imageUrl: item.imageFile?.path ?? '',
            percent: item.percent,
            percentOpen: item.percentOpen,
          ),
        )
        .toList();

    final int playCount = int.tryParse(_playCountController.text) ?? 3;

    bloc.add(
      SetGachaContent(GachaContent(playCount: playCount, list: gachaItems)),
    );

    // 포장 완료 이벤트 -> JSON 로그 출력
    bloc.add(SubmitPackage());

    isPackageComplete = true;
    context.replace('/addgift/package-complete');
  }

  Future<void> _pickImage(
    GachaItemData itemData,
    VoidCallback updateModal,
  ) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          itemData.imageFile = pickedFile;
        });
        updateModal(); // 모달 내부 UI 갱신
      }
    } catch (e) {
      debugPrint('이미지 선택 오류: $e');
    }
  }

  void _showEditModal(BuildContext context, GachaItemData itemData) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 600;

    setState(() {
      _selectedItemId = itemData.id;
    });

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        builder: (BuildContext modalContext) =>
            _buildEditForm(modalContext, itemData),
      ).then((_) {
        setState(() {
          _selectedItemId = null;
        });
      });
    } else {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'dismiss',
        barrierColor: Colors.black.withValues(alpha: 0.5),
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: Colors.white,
                  elevation: 8,
                  child: SizedBox(
                    width: 400,
                    height: double.infinity,
                    child: _buildEditForm(context, itemData),
                  ),
                ),
              );
            },
        transitionBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                    ),
                child: child,
              );
            },
      ).then((_) {
        setState(() {
          _selectedItemId = null;
        });
      });
    }
  }

  Widget _buildEditForm(BuildContext modalContext, GachaItemData itemData) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        void updateModal() {
          setModalState(() {});
        }

        final bool isTitleValid = itemData.itemName.trim().isNotEmpty;
        final double? percentValue = double.tryParse(itemData.percentStr);
        final bool isPercentValid =
            percentValue != null &&
            percentValue >= 0.01 &&
            percentValue <= 100.0;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 32.0,
                    right: 32.0,
                    top: 32.0,
                    bottom: MediaQuery.viewInsetsOf(context).bottom + 32.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(width: 24), // 공간 맞추기용
                          const Text(
                            '세팅 화면',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(modalContext).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '제목',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: itemData.itemName,
                        onChanged: (String val) {
                          setState(() {
                            itemData.itemName = val;
                          });
                          updateModal();
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF4FAF9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: !isTitleValid
                                ? const BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  )
                                : BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: !isTitleValid
                                ? const BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  )
                                : BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: !isTitleValid
                                ? const BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  )
                                : const BorderSide(
                                    color: Colors.blue,
                                    width: 1.5,
                                  ),
                          ),
                          errorText: !isTitleValid
                              ? '제목은 최소 1글자 이상이어야 합니다.'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '이미지',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _pickImage(itemData, updateModal),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4FAF9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: itemData.imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    itemData.imageFile!.path,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.add_photo_alternate,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '- 부적합한 제목 및 이미지는 신고를 받을 수 있고, 해당 책임은 제공자에게 있습니다.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '확률 (%)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: itemData.percentStr,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (String val) {
                          setState(() {
                            itemData.percentStr = val;
                          });
                          updateModal();
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF4FAF9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: !isPercentValid
                                ? const BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  )
                                : BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: !isPercentValid
                                ? const BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  )
                                : BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: !isPercentValid
                                ? const BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  )
                                : const BorderSide(
                                    color: Colors.blue,
                                    width: 1.5,
                                  ),
                          ),
                          errorText: !isPercentValid
                              ? '확률은 0.01% 이상 100% 이하입니다.'
                              : null,
                          errorStyle: TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: itemData.percentOpen,
                            onChanged: (bool? val) {
                              setState(() {
                                itemData.percentOpen = val ?? false;
                              });
                              updateModal();
                            },
                            activeColor: Colors.blue,
                          ),
                          const Expanded(
                            child: Text(
                              '확률 고지 여부',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '- 모든 캡슐의 확률 합이 100% 이하여야 합니다.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              // 모달 바닥에 위치하는 버튼 영역 (Bottom Sheet처럼 배치)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(modalContext).pop();
                          _removeItem(itemData.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.red.shade400,
                              width: 1.5,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '삭제',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 800;
    final double totalPercent = _getTotalPercent();
    final double remainPercent = 100.0 - totalPercent;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 68,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: _buildTitleBar(),
        actions: <Widget>[if (!isMobile) _buildStepIndicator()],
      ),
      body: SafeArea(
        child: isMobile
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildItemsSection(totalPercent, remainPercent, isMobile),
                    ],
                  ),
                ),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: _buildItemsSection(
                        totalPercent,
                        remainPercent,
                        isMobile,
                      ),
                    ),
                  ),
                  Container(width: 1, color: Colors.grey.shade200),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: _buildSettingsSection(isMobile: false),
                    ),
                  ),
                ],
              ),
      ),
      // 모바일인 경우 하단 네비게이션 적용 (톱니바퀴 모달 + 완료버튼)
      bottomNavigationBar: isMobile ? _buildMobileBottomBar() : null,
    );
  }

  Widget _buildTitleBar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 100,
          child: TextFormField(
            controller: _userNameController,
            decoration: InputDecoration(
              hintText: '닉네임',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '님의',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: _subTitleController,
            decoration: InputDecoration(
              hintText: '서브 타이틀',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '캡슐 뽑기',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildItemsSection(
    double totalPercent,
    double remainPercent,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (isMobile) ...<Widget>[
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: DefaultTextStyle.of(context).style.fontFamily,
                color: Colors.black,
              ),
              children: <TextSpan>[
                const TextSpan(text: '전체 확률 : '),
                TextSpan(
                  text:
                      '${totalPercent.toStringAsFixed(2)}% ( - ${remainPercent.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    color: (totalPercent >= 0.01 && totalPercent <= 100.0)
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                onPressed: _addItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                child: const Text('추가'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _removeAllItems,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                child: const Text('모두 제거'),
              ),
            ],
          ),
        ] else ...<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: DefaultTextStyle.of(context).style.fontFamily,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: '전체 확률 : '),
                      TextSpan(
                        text:
                            '${totalPercent.toStringAsFixed(2)}% ( - ${remainPercent.toStringAsFixed(2)}%)',
                        style: TextStyle(
                          color: (totalPercent >= 0.01 && totalPercent <= 100.0)
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _addItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: const Text('추가'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _removeAllItems,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: const Text('모두 제거'),
                  ),
                ],
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        if (isMobile)
          _buildCapsuleListContainer()
        else
          Expanded(
            child: SingleChildScrollView(child: _buildCapsuleListContainer()),
          ),
      ],
    );
  }

  Widget _buildCapsuleListContainer() {
    return Container(
      width: double.infinity, // 부모 너비 가득
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        children: <Widget>[
          for (int i = 0; i < _items.length; i++) _buildCapsuleItem(_items[i]),
          // 추가하기 점선 원
          InkWell(
            onTap: _addItem,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DashedCirclePainter(
                        color: Colors.grey.shade600,
                        strokeWidth: 1.5,
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.grey.shade600,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapsuleItem(GachaItemData item) {
    final double? percentValue = double.tryParse(item.percentStr);
    final bool needsEdit =
        item.itemName.trim().isEmpty ||
        percentValue == null ||
        percentValue < 0.01 ||
        percentValue > 100.0;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredItemId = item.id;
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredItemId = null;
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          InkWell(
            onTap: () => _showEditModal(context, item),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 80, // 아이템 영역 고정 (오버플로우 방지)
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedItemId == item.id
                            ? Colors.orange
                            : Colors.black,
                        width: _selectedItemId == item.id ? 3 : 2,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ), // 선택 시 주황색 굵은 선으로 변경
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: <Widget>[
                        // 가운데 아이템 이미지 (배경으로 깔림)
                        Center(
                          child: item.imageFile != null
                              ? Image.network(
                                  item.imageFile!.path,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.card_giftcard,
                                  color: Colors.black,
                                  size: 35,
                                ),
                        ),
                        // 상단 (흰색, 반투명)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 40,
                          child: Container(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        // 하단 랜덤 색상 반형 디자인 (반투명하게 덮어짐)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 40,
                          child: Container(
                            color: item.color.withValues(alpha: 0.7),
                          ),
                        ),
                        // 가운데 분리선
                        Align(
                          alignment: Alignment.center,
                          child: Container(height: 1, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.itemName.isEmpty ? '제목 없음' : item.itemName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: item.itemName.isEmpty ? Colors.grey : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${item.percentStr}%',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),
          if (needsEdit)
            Positioned(
              top: -6,
              left: -6,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.priority_high,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          if (_hoveredItemId == item.id)
            Positioned(
              top: -6,
              right: -6,
              child: GestureDetector(
                onTap: () => _removeItem(item.id),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min, // Spacer로 인한 에러를 막기 위해 최소 사이즈 적용
      children: <Widget>[
        if (!isMobile) const SizedBox(height: 24),
        Row(
          children: <Widget>[
            const Text(
              '뽑기 가능 횟수',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 70,
              child: TextFormField(
                controller: _playCountController,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF4FAF9),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('회'),
          ],
        ),
        const SizedBox(height: 40),
        const Text(
          'BGM 설정',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '메인 BGM :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4FAF9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedBgm,
                          isExpanded: true,
                          onChanged: (String? val) {
                            setState(() {
                              _selectedBgm = val!;
                            });
                          },
                          items: <String>['신나는 생일', '잔잔한 음악', '우리의 추억']
                              .map(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4FAF9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isMobile) ...<Widget>[
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '⚠️ 포장 완료 조건',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• 캡슐 최소 1개 이상 생성',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  '• 상단 이름 및 서브타이틀 입력',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  '• 뽑기 가능 횟수 최소 1회 이상',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  '• 미완성 캡슐 없음',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  '• 전체 확률 0.01% 이상 100.0% 이하',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 포장 완료 버튼 (데스크톱 최하단 고정)
          SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: _canComplete()
                  ? () {
                      _completePackage();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _canComplete()
                    ? const Color(0xFF6DE1F1)
                    : Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                '포장 완료',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _canComplete() ? Colors.black : Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // 모바일 전용 하단 고정 네비게이션 바
  Widget _buildMobileBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                _showMobileSettingsModal(context);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: Icon(Icons.settings, color: Colors.grey.shade700),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _canComplete()
                      ? () {
                          _completePackage();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canComplete()
                        ? const Color(0xFF6DE1F1)
                        : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '포장 완료',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _canComplete()
                          ? Colors.black
                          : Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 모바일 전용 우측 옵션 모달 (톱니바퀴 클릭시)
  void _showMobileSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom, // 키보드 대응
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 컨텐츠 크기만큼만
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Text(
                              '상세 설정',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Tooltip(
                              triggerMode: TooltipTriggerMode.tap,
                              showDuration: const Duration(seconds: 4),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              padding: const EdgeInsets.all(12),
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                height: 1.5,
                              ),
                              message:
                                  '⚠️ 포장 완료 조건\n'
                                  '• 캡슐 최소 1개 이상 생성\n'
                                  '• 상단 닉네임 및 서브타이틀 입력\n'
                                  '• 뽑기 가능 횟수 최소 1 이상\n'
                                  '• 미완성 캡슐 없음\n'
                                  '• 전체 확률 0.01% 이상 100.0% 이하',
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(modalContext).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSettingsSection(isMobile: true),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {}); // 부모 뷰 상태 갱신
                        Navigator.of(modalContext).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '저장',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildCircle(isActive: true, number: '1'),
          _buildLine(isActive: true),
          _buildCircle(isActive: true, number: '2'),
          _buildLine(isActive: true),
          _buildCircle(isActive: true, number: '3'),
        ],
      ),
    );
  }

  // 인디케이터 원형 위젯
  Widget _buildCircle({required bool isActive, required String number}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black : Colors.grey.shade200,
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 인디케이터 연결 선 위젯
  Widget _buildLine({required bool isActive}) {
    return Container(
      width: 16,
      height: 2,
      color: isActive ? Colors.black : Colors.grey.shade200,
    );
  }
}

// 점선 그리기 (빈 아이템용)
class DashedCirclePainter extends CustomPainter {
  DashedCirclePainter({required this.color, required this.strokeWidth});
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final double perimeter = 2 * pi * radius;
    const double dashLength = 6.0;
    const double dashSpace = 4.0;

    final int dashCount = (perimeter / (dashLength + dashSpace)).floor();
    final double sweepAngle = (dashLength / perimeter) * 360 * (pi / 180);
    final double spaceAngle = (dashSpace / perimeter) * 360 * (pi / 180);

    double currentAngle = 0;
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        currentAngle,
        sweepAngle,
        false,
        paint,
      );
      currentAngle += sweepAngle + spaceAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
