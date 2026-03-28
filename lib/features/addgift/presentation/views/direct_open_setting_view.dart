import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../application/direct_open_setting/direct_open_setting_bloc.dart';
import '../../application/gift_packaging_bloc.dart';

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

class _DirectOpenSettingContentState
    extends State<_DirectOpenSettingContent> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _beforeDescController = TextEditingController();
  final TextEditingController _afterNameController = TextEditingController();

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

    // BLoC 초기 상태에서 설명 필드 초기화
    final DirectOpenSettingState directOpenState =
        context.read<DirectOpenSettingBloc>().state;
    _beforeDescController.text = directOpenState.beforeDescription;
    _afterNameController.text = directOpenState.afterItemName;

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
    _beforeDescController.addListener(() {
      context.read<DirectOpenSettingBloc>().add(
        UpdateBeforeDescription(_beforeDescController.text),
      );
    });
    _afterNameController.addListener(() {
      context.read<DirectOpenSettingBloc>().add(
        UpdateAfterItemName(_afterNameController.text),
      );
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('서버 전송에 실패했습니다. 다시 시도해 주세요.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<DirectOpenSettingBloc, DirectOpenSettingState>(
        builder: (BuildContext context, DirectOpenSettingState directOpenState) {
          return Scaffold(
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
                                child: _buildContentSection(
                                  isMobile,
                                  directOpenState,
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
                                    child: _buildContentSection(
                                      isMobile,
                                      directOpenState,
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
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: _buildSettingsSection(
                                          directOpenState,
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
                isMobile ? _buildMobileBottomBar(directOpenState) : null,
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
        color: isActive
            ? AppColors.pixelPurple
            : Colors.white.withValues(alpha: 0.1),
        border: isActive ? null : Border.all(color: Colors.white24),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white38,
            fontSize: 14,
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
          ? AppColors.pixelPurple.withValues(alpha: 0.5)
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
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '닉네임',
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
                  color: AppColors.pixelPurple,
                  width: 1.5,
                ),
              ),
            ),
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
            style: const TextStyle(color: Colors.white),
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
                  color: AppColors.pixelPurple,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '선물 개봉',
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildContentSection(
    bool isMobile,
    DirectOpenSettingState state,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isMobile) ...<Widget>[
            _buildBeforeOpenCard(isMobile: isMobile, state: state),
            const SizedBox(height: 24),
            _buildAfterOpenCard(isMobile: isMobile, state: state),
          ] else ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _buildBeforeOpenCard(isMobile: isMobile, state: state),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildAfterOpenCard(isMobile: isMobile, state: state),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBeforeOpenCard({
    bool isMobile = true,
    required DirectOpenSettingState state,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            '개봉 전',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _pickImage(true),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: isMobile ? 200 : 280,
              height: isMobile ? 200 : 280,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
                image: state.beforeImageFile != null
                    ? DecorationImage(
                        image: NetworkImage(state.beforeImageFile!.path),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: state.beforeImageFile == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.card_giftcard,
                          size: 64,
                          color: Colors.white38,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '상자 이미지 변경',
                          style: TextStyle(
                            color: Colors.white38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '설명란 문구',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _beforeDescController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '상자 하단에 보여질 설명을 입력해주세요.',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.white12,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.pixelPurple),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAfterOpenCard({
    bool isMobile = true,
    required DirectOpenSettingState state,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            '개봉 후',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _pickImage(false),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: isMobile ? 200 : 280,
              height: isMobile ? 200 : 280,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
                image: state.afterImageFile != null
                    ? DecorationImage(
                        image: NetworkImage(state.afterImageFile!.path),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: state.afterImageFile == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.image,
                          size: 64,
                          color: Colors.white38,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '물품 사진 등록',
                          style: TextStyle(
                            color: Colors.white38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '물품 이름',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _afterNameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '상품 이름을 기입해주세요.',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.white12,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.pixelPurple),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    DirectOpenSettingState state, {
    required bool isMobile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'BGM (배경음악)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
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
                    value: state.selectedBgm,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1A1A1A),
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white38,
                    onChanged: (String? val) {
                      if (val != null) {
                        context.read<DirectOpenSettingBloc>().add(
                          UpdateDirectOpenBgm(val),
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
    );
  }

  Widget _buildCompleteButton() {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: _completePackage,
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
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileBottomBar(DirectOpenSettingState state) {
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
              onTap: () => _showMobileSettingsModal(state),
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
            Expanded(child: _buildCompleteButton()),
          ],
        ),
      ),
    );
  }

  void _showMobileSettingsModal(DirectOpenSettingState currentState) {
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
                        _buildSettingsSection(state, isMobile: true),
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
