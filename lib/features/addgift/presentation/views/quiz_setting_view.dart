import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../application/gift_packaging_bloc.dart';
import '../../application/quiz_setting/quiz_setting_bloc.dart';
import '../../model/quiz_setting_models.dart';

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
    final GiftPackagingState packagingState =
        context.read<GiftPackagingBloc>().state;
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
    final List<QuizItemData> updated =
        s.uiItems.where((QuizItemData e) => e.id != itemId).toList();
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
    final List<QuizItemData> items =
        List<QuizItemData>.from(context.read<QuizSettingBloc>().state.uiItems);
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final QuizItemData item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    context.read<QuizSettingBloc>().add(UpdateQuizItems(items));
  }

  // --- [이미지 픽커 유틸] ---

  Future<void> _pickImageForReward(bool isSuccessReward) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (!mounted || image == null) return;
    final QuizSettingState s = context.read<QuizSettingBloc>().state;
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
          QuizRewardData(
            itemName: s.failReward.itemName,
            imageFile: image,
          ),
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

    final Widget form = _QuizEditForm(
      item: editingItem,
      isDesktop: !isMobile,
      onSave: (QuizItemData updatedItem) {
        final List<QuizItemData> current =
            context.read<QuizSettingBloc>().state.uiItems;
        if (isNew) {
          context.read<QuizSettingBloc>().add(
            UpdateQuizItems(<QuizItemData>[...current, updatedItem]),
          );
        } else {
          final int index =
              current.indexWhere((QuizItemData e) => e.id == updatedItem.id);
          if (index != -1) {
            final List<QuizItemData> updated =
                List<QuizItemData>.from(current);
            updated[index] = updatedItem;
            context.read<QuizSettingBloc>().add(UpdateQuizItems(updated));
          }
        }
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
        pageBuilder: (
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
        transitionBuilder: (
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
                                          child: _buildSettingsSection(
                                            quizState,
                                            isMobile: false,
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
                ],
              ),
              bottomNavigationBar:
                  isMobile ? _buildMobileBottomBar() : null,
            ),
          );
        },
      ),
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
                    proxyDecorator: (
                      Widget child,
                      int index,
                      Animation<double> animation,
                    ) {
                      return Material(
                        color: Colors.transparent,
                        elevation: 0,
                        child: child,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final QuizItemData item = quizState.uiItems[index];
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
          onPressed: () => _removeItem(item.id),
        ),
        onTap: () => _showEditModal(item),
      ),
    );
  }

  Widget _buildSettingsSection(
    QuizSettingState quizState, {
    required bool isMobile,
  }) {
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: quizState.uiItems.isEmpty
                          ? 1
                          : (quizState.successReward.requiredCount! >
                                    quizState.uiItems.length
                                ? quizState.uiItems.length
                                : quizState.successReward.requiredCount),
                      alignment: Alignment.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: Colors.white38,
                      ),
                      items: List<int>.generate(
                            quizState.uiItems.isEmpty
                                ? 1
                                : quizState.uiItems.length,
                            (int index) => index + 1,
                          )
                          .map(
                            (int value) => DropdownMenuItem<int>(
                              value: value,
                              child: Text('$value개'),
                            ),
                          )
                          .toList(),
                      onChanged: quizState.uiItems.isEmpty
                          ? null
                          : (int? newVal) {
                              if (newVal != null) {
                                context.read<QuizSettingBloc>().add(
                                  UpdateSuccessReward(
                                    QuizRewardData(
                                      requiredCount: newVal,
                                      itemName:
                                          quizState.successReward.itemName,
                                      imageFile:
                                          quizState.successReward.imageFile,
                                    ),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                  const Text(
                    ' 일 때',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildRewardImagePicker(true, quizState),
                  const SizedBox(height: 16),
                  _buildRewardNameInput(isSuccess: true),
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildRewardImagePicker(false, quizState),
                  const SizedBox(height: 16),
                  _buildRewardNameInput(isSuccess: false),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'BGM 설정',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '메인 BGM :',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                          value: quizState.selectedBgm,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1A1A1A),
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white38,
                          onChanged: (String? val) {
                            if (val != null) {
                              context.read<QuizSettingBloc>().add(
                                UpdateQuizBgm(val),
                              );
                            }
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

  Widget _buildRewardImagePicker(bool isSuccess, QuizSettingState quizState) {
    final XFile? imageFile = isSuccess
        ? quizState.successReward.imageFile
        : quizState.failReward.imageFile;
    return InkWell(
      onTap: () => _pickImageForReward(isSuccess),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(8),
          image: imageFile != null
              ? DecorationImage(
                  image: NetworkImage(imageFile.path),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageFile == null
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

  Widget _buildRewardNameInput({required bool isSuccess}) {
    return TextFormField(
      controller: isSuccess
          ? _successRewardNameController
          : _failRewardNameController,
      decoration: InputDecoration(
        hintText: '물품 이름',
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
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
                  decoration: BoxDecoration(
                    color: AppColors.darkBg,
                    borderRadius: const BorderRadius.vertical(
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
                        _buildSettingsSection(quizState, isMobile: true),
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
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
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
                          final bool isSelected =
                              _selectedMultipleChoiceAnswers.contains(index);
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
                              color:
                                  isSelected ? Colors.white : Colors.white38,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.07),
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
                              backgroundColor:
                                  _editingItem.answer.first == 'O'
                                      ? AppColors.neonPurple
                                      : Colors.white.withValues(alpha: 0.07),
                              foregroundColor:
                                  _editingItem.answer.first == 'O'
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
                              backgroundColor:
                                  _editingItem.answer.first == 'X'
                                      ? AppColors.neonPurple
                                      : Colors.white.withValues(alpha: 0.07),
                              foregroundColor:
                                  _editingItem.answer.first == 'X'
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
