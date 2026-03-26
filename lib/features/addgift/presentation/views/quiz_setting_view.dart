import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../application/gift_packaging_bloc.dart';
import '../../model/gift_content.dart';
import '../../model/quiz_content.dart';
import '../../model/quiz_setting_models.dart';

class QuizSettingView extends StatefulWidget {
  const QuizSettingView({super.key});

  @override
  State<QuizSettingView> createState() => _QuizSettingViewState();
}

class _QuizSettingViewState extends State<QuizSettingView> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();

  final List<QuizItemData> _items = <QuizItemData>[];

  // 보상 관련 상태
  final QuizRewardData _successReward = QuizRewardData(requiredCount: 1);
  final QuizRewardData _failReward = QuizRewardData();

  String _selectedBgm = '신나는 생일';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final GiftPackagingState blocState = context.read<GiftPackagingBloc>().state;
    // BLoC에 기존 입력된 받는 분 정보가 있다면 불러오기
    if (blocState.receiverName.isNotEmpty) {
      _userNameController.text = blocState.receiverName;
    }
    // 초기 생성된 랜덤 타이틀을 서브타이틀 필드에 세팅
    if (blocState.subTitle.isNotEmpty) {
      _subTitleController.text = blocState.subTitle;
    }

    _userNameController.addListener(() {
      context.read<GiftPackagingBloc>().add(
        SetReceiverName(_userNameController.text),
      );
    });
    // 서브타이틀 리스너 추가
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
    super.dispose();
  }

  // --- [아이템 리스트 컨트롤 로직] ---

  void _addItem() {
    _showTypeSelectionDialog();
  }

  void _removeAllItems() {
    setState(() {
      _items.clear();
      // 성공 기준 값도 문제가 없어지면 초기화하는 것이 좋을 수 있음
      _successReward.requiredCount = 1;
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final QuizItemData item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  // --- [이미지 픽커 유틸] ---

  Future<void> _pickImageForReward(bool isSuccessReward) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isSuccessReward) {
          _successReward.imageFile = image;
        } else {
          _failReward.imageFile = image;
        }
      });
    }
  }

  // --- [모달 로직] ---

  void _showTypeSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('문제 유형 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('객관식'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditModal(
                    QuizItemData(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: QuizType.multipleChoice,
                    ),
                    isNew: true,
                  );
                },
              ),
              ListTile(
                title: const Text('주관식'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditModal(
                    QuizItemData(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: QuizType.subjective,
                    ),
                    isNew: true,
                  );
                },
              ),
              ListTile(
                title: const Text('OX 퀴즈'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditModal(
                    QuizItemData(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: QuizType.ox,
                    ),
                    isNew: true,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditModal(QuizItemData item, {bool isNew = false}) {
    // 깊은 복사본을 만들어 에디터에서 사용
    final QuizItemData editingItem = QuizItemData(
      id: item.id,
      type: item.type,
      title: item.title,
      imageUrl: item.imageUrl,
      imageFile: item.imageFile,
      description: item.description,
      hint: item.hint,
      options: List<String>.from(item.options),
      answer: List<String>.from(item.answer),
      playLimit: item.playLimit,
    );

    final bool isMobile = MediaQuery.sizeOf(context).width < 800;

    final Widget form = _QuizEditForm(
      item: editingItem,
      isDesktop: !isMobile,
      onSave: (QuizItemData updatedItem) {
        setState(() {
          if (isNew) {
            _items.add(updatedItem);
            if (_items.isNotEmpty &&
                _successReward.requiredCount! < _items.length) {
              // _successReward.requiredCount = _items.length;
            }
          } else {
            final int index = _items.indexWhere(
              (QuizItemData e) => e.id == updatedItem.id,
            );
            if (index != -1) {
              _items[index] = updatedItem;
            }
          }
        });
        Navigator.pop(context);
      },
    );

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: form,
            ),
          );
        },
      );
    } else {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Dismiss',
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SafeArea(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: 500,
                      height: double.infinity,
                      child: form,
                    ),
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
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
      );
    }
  }

  // --- [빌더] ---

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 800;

    return BlocListener<GiftPackagingBloc, GiftPackagingState>(
      listenWhen: (GiftPackagingState prev, GiftPackagingState curr) =>
          prev.submitStatus != curr.submitStatus,
      listener: (BuildContext context, GiftPackagingState packagingState) {
        if (packagingState.submitStatus == SubmitStatus.success) {
          isPackageComplete = true;
          context.replace('/addgift/package-complete');
        } else if (packagingState.submitStatus == SubmitStatus.failure) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('서버 전송에 실패했습니다. 다시 시도해 주세요.'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (packagingState.submitStatus == SubmitStatus.loading) {
          setState(() => _isSubmitting = true);
        }
      },
      child: Title(
      title: '선물 포장하기 - Gifo',
      color: AppColors.darkBg,
      child: Scaffold(
        backgroundColor: AppColors.darkBg,
        appBar: AppBar(
        toolbarHeight: 68,
        backgroundColor: AppColors.darkBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: isMobile ? null : _buildTitleBar(),
        actions: <Widget>[_buildStepIndicator()],
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(painter: GridBackgroundPainter()),
          ),
          SafeArea(
            child: isMobile
                ? Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: _buildTitleBar(),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: _buildItemsSection(isMobile),
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: _buildItemsSection(isMobile),
                        ),
                      ),
                      Container(
                        width: 1,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: SingleChildScrollView(
                                  child: _buildSettingsSection(isMobile: false),
                                ),
                              ),
                          const SizedBox(height: 24),
                          _buildCompleteButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile ? _buildMobileBottomBar() : null,
    )));
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

  Widget _buildCircle({required bool isActive, required String number}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.neonPurple : Colors.white12,
        border: isActive ? null : Border.all(color: Colors.white24),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontFamily: 'WantedSans',
            color: isActive ? Colors.white : Colors.white38,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Container(
      width: 16,
      height: 2,
      color: isActive
          ? AppColors.neonPurple.withValues(alpha: 0.5)
          : Colors.white12,
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
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.neonPurple,
                  width: 1.5,
                ),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '님의',
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: _subTitleController,
            decoration: InputDecoration(
              hintText: '서브 타이틀',
              hintStyle: const TextStyle(color: Colors.white38),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.neonPurple,
                  width: 1.5,
                ),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '문제 맞추기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonPurple,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('추가'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _removeAllItems,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('모두 제거'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _items.isEmpty
                ? const Center(
                    child: Text(
                      '추가 버튼을 눌러 문제를 생성해보세요.',
                      style: TextStyle(color: Colors.white38),
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    onReorder: _onReorder,
                    buildDefaultDragHandles: false,
                    proxyDecorator:
                        (Widget child, int index, Animation<double> animation) {
                          return Material(
                            color: Colors.transparent,
                            elevation: 0,
                            child: child,
                          );
                        },
                    itemBuilder: (BuildContext context, int index) {
                      final QuizItemData item = _items[index];
                      return _buildQuizListItem(item, index);
                    },
                  ),
          ),
        ),
        if (isMobile) const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildQuizListItem(QuizItemData item, int index) {
    return Card(
      key: ValueKey<String>(item.id),
      color: Colors.white.withValues(alpha: 0.05),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.menu, color: Colors.white38),
        ),
        title: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.neonPurple.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.typeName,
                style: const TextStyle(
                  color: AppColors.neonPurple,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Q. ${item.title.isEmpty ? '(제목 없음)' : item.title}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'A. ${item.answer.isEmpty ? '(정답 없음)' : item.answer.join(", ")}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white54),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 24, color: Colors.red),
          onPressed: () {
            setState(() {
              _items.removeWhere((QuizItemData e) => e.id == item.id);
              if (_items.isEmpty) {
                _successReward.requiredCount = 1;
              } else if (_successReward.requiredCount! > _items.length) {
                _successReward.requiredCount = _items.length;
              }
            });
          },
        ),
        onTap: () => _showEditModal(item),
      ),
    );
  }

  Widget _buildSettingsSection({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (!isMobile) const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  const Text(
                    '맞춘 문제가 ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _items.isEmpty
                          ? 1
                          : (_successReward.requiredCount! > _items.length
                                ? _items.length
                                : _successReward.requiredCount),
                      alignment: Alignment.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                      items:
                          List<int>.generate(
                                _items.isEmpty ? 1 : _items.length,
                                (int index) => index + 1,
                              )
                              .map(
                                (int value) => DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value개'),
                                ),
                              )
                              .toList(),
                      onChanged: _items.isEmpty
                          ? null
                          : (int? newVal) {
                              if (newVal != null) {
                                setState(() {
                                  _successReward.requiredCount = newVal;
                                });
                              }
                            },
                    ),
                  ),
                  const Text(
                    ' 일 때',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildRewardImagePicker(true, _successReward),
                  const SizedBox(height: 16),
                  _buildRewardNameInput(true, _successReward),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '그 외 (실패 보상 등)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildRewardImagePicker(false, _failReward),
                  const SizedBox(height: 16),
                  _buildRewardNameInput(false, _failReward),
                ],
              ),
            ],
          ),
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
            border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1),
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
                        color: Colors.white12,
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
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white38),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteButton() {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _completePackage,
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
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRewardImagePicker(bool isSuccess, QuizRewardData reward) {
    return InkWell(
      onTap: () => _pickImageForReward(isSuccess),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(8),
          image: reward.imageFile != null
              ? DecorationImage(
                  image: NetworkImage(reward.imageFile!.path),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: reward.imageFile == null
            ? const Center(
                child: Text(
                  '물품 사진',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildRewardNameInput(bool isSuccess, QuizRewardData reward) {
    return TextFormField(
      initialValue: reward.itemName,
      decoration: InputDecoration(
        hintText: '물품 이름',
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (String val) {
        setState(() {
          reward.itemName = val;
        });
      },
    );
  }

  Widget _buildMobileBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          border: Border(top: BorderSide(color: Colors.white12)),
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
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 2),
                ),
                child: Icon(Icons.settings, color: Colors.white60),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _completePackage,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  void _showMobileSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return SafeArea(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: BoxDecoration(
                  color: AppColors.darkBg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Text(
                        '세팅',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSettingsSection(isMobile: true),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.neonPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            '닫기',
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
              ),
            );
          },
        );
      },
    );
  }

  void _completePackage() {
    final GiftPackagingBloc bloc = context.read<GiftPackagingBloc>();

    // 서브타이틀, BGM 저장
    bloc.add(SetSubTitle(_subTitleController.text.trim()));
    bloc.add(SetBgm(_selectedBgm));

    // 로컬 QuizItemData -> freezed QuizItemModel 변환
    final List<QuizItemModel> quizItems = _items.asMap().entries.map((
      MapEntry<int, QuizItemData> entry,
    ) {
      final QuizItemData item = entry.value;
      // 퀸즈 타입 문자열 변환
      String typeStr;
      switch (item.type) {
        case QuizType.multipleChoice:
          typeStr = 'multiple_choice';
        case QuizType.ox:
          typeStr = 'ox';
        case QuizType.subjective:
          typeStr = 'subjective';
      }

      // 객관식의 경우 인덱스 기반 answer를 실제 텍스트로 변환
      List<String> answerTexts = item.answer;
      if (item.type == QuizType.multipleChoice) {
        answerTexts = item.answer.map((String idxStr) {
          final int? idx = int.tryParse(idxStr);
          if (idx != null && idx < item.options.length) {
            return item.options[idx];
          }
          return idxStr;
        }).toList();
      }

      return QuizItemModel(
        quizId: entry.key + 1,
        type: typeStr,
        title: item.title,
        imageUrl: item.imageFile?.path,
        description: item.description.isEmpty ? null : item.description,
        hint: item.hint.isEmpty ? null : item.hint,
        options: item.options,
        answer: answerTexts,
        playLimit: item.playLimit,
      );
    }).toList();

    final QuizContent quizContent = QuizContent(
      successReward: QuizSuccessReward(
        requiredCount: _successReward.requiredCount ?? 1,
        itemName: _successReward.itemName,
        imageUrl: _successReward.imageFile?.path ?? '',
      ),
      failReward: QuizFailReward(
        itemName: _failReward.itemName,
        imageUrl: _failReward.imageFile?.path ?? '',
      ),
      list: quizItems,
    );

    bloc.add(SetQuizContent(quizContent));
    // 모든 데이터를 SubmitPackage 이벤트에 직접 담아 전달
    bloc.add(
      SubmitPackage(
        receiverName: _userNameController.text.trim(),
        subTitle: _subTitleController.text.trim(),
        bgm: _selectedBgm,
        gallery: bloc.state.gallery,
        content: GiftContent(quiz: quizContent),
      ),
    );

  }
}

