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
    });
    // 서브타이틀 수정 시에도 BLoC에 동기화
    _subTitleController.addListener(() {
      context.read<GiftPackagingBloc>().add(
        SetSubTitle(_subTitleController.text),
      );
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _subTitleController.dispose();
    _playCountController.dispose();
    super.dispose();
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
      );
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
      );
    }
  }

  Widget _buildEditForm(BuildContext modalContext, GachaItemData itemData) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        void updateModal() {
          setModalState(() {});
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: itemData.itemName,
                    onChanged: (String val) {
                      setState(() {
                        itemData.itemName = val;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF4FAF9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '이미지',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    '확률 (%)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => Navigator.of(modalContext).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '저장 완료',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        // 모바일일 때는 앱바 영역의 오버플로우를 막고 본문으로 내림
        title: isMobile ? null : _buildTitleBar(),
        actions: <Widget>[_buildStepIndicator()],
      ),
      body: SafeArea(
        child: isMobile
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildTitleBar(),
                      ),
                      const SizedBox(height: 24),
                      _buildItemsSection(totalPercent, remainPercent, isMobile),
                    ],
                  ),
                ),
              )
            : CustomScrollView(
                slivers: <Widget>[
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Row(
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
        const Text('님의', style: TextStyle(fontSize: 16)),
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
          Text(
            '전체 확률 : ${totalPercent.toStringAsFixed(2)}% ( - ${remainPercent.toStringAsFixed(2)}%)',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                child: Text(
                  '전체 확률 : ${totalPercent.toStringAsFixed(2)}% ( - ${remainPercent.toStringAsFixed(2)}%)',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
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
        Container(
          width: double.infinity, // 부모 너비 가득
          // 모바일 높이 무제한 에러 방지 위해 고정 높이 제거, Wrap 콘텐츠 크기에 맞춤
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            spacing: 24,
            runSpacing: 24,
            children: <Widget>[
              for (int i = 0; i < _items.length; i++)
                _buildCapsuleItem(_items[i]),
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
        ),
      ],
    );
  }

  Widget _buildCapsuleItem(GachaItemData item) {
    return InkWell(
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
                  color: Colors.black,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ), // 선을 굵게 변경
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
                    child: Container(color: item.color.withValues(alpha: 0.7)),
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
            Expanded(
              child: TextFormField(
                controller: _playCountController,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
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
                        color: Colors.grey.shade300,
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
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isMobile) ...<Widget>[
          const Spacer(),
          // 포장 완료 버튼 (데스크톱 최하단 고정)
          SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                _completePackage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6DE1F1), // 하늘색 톤
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                '포장 완료',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
                  onPressed: () {
                    _completePackage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6DE1F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '포장 완료',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                        const Text(
                          '상세 설정',
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
