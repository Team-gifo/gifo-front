import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/gift_packaging_bloc.dart';
import '../widgets/addgift_scaffold.dart';
import '../widgets/receiver_name/receiver_name_bottom_button.dart';
import '../widgets/receiver_name/receiver_name_desktop_layout.dart';
import '../widgets/receiver_name/receiver_name_mobile_layout.dart';
import '../widgets/step_indicator.dart';

class ReceiverNameView extends StatefulWidget {
  const ReceiverNameView({super.key, this.resetOnEnter = true});

  /// 선물 포장을 "새로 시작"하는 진입이면 true.
  /// AI 추천 결과를 수정하기 위해 돌아오는 경우엔 false로 두어 기존 BLoC 상태를 유지한다.
  final bool resetOnEnter;

  @override
  State<ReceiverNameView> createState() => _ReceiverNameViewState();
}

class _ReceiverNameViewState extends State<ReceiverNameView> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // BLoC 상태 초기화 (새로운 선물 포장 시작)
    if (widget.resetOnEnter) {
      context.read<GiftPackagingBloc>().add(ResetPackaging());
    } else {
      // AI 추천 결과 수정 등 "이어하기" 진입: 기존 값 프리필
      final String currentName = context.read<GiftPackagingBloc>().state.receiverName;
      if (currentName.isNotEmpty) {
        _nameController.text = currentName;
      }
    }
    context.read<GiftPackagingBloc>().add(ResetPackaging());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isMobile = screenWidth < AppBreakpoints.mobile;
    final bool isDesktop = screenWidth >= AppBreakpoints.desktop;
    final bool isTablet = !isMobile && !isDesktop;
    final bool isDesktopOrTablet = isDesktop || isTablet;

    return Title(
      title: '선물 포장하기 - Gifo',
      color: AppColors.darkBg,
      child: AddgiftScaffold(
        appBar: AppBar(
          toolbarHeight: 68,
          backgroundColor: AppColors.darkBg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: const <Widget>[StepIndicator(activeStep: 1)],
        ),
        // 모바일 버전에서만 하단 바텀 시트 버튼 사용
        // 태블릿, 데스크탑에서는 키보드 이슈 방지를 위해 바디 내부에 배치
        bottomNavigationBar: isMobile
            ? ReceiverNameBottomButton(
                nameController: _nameController,
                onNext: _handleNext,
              )
            : null,
        body: SafeArea(
          child: isDesktop
              ? ReceiverNameDesktopLayout(
                  nameController: _nameController,
                  onNext: _handleNext,
                )
              : ReceiverNameMobileLayout(
                  isMobile: isMobile,
                  isTablet: isTablet,
                  nameController: _nameController,
                  onNext: _handleNext,
                ),
        ),
      ),
    );
  }

  void _handleNext(String name) {
    context.read<GiftPackagingBloc>().add(SetReceiverName(name));
    context.push('/addgift/memory-decision');
  }
}