class _QuizEditForm extends StatefulWidget {
  final QuizItemData item;
  final ValueChanged<QuizItemData> onSave;
  final bool isDesktop;

  const _QuizEditForm({
    required this.item,
    required this.onSave,
    this.isDesktop = false,
  });

  @override
  State<_QuizEditForm> createState() => _QuizEditFormState();
}

class _QuizEditFormState extends State<_QuizEditForm> {
  late QuizItemData _editingItem;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();

  // 객관식 답변들 컨트롤러 목록
  final List<TextEditingController> _optionControllers =
      <TextEditingController>[];
  // 정답을 다루기 위한 컨트롤러들
  final List<TextEditingController> _answerControllers =
      <TextEditingController>[];

  // 객관식 답변 다중 선택 인덱스
  final Set<int> _selectedMultipleChoiceAnswers = <int>{};

  @override
  void initState() {
    super.initState();
    _editingItem = widget.item;

    _titleController.text = _editingItem.title;
    _descController.text = _editingItem.description;
    _hintController.text = _editingItem.hint;

    if (_editingItem.type == QuizType.multipleChoice) {
      if (_editingItem.options.isEmpty) {
        _optionControllers.add(TextEditingController());
        _optionControllers.add(TextEditingController());
      } else {
        for (final String opt in _editingItem.options) {
          _optionControllers.add(TextEditingController(text: opt));
        }
      }
      for (final String ans in _editingItem.answer) {
        final int? idx = int.tryParse(ans);
        if (idx != null) {
          _selectedMultipleChoiceAnswers.add(idx);
        } else {
          // 기존 데이터 호환: 텍스트로 저장된 경우 인덱스를 찾음
          final int foundIdx = _editingItem.options.indexOf(ans);
          if (foundIdx != -1) {
            _selectedMultipleChoiceAnswers.add(foundIdx);
          }
        }
      }
    } else if (_editingItem.type == QuizType.subjective) {
      if (_editingItem.answer.isEmpty) {
        _answerControllers.add(TextEditingController());
      } else {
        for (final String ans in _editingItem.answer) {
          _answerControllers.add(TextEditingController(text: ans));
        }
      }
    } else if (_editingItem.type == QuizType.ox) {
      if (_editingItem.answer.isEmpty) {
        _editingItem.answer = <String>['O'];
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _hintController.dispose();
    for (final TextEditingController c in _optionControllers) {
      c.dispose();
    }
    for (final TextEditingController c in _answerControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    _editingItem.title = _titleController.text.trim();
    _editingItem.description = _descController.text.trim();
    _editingItem.hint = _hintController.text.trim();

    if (_editingItem.type == QuizType.multipleChoice) {
      _editingItem.options = _optionControllers
          .map((TextEditingController c) => c.text.trim())
          .where((String s) => s.isNotEmpty)
          .toList();
      _editingItem.answer = _selectedMultipleChoiceAnswers
          .map((int idx) => idx.toString())
          .toList();
    } else if (_editingItem.type == QuizType.subjective) {
      _editingItem.answer = _answerControllers
          .map((TextEditingController c) => c.text.trim())
          .where((String s) => s.isNotEmpty)
          .toList();
    }

    widget.onSave(_editingItem);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _editingItem.imageFile = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.isDesktop
          ? null
          : BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        borderRadius: widget.isDesktop
            ? BorderRadius.zero
            : const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${_editingItem.typeName} 문제 설정',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('제목 (질문)'),
                  TextField(
                    controller: _titleController,
                    decoration: _inputDecoration('질문을 입력하세요'),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('이미지 (선택)'),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                        image: _editingItem.imageFile != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  _editingItem.imageFile!.path,
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _editingItem.imageFile == null
                          ? const Center(
                              child: Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: Colors.white24,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('설명'),
                  TextField(
                    controller: _descController,
                    decoration: _inputDecoration('문제에 대한 설명을 입력하세요'),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('힌트'),
                  TextField(
                    controller: _hintController,
                    decoration: _inputDecoration('문제에 대한 힌트를 입력하세요'),
                  ),
                  const SizedBox(height: 24),

                  if (_editingItem.type == QuizType.multipleChoice) ...<Widget>[
                    _buildSectionTitle('선택지'),
                    ..._optionControllers.asMap().entries.map((
                      MapEntry<int, TextEditingController> entry,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: <Widget>[
                            Text('${entry.key + 1}. '),
                            Expanded(
                              child: TextField(
                                controller: entry.value,
                                decoration: _inputDecoration(
                                  '선택지 ${entry.key + 1}',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  _optionControllers.removeAt(entry.key);
                                  // 선택된 인덱스들 갱신 로직
                                  if (_selectedMultipleChoiceAnswers.contains(
                                    entry.key,
                                  )) {
                                    _selectedMultipleChoiceAnswers.remove(
                                      entry.key,
                                    );
                                  }
                                  final Set<int> newAnswers = <int>{};
                                  for (final int ans
                                      in _selectedMultipleChoiceAnswers) {
                                    if (ans > entry.key) {
                                      newAnswers.add(ans - 1);
                                    } else {
                                      newAnswers.add(ans);
                                    }
                                  }
                                  _selectedMultipleChoiceAnswers.clear();
                                  _selectedMultipleChoiceAnswers.addAll(
                                    newAnswers,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _optionControllers.add(TextEditingController());
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('선택지 추가'),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('정답 선택 (복수 선택 가능)'),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List<Widget>.generate(
                        _optionControllers.length,
                        (int index) {
                          final bool isSelected = _selectedMultipleChoiceAnswers
                              .contains(index);
                          return ChoiceChip(
                            label: Text('${index + 1}번'),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _selectedMultipleChoiceAnswers.add(index);
                                } else {
                                  _selectedMultipleChoiceAnswers.remove(index);
                                }
                              });
                            },
                            selectedColor: AppColors.neonPurple,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.white38,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Colors.white.withValues(alpha: 0.07),
                          );
                        },
                      ),
                    ),
                  ] else if (_editingItem.type ==
                      QuizType.subjective) ...<Widget>[
                    _buildSectionTitle('정답 목록 (유사 답변 포함)'),
                    ..._answerControllers.asMap().entries.map((
                      MapEntry<int, TextEditingController> entry,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: entry.value,
                                decoration: _inputDecoration('정답 형태 입력'),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  _answerControllers.removeAt(entry.key);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _answerControllers.add(TextEditingController());
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('정답 형태 추가'),
                    ),
                  ] else if (_editingItem.type == QuizType.ox) ...<Widget>[
                    _buildSectionTitle('정답'),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: _editingItem.answer.first == 'O'
                                  ? AppColors.neonPurple
                                  : Colors.white.withValues(alpha: 0.07),
                              foregroundColor: _editingItem.answer.first == 'O'
                                  ? Colors.white
                                  : Colors.white38,
                            ),
                            onPressed: () => setState(() {
                              _editingItem.answer = <String>['O'];
                            }),
                            child: const Text(
                              'O',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: _editingItem.answer.first == 'X'
                                  ? AppColors.neonPurple
                                  : Colors.white.withValues(alpha: 0.07),
                              foregroundColor: _editingItem.answer.first == 'X'
                                  ? Colors.white
                                  : Colors.white38,
                            ),
                            onPressed: () => setState(() {
                              _editingItem.answer = <String>['X'];
                            }),
                            child: const Text(
                              'X',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '저장 완료',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.07),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.neonPurple),
      ),
    );
  }
}
