import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../../core/widgets/packaging_loading_overlay.dart';
import '../../application/gift_packaging_bloc.dart';
import '../../application/quiz_setting/quiz_setting_bloc.dart';
import '../../model/quiz_setting_models.dart';
import '../widgets/quiz/quiz_edit_form.dart';
import '../widgets/quiz/quiz_list_item.dart';
import '../widgets/quiz/quiz_settings_panel.dart';
import '../widgets/step_indicator.dart';

class QuizSettingView extends StatelessWidget {
  const QuizSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuizSettingBloc>(
      create: (BuildContext ctx) =>
          QuizSettingBloc(ctx.read<GiftPackagingBloc>()),
      child: const _QuizSettingContent(),
    );
  }
}

class _QuizSettingContent extends StatefulWidget {
  const _QuizSettingContent();

  @override
  State<_QuizSettingContent> createState() => _QuizSettingContentState();
}

class _QuizSettingContentState extends State<_QuizSettingContent> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _successRewardNameController =
      TextEditingController();
  final TextEditingController _failRewardNameController =
      TextEditingController();

  bool _isSubmitting = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final GiftPackagingState packagingState = context
        .read<GiftPackagingBloc>()
        .state;
    if (packagingState.receiverName.isNotEmpty) {
      _userNameController.text = packagingState.receiverName;
    }
    if (packagingState.subTitle.isNotEmpty) {
      _subTitleController.text = packagingState.subTitle;
    }

    _userNameController.addListener(() {
      context.read<GiftPackagingBloc>().add(
        SetReceiverName(_userNameController.text),
      );
    });
    _subTitleController.addListener(() {
      context.read<GiftPackagingBloc>().add(
        SetSubTitle(_subTitleController.text),
      );
    });
    _successRewardNameController.addListener(() {
      final QuizSettingState s = context.read<QuizSettingBloc>().state;
      context.read<QuizSettingBloc>().add(
        UpdateSuccessReward(
          QuizRewardData(
            requiredCount: s.successReward.requiredCount,
            itemName: _successRewardNameController.text,
            imageFile: s.successReward.imageFile,
          ),
        ),
      );
    });
    _failRewardNameController.addListener(() {
      final QuizSettingState s = context.read<QuizSettingBloc>().state;
      context.read<QuizSettingBloc>().add(
        UpdateFailReward(
          QuizRewardData(
            itemName: _failRewardNameController.text,
            imageFile: s.failReward.imageFile,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _subTitleController.dispose();
    _successRewardNameController.dispose();
    _failRewardNameController.dispose();
    super.dispose();
  }

  // --- [아이템 리스트 컨트롤 로직] ---

  void _addItem() {
    _showTypeSelectionDialog();
  }

  void _removeAllItems() {
    final QuizSettingState s = context.read<QuizSettingBloc>().state;
    context.read<QuizSettingBloc>().add(UpdateQuizItems(<QuizItemData>[]));
    context.read<QuizSettingBloc>().add(
      UpdateSuccessReward(
        QuizRewardData(
          requiredCount: 1,
          itemName: s.successReward.itemName,
          imageFile: s.successReward.imageFile,
        ),
      ),
    );
  }

  void _removeItem(String itemId) {
    final QuizSettingState s = context.read<QuizSettingBloc>().state;
    final List<QuizItemData> updated = s.uiItems
        .where((QuizItemData e) => e.id != itemId)
        .toList();
    context.read<QuizSettingBloc>().add(UpdateQuizItems(updated));
    final int currentCount = s.successReward.requiredCount ?? 1;
    if (updated.isEmpty) {
      context.read<QuizSettingBloc>().add(
        UpdateSuccessReward(
          QuizRewardData(
            requiredCount: 1,
            itemName: s.successReward.itemName,
            imageFile: s.successReward.imageFile,
          ),
        ),
      );
    } else if (currentCount > updated.length) {
      context.read<QuizSettingBloc>().add(
        UpdateSuccessReward(
          QuizRewardData(
            requiredCount: updated.length,
            itemName: s.successReward.itemName,
            imageFile: s.successReward.imageFile,
          ),
        ),
      );
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    final List<QuizItemData> items = List<QuizItemData>.from(
      context.read<QuizSettingBloc>().state.uiItems,
    );
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final QuizItemData item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    context.read<QuizSettingBloc>().add(UpdateQuizItems(items));
  }

  // --- [이미지 픽커 유틸] ---

  Future<void> _pickImageForReward(bool isSuccessReward) async {
    final QuizSettingState s = context.read<QuizSettingBloc>().state;
    // 이미지가 없는 보상 슬롯에서 한도(10개) 도달 시 피커를 열지 않음
    final bool alreadyHasImage = isSuccessReward
        ? s.successReward.imageFile != null
        : s.failReward.imageFile != null;
    if (!alreadyHasImage && s.imageCount >= 10) return;
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (!mounted || image == null) return;
    if (isSuccessReward) {
      context.read<QuizSettingBloc>().add(
        UpdateSuccessReward(
          QuizRewardData(
            requiredCount: s.successReward.requiredCount,
            itemName: s.successReward.itemName,
            imageFile: image,
          ),
        ),
      );
    } else {
      context.read<QuizSettingBloc>().add(
        UpdateFailReward(
          QuizRewardData(itemName: s.failReward.itemName, imageFile: image),
        ),
      );
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

    final bool isImageLimitReached =
        context.read<QuizSettingBloc>().state.imageCount >= 10;

    final Widget form = QuizEditForm(
      item: editingItem,
      isDesktop: !isMobile,
      isImageLimitReached: isImageLimitReached,
      onSave: (QuizItemData updatedItem) {
        final List<QuizItemData> current = context
            .read<QuizSettingBloc>()
            .state
            .uiItems;
        if (isNew) {
          context.read<QuizSettingBloc>().add(
            UpdateQuizItems(<QuizItemData>[...current, updatedItem]),
          );
        } else {
          final int index = current.indexWhere(
            (QuizItemData e) => e.id == updatedItem.id,
          );
          if (index != -1) {
            final List<QuizItemData> updated = List<QuizItemData>.from(current);
            updated[index] = updatedItem;
            context.read<QuizSettingBloc>().add(UpdateQuizItems(updated));
          }
        }
        Navigator.of(context, rootNavigator: !isMobile).pop();
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
        useRootNavigator: true,
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

  // --- [포장 완료] ---

  void _completePackage() {
    final GiftPackagingBloc packagingBloc = context.read<GiftPackagingBloc>();
    final QuizSettingState quizState = context.read<QuizSettingBloc>().state;
    debugPrint(
      '[QuizSettingView] 포장 완료 클릭 - 문제수=${quizState.uiItems.length}, 이미지수=${quizState.imageCount}, 받는이="${_userNameController.text.trim()}"',
    );
    context.read<QuizSettingBloc>().add(
      SubmitQuizSetting(
        receiverName: _userNameController.text.trim(),
        subTitle: _subTitleController.text.trim(),
        gallery: packagingBloc.state.gallery,
      ),
    );
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
      child: BlocBuilder<QuizSettingBloc, QuizSettingState>(
        builder: (BuildContext context, QuizSettingState quizState) {
          return Title(
            title: '선물 포장하기 - Gifo',
            color: AppColors.darkBg,
            child: PopScope(
              canPop: !_isSubmitting,
              child: Scaffold(
                backgroundColor: AppColors.darkBg,
                appBar: AppBar(
                  toolbarHeight: 68,
                  backgroundColor: AppColors.darkBg,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  title: isMobile ? null : _buildTitleBar(),
                  actions: const <Widget>[StepIndicator(activeStep: 3)],
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                    child: _buildItemsSection(
                                      isMobile,
                                      quizState,
                                    ),
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
                                    child: _buildItemsSection(
                                      isMobile,
                                      quizState,
                                    ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: QuizSettingsPanel(
                                              quizState: quizState,
                                              isMobile: false,
                                              successRewardNameController:
                                                  _successRewardNameController,
                                              failRewardNameController:
                                                  _failRewardNameController,
                                              onPickSuccessRewardImage: () =>
                                                  _pickImageForReward(true),
                                              onPickFailRewardImage: () =>
                                                  _pickImageForReward(false),
                                            ),
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
                    // 로딩 오버레이: 전송 중 터치 차단 + 프로그레스 표시
                    if (_isSubmitting) const PackagingLoadingOverlay(),
                  ],
                ),
                bottomNavigationBar: isMobile ? _buildMobileBottomBar() : null,
              ),
            ),
          );
        },
      ),
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
        const Text('님의', style: TextStyle(fontSize: 16, color: Colors.white70)),
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

  Widget _buildItemsSection(bool isMobile, QuizSettingState quizState) {
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
            child: quizState.uiItems.isEmpty
                ? const Center(
                    child: Text(
                      '추가 버튼을 눌러 문제를 생성해보세요.',
                      style: TextStyle(color: Colors.white38),
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: quizState.uiItems.length,
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
                      final QuizItemData item = quizState.uiItems[index];
                      return QuizListItem(
                        item: item,
                        index: index,
                        onRemove: () => _removeItem(item.id),
                        onTap: () => _showEditModal(item),
                      );
                    },
                  ),
          ),
        ),
        if (isMobile) const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCompleteButton() {
    return SizedBox(
      height: 60,
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
    );
  }

  Widget _buildMobileBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          border: const Border(top: BorderSide(color: Colors.white12)),
        ),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                _showMobileSettingsModal();
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
                child: const Icon(Icons.settings, color: Colors.white60),
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

  void _showMobileSettingsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return BlocProvider<QuizSettingBloc>.value(
          value: context.read<QuizSettingBloc>(),
          child: BlocBuilder<QuizSettingBloc, QuizSettingState>(
            builder: (BuildContext innerCtx, QuizSettingState quizState) {
              return SafeArea(
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(innerCtx).viewInsets.bottom,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.darkBg,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
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
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        QuizSettingsPanel(
                          quizState: quizState,
                          isMobile: true,
                          successRewardNameController:
                              _successRewardNameController,
                          failRewardNameController: _failRewardNameController,
                          onPickSuccessRewardImage: () =>
                              _pickImageForReward(true),
                          onPickFailRewardImage: () =>
                              _pickImageForReward(false),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(innerCtx);
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
          ),
        );
      },
    );
  }
}
