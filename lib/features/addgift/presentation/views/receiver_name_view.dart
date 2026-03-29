import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/gift_packaging_bloc.dart';
import '../widgets/addgift_scaffold.dart';
import '../widgets/step_indicator.dart';

class ReceiverNameView extends StatefulWidget {
  const ReceiverNameView({super.key});

  @override
  State<ReceiverNameView> createState() => _ReceiverNameViewState();
}

class _ReceiverNameViewState extends State<ReceiverNameView> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
          actions: <Widget>[const StepIndicator(activeStep: 1)],
        ),
        bottomNavigationBar: _buildBottomButton(),
        body: SafeArea(
          child: isDesktop
              ? _buildDesktopLayout()
              : _buildMobileLayout(isMobile),
        ),
      ),
    );
  }

  // 데스크톱: 좌우 분할 레이아웃
  Widget _buildDesktopLayout() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '선물 받는 분의',
                  style: TextStyle(
                    fontFamily: 'PFStardustS',
                    fontSize: 36,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
                Text(
                  '닉네임을 알려주세요',
                  style: TextStyle(
                    fontFamily: 'PFStardustS',
                    fontSize: 36,
                    color: AppColors.neonPurple,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '받는 분의 닉네임으로 선물이 포장됩니다.',
                  style: TextStyle(
                    fontFamily: 'WantedSans',
                    fontSize: 15,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: SizedBox(
              width: 400,
              child: _buildInputField(),
            ),
          ),
        ),
      ],
    );
  }

  // 모바일/태블릿: 세로 배치
  Widget _buildMobileLayout(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24.0 : 48.0,
        vertical: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 24),
          Text(
            '선물 받는 분의\n닉네임을 알려주세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PFStardustS',
              fontSize: isMobile ? 24 : 30,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: isMobile ? double.infinity : 400,
              child: _buildInputField(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return TextField(
      textAlign: TextAlign.center,
      controller: _nameController,
      style: const TextStyle(
        fontFamily: 'WantedSans',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: '닉네임 입력',
        hintStyle: const TextStyle(
          fontFamily: 'WantedSans',
          color: Colors.white38,
          fontSize: 18,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 24.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: AppColors.neonPurple, width: 2.0),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _nameController,
        builder: (BuildContext context, TextEditingValue value, Widget? child) {
          final bool isNameEmpty = value.text.trim().isEmpty;
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: isNameEmpty
                    ? null
                    : () {
                        context.read<GiftPackagingBloc>().add(
                          SetReceiverName(value.text.trim()),
                        );
                        context.push('/addgift/memory-decision');
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonPurple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.white12,
                  disabledForegroundColor: Colors.white38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '다음',
                      style: TextStyle(
                        fontFamily: 'WantedSans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 22),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
