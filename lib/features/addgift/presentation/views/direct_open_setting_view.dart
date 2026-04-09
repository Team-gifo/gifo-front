import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../../core/widgets/packaging_loading_overlay.dart';
import '../../application/direct_open_setting/direct_open_setting_bloc.dart';
import '../../application/gift_packaging_bloc.dart';
import '../widgets/desktop_settings_rail.dart';
import '../widgets/direct_open/direct_open_complete_button.dart';
import '../widgets/direct_open/direct_open_content_section.dart';
import '../widgets/direct_open/direct_open_mobile_bottom_bar.dart';
import '../widgets/direct_open/direct_open_settings_section.dart';
import '../widgets/step_indicator.dart';
import '../widgets/direct_open/direct_open_title_bar.dart';

class DirectOpenSettingView extends StatelessWidget {
  const DirectOpenSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DirectOpenSettingBloc>(
      create: (BuildContext ctx) =>
          DirectOpenSettingBloc(ctx.read<GiftPackagingBloc>()),
      child: const _DirectOpenSettingContent(),
    );
  }
}

class _DirectOpenSettingContent extends StatefulWidget {
  const _DirectOpenSettingContent();

  @override
  State<_DirectOpenSettingContent> createState() =>
      _DirectOpenSettingContentState();
}

class _DirectOpenSettingContentState extends State<_DirectOpenSettingContent> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _beforeDescController = TextEditingController();
  final TextEditingController _afterNameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  bool _isSubmitting = false;

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

    final unboxingContent = packagingState.unboxingContent;
    XFile? beforeImageFile;
    String? beforeDescription;
    XFile? afterImageFile;
    String? afterItemName;

    if (unboxingContent != null) {
      beforeDescription = unboxingContent.beforeOpen.description;
      afterItemName = unboxingContent.afterOpen.itemName;

      if (unboxingContent.beforeOpen.imageUrl.isNotEmpty) {
        beforeImageFile = XFile(unboxingContent.beforeOpen.imageUrl);
      }
      if (unboxingContent.afterOpen.imageUrl.isNotEmpty) {
        afterImageFile = XFile(unboxingContent.afterOpen.imageUrl);
      }
      
      _beforeDescController.text = beforeDescription;
      _afterNameController.text = afterItemName;
    }

    final initialBgm = packagingState.bgm.isNotEmpty ? packagingState.bgm : '신나는 생일';

    context.read<DirectOpenSettingBloc>().add(InitDirectOpenSetting(
      initialBgm: initialBgm,
      beforeImageFile: beforeImageFile,
      beforeDescription: beforeDescription,
      afterImageFile: afterImageFile,
      afterItemName: afterItemName,
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
    _beforeDescController.addListener(() {
      context.read<DirectOpenSettingBloc>().add(
        UpdateBeforeDescription(_beforeDescController.text),
      );
      setState(() {});
    });
    _afterNameController.addListener(() {
      context.read<DirectOpenSettingBloc>().add(
        UpdateAfterItemName(_afterNameController.text),
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _subTitleController.dispose();
    _beforeDescController.dispose();
    _afterNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isBefore) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (!mounted || image == null) return;
    if (isBefore) {
      context.read<DirectOpenSettingBloc>().add(UpdateBeforeImage(image));
    } else {
      context.read<DirectOpenSettingBloc>().add(UpdateAfterImage(image));
    }
  }

  bool _canComplete() {
    if (_userNameController.text.trim().isEmpty) return false;
    if (_subTitleController.text.trim().isEmpty) return false;
    if (_beforeDescController.text.trim().isEmpty) return false;
    if (_afterNameController.text.trim().isEmpty) return false;
    return true;
  }

  void _completePackage() {
    final GiftPackagingBloc packagingBloc = context.read<GiftPackagingBloc>();
    context.read<DirectOpenSettingBloc>().add(
      SubmitDirectOpenSetting(
        receiverName: _userNameController.text.trim(),
        subTitle: _subTitleController.text.trim(),
        gallery: packagingBloc.state.gallery,
      ),
    );
  }

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
      child: BlocBuilder<DirectOpenSettingBloc, DirectOpenSettingState>(
        builder:
            (BuildContext context, DirectOpenSettingState directOpenState) {
              return PopScope(
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
                        : DirectOpenTitleBar(
                            userNameController: _userNameController,
                            subTitleController: _subTitleController,
                          ),
                    actions: <Widget>[
                      if (!isMobile) const StepIndicator(activeStep: 3),
                    ],
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
                                      child: DirectOpenTitleBar(
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
                                      child: DirectOpenContentSection(
                                        isMobile: isMobile,
                                        state: directOpenState,
                                        beforeDescController:
                                            _beforeDescController,
                                        afterNameController:
                                            _afterNameController,
                                        onPickBeforeImage: () =>
                                            _pickImage(true),
                                        onPickAfterImage: () =>
                                            _pickImage(false),
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
                                      child: Center(
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxWidth: 1000,
                                          ),
                                          child: DirectOpenContentSection(
                                            isMobile: isMobile,
                                            state: directOpenState,
                                            beforeDescController:
                                                _beforeDescController,
                                            afterNameController:
                                                _afterNameController,
                                            onPickBeforeImage: () =>
                                                _pickImage(true),
                                            onPickAfterImage: () =>
                                                _pickImage(false),
                                          ),
                                        ),
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
                                          ) => DirectOpenSettingsSection(
                                            state: directOpenState,
                                            isMobile: false,
                                            isCompactDesktop: isCompactDesktop,
                                            hasNameAndSubTitle: _userNameController.text.trim().isNotEmpty && _subTitleController.text.trim().isNotEmpty,
                                            hasBeforeDesc: _beforeDescController.text.trim().isNotEmpty,
                                            hasItemName: _afterNameController.text.trim().isNotEmpty,
                                          ),
                                      bottomAction: DirectOpenCompleteButton(
                                        onPressed: _canComplete()
                                            ? _completePackage
                                            : null,
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
                      ? DirectOpenMobileBottomBar(
                          canComplete: _canComplete(),
                          onShowSettings: _showMobileSettingsModal,
                          onComplete: _completePackage,
                        )
                      : null,
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
        return BlocProvider<DirectOpenSettingBloc>.value(
          value: context.read<DirectOpenSettingBloc>(),
          child: BlocBuilder<DirectOpenSettingBloc, DirectOpenSettingState>(
            builder: (BuildContext innerCtx, DirectOpenSettingState state) {
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
                        DirectOpenSettingsSection(
                          state: state,
                          isMobile: true,
                          hasNameAndSubTitle: _userNameController.text.trim().isNotEmpty && _subTitleController.text.trim().isNotEmpty,
                          hasBeforeDesc: _beforeDescController.text.trim().isNotEmpty,
                          hasItemName: _afterNameController.text.trim().isNotEmpty,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(innerCtx),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.pixelPurple,
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
