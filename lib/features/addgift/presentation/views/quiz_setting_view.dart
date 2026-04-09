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
import '../widgets/desktop_settings_rail.dart';
import '../widgets/quiz/quiz_complete_button.dart';
import '../widgets/quiz/quiz_edit_form.dart';
import '../widgets/quiz/quiz_items_section.dart';
import '../widgets/quiz/quiz_mobile_bottom_bar.dart';
import '../widgets/quiz/quiz_settings_panel.dart';
import '../widgets/quiz/quiz_title_bar.dart';
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

    final quizContent = packagingState.quizContent;
    List<QuizItemData>? uiItems;
    QuizRewardData? successReward;
    QuizRewardData? failReward;

    if (quizContent != null) {
      uiItems = quizContent.list.map((item) {
        QuizType type;
        if (item.type == 'ox') {
          type = QuizType.ox;
        } else if (item.type == 'subjective') {
          type = QuizType.subjective;
        } else {
          type = QuizType.multipleChoice;
        }

        List<String> answer = item.answer;
        if (type == QuizType.multipleChoice) {
          answer = item.answer.map((ans) {
            final idx = item.options.indexOf(ans);
            return idx != -1 ? idx.toString() : ans;
          }).toList();
        }

        return QuizItemData(
          id: item.quizId.toString(),
          type: type,
          title: item.title,
          imageUrl: item.imageUrl,
          imageFile: item.imageUrl != null && item.imageUrl!.isNotEmpty ? XFile(item.imageUrl!) : null,
          description: item.description ?? '',
          hint: item.hint ?? '',
          options: item.options,
          answer: answer,
          playLimit: item.playLimit,
        );
      }).toList();

      successReward = QuizRewardData(
        requiredCount: quizContent.successReward.requiredCount,
        itemName: quizContent.successReward.itemName,
        imageUrl: quizContent.successReward.imageUrl,
        imageFile: quizContent.successReward.imageUrl.isNotEmpty ? XFile(quizContent.successReward.imageUrl) : null,
      );

      failReward = QuizRewardData(
        itemName: quizContent.failReward.itemName,
        imageUrl: quizContent.failReward.imageUrl,
        imageFile: quizContent.failReward.imageUrl.isNotEmpty ? XFile(quizContent.failReward.imageUrl) : null,
      );

      _successRewardNameController.text = successReward.itemName;
      _failRewardNameController.text = failReward.itemName;
    }

    final initialBgm = packagingState.bgm.isNotEmpty ? packagingState.bgm : '신나는 생일';

    context.read<QuizSettingBloc>().add(InitQuizSetting(
      initialBgm: initialBgm,
      uiItems: uiItems,
      successReward: successReward,
      failReward: failReward,
    ));

    _userNameController.addListener(() {
      context.read<GiftPackagingBloc>().add(
        SetReceiverName(_userNameController.text),
      );
      setState(() {});
    });
    _subTitleController.addListener(() {
      context.read<GiftPackagingBloc>().add(
        SetSubTitle(_subTitleController.text),
      );
      setState(() {});
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
      setState(() {});
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
      setState(() {});
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
          backgroundColor: AppColors.darkBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            '문제 유형 선택',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('객관식', style: TextStyle(color: Colors.white)),
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
                title: const Text('주관식', style: TextStyle(color: Colors.white)),
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
                title: const Text(
                  'OX 퀴즈',
                  style: TextStyle(color: Colors.white),
                ),
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
                    color: AppColors.darkBg,
                    elevation: 8,
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

  // --- [완료 조건] ---

  bool _canComplete() {
    final QuizSettingState quizState = context.read<QuizSettingBloc>().state;
    if (quizState.uiItems.isEmpty) return false;
    if (_userNameController.text.trim().isEmpty) return false;
    if (_subTitleController.text.trim().isEmpty) return false;
    if (quizState.successReward.itemName.trim().isEmpty || (quizState.successReward.imageFile == null && quizState.successReward.imageUrl == null)) return false;
    if (quizState.failReward.itemName.trim().isEmpty || (quizState.failReward.imageFile == null && quizState.failReward.imageUrl == null)) return false;
    for (final QuizItemData item in quizState.uiItems) {
      if (item.title.trim().isEmpty) return false;
      if (item.answer.isEmpty) return false;
      if (item.type == QuizType.multipleChoice && item.options.length < 2) {
        return false;
      }
    }
    return true;
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
                  title: isMobile
                      ? null
                      : QuizTitleBar(
                          userNameController: _userNameController,
                          subTitleController: _subTitleController,
                        ),
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
                                    child: QuizTitleBar(
                                      userNameController: _userNameController,
                                      subTitleController: _subTitleController,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                    child: QuizItemsSection(
                                      isMobile: isMobile,
                                      quizState: quizState,
                                      onAddItem: _addItem,
                                      onRemoveAllItems: _removeAllItems,
                                      onReorder: _onReorder,
                                      onRemoveItem: _removeItem,
                                      onTapItem: _showEditModal,
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
                                    child: QuizItemsSection(
                                      isMobile: isMobile,
                                      quizState: quizState,
                                      onAddItem: _addItem,
                                      onRemoveAllItems: _removeAllItems,
                                      onReorder: _onReorder,
                                      onRemoveItem: _removeItem,
                                      onTapItem: _showEditModal,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: DesktopSettingsRail(
                                    settingsBuilder:
                                        (
                                          BuildContext context,
                                          bool isCompactDesktop,
                                        ) => QuizSettingsPanel(
                                          quizState: quizState,
                                          isMobile: false,
                                          isCompactDesktop: isCompactDesktop,
                                          successRewardNameController:
                                              _successRewardNameController,
                                          failRewardNameController:
                                              _failRewardNameController,
                                          onPickSuccessRewardImage: () =>
                                              _pickImageForReward(true),
                                          onPickFailRewardImage: () =>
                                              _pickImageForReward(false),
                                          hasItems: quizState.uiItems.isNotEmpty,
                                          hasNameAndSubTitle: _userNameController.text.trim().isNotEmpty && _subTitleController.text.trim().isNotEmpty,
                                          hasNoIncompleteItems: quizState.uiItems.isNotEmpty && quizState.uiItems.every((item) {
                                            if (item.title.trim().isEmpty) return false;
                                            if (item.answer.isEmpty) return false;
                                            if (item.type == QuizType.multipleChoice && item.options.length < 2) return false;
                                            return true;
                                          }),
                                          hasSuccessRewardName: quizState.successReward.itemName.trim().isNotEmpty && (quizState.successReward.imageFile != null || quizState.successReward.imageUrl != null),
                                          hasFailRewardName: quizState.failReward.itemName.trim().isNotEmpty && (quizState.failReward.imageFile != null || quizState.failReward.imageUrl != null),
                                        ),
                                    bottomAction: QuizCompleteButton(
                                      enabled: _canComplete() && !_isSubmitting,
                                      onPressed: _completePackage,
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
                bottomNavigationBar: isMobile
                    ? QuizMobileBottomBar(
                        isSubmitting: _isSubmitting,
                        canComplete: _canComplete(),
                        onShowSettings: _showMobileSettingsModal,
                        onComplete: _completePackage,
                      )
                    : null,
              ),
            ),
          );
        },
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
                          hasItems: quizState.uiItems.isNotEmpty,
                          hasNameAndSubTitle: _userNameController.text.trim().isNotEmpty && _subTitleController.text.trim().isNotEmpty,
                          hasNoIncompleteItems: quizState.uiItems.isNotEmpty && quizState.uiItems.every((item) {
                            if (item.title.trim().isEmpty) return false;
                            if (item.answer.isEmpty) return false;
                            if (item.type == QuizType.multipleChoice && item.options.length < 2) return false;
                            return true;
                          }),
                          hasSuccessRewardName: quizState.successReward.itemName.trim().isNotEmpty && (quizState.successReward.imageFile != null || quizState.successReward.imageUrl != null),
                          hasFailRewardName: quizState.failReward.itemName.trim().isNotEmpty && (quizState.failReward.imageFile != null || quizState.failReward.imageUrl != null),
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
