import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';

class GiftModeModal extends StatefulWidget {
  const GiftModeModal({super.key});

  @override
  State<GiftModeModal> createState() => _GiftModeModalState();
}

class _GiftModeModalState extends State<GiftModeModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<Color?> _borderColorAnim;

  // 마우스 호버 상태 (AI 추천 카드, 직접 입력 카드)
  bool _isAiHovered = false;
  bool _isManualHovered = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _borderColorAnim = ColorTween(
      begin: AppColors.pixelPurple,
      end: AppColors.neonPurpleLight,
    ).animate(_glowController);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  // AI 추천 선택 시 처리
  Future<void> _onAiRecommend(BuildContext context) async {
    context.pop();
    final Uri url = Uri.base.resolve('/addgift?mode=ai');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, webOnlyWindowName: '_blank');
    } else {
      if (context.mounted) context.push('/addgift?mode=ai');
    }
  }

  // 직접 입력 선택 시 처리
  Future<void> _onManualInput(BuildContext context) async {
    context.pop();
    final Uri url = Uri.base.resolve('/addgift');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, webOnlyWindowName: '_blank');
    } else {
      if (context.mounted) context.push('/addgift');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final bool isMobile = screenWidth < AppBreakpoints.mobile;
    final bool isDesktop = screenWidth >= AppBreakpoints.tablet;

    // 모바일 화면 잘림 방지: 화면 높이의 85%를 최대 높이로 제한
    final double maxHeight = screenHeight * 0.85;

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          // 데스크톱은 최대 너비 제한, 모바일은 full
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 640 : double.infinity,
            // 모달 내용이 화면 높이를 넘지 않도록 제한
            maxHeight: maxHeight,
          ),
          padding: EdgeInsets.all(isMobile ? 16.0 : 36.0),
          decoration: BoxDecoration(
            color: AppColors.darkBg,
            border: Border.all(
              color: _borderColorAnim.value ?? AppColors.pixelPurple,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    _borderColorAnim.value?.withValues(alpha: 0.4) ??
                    AppColors.pixelPurple.withValues(alpha: 0.4),
                blurRadius: 20,
              ),
            ],
          ),
          // 내용이 maxHeight를 초과할 경우 스크롤 가능하게 처리
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 타이틀 영역
                Text(
                  '선물 포장하기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PFStardustS',
                    fontSize: isMobile ? 20 : 26,
                    height: 1.5,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isMobile ? 4 : 8),
                // 서브 설명 텍스트
                Text(
                  '포장 방식을 선택해 주세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'WantedSans',
                    fontSize: isMobile ? 11 : 15,
                    color: Colors.white38,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 32),
                // 카드 영역: 모바일/태블릿 -> 세로 배치, 데스크톱 -> 가로 배치
                if (!isDesktop)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildAiCard(context, isMobile),
                      SizedBox(height: isMobile ? 10 : 14),
                      _buildManualCard(context, isMobile),
                    ],
                  )
                else
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _buildAiCard(context, isMobile)),
                        const SizedBox(width: 20),
                        Expanded(child: _buildManualCard(context, isMobile)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // AI 추천 카드
  Widget _buildAiCard(BuildContext context, bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isAiHovered = true),
      onExit: (_) => setState(() => _isAiHovered = false),
      child: GestureDetector(
        onTap: () => _onAiRecommend(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            // 모바일에서 카드 내부 여백을 줄여 세로 공간 절약
            horizontal: isMobile ? 14 : 28,
            vertical: isMobile ? 16 : 40,
          ),
          decoration: BoxDecoration(
            color: _isAiHovered
                ? AppColors.neonPurple.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.03),
            border: Border.all(
              color: _isAiHovered
                  ? AppColors.neonPurple
                  : AppColors.pixelPurple.withValues(alpha: 0.5),
              width: _isAiHovered ? 2 : 1,
            ),
            boxShadow: _isAiHovered
                ? [
                    BoxShadow(
                      color: AppColors.neonPurple.withValues(alpha: 0.25),
                      blurRadius: 16,
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI 아이콘
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                // 모바일에서 아이콘 컨테이너 크기 축소
                width: isMobile ? 40 : 68,
                height: isMobile ? 40 : 68,
                decoration: BoxDecoration(
                  color: _isAiHovered
                      ? AppColors.neonPurple.withValues(alpha: 0.2)
                      : AppColors.pixelPurple.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isAiHovered
                        ? AppColors.neonPurple
                        : AppColors.pixelPurple,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: _isAiHovered
                      ? AppColors.neonPurple
                      : AppColors.pixelPurple,
                  size: isMobile ? 20 : 36,
                ),
              ),
              SizedBox(height: isMobile ? 10 : 24),
              // 카드 타이틀
              Text(
                'AI 추천',
                style: TextStyle(
                  fontFamily: 'PFStardustS',
                  fontSize: isMobile ? 15 : 22,
                  color: _isAiHovered ? Colors.white : Colors.white70,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: isMobile ? 6 : 14),
              // 카드 설명
              Text(
                '간단하게 몇 가지만 알려주시면\nAI가 추천해서 나머지 부분들을\n채워드립니다.\n\n*포장 전까지 수정 가능',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'WantedSans',
                  fontSize: isMobile ? 11 : 13,
                  color: Colors.white38,
                  height: 1.7,
                ),
              ),
              SizedBox(height: isMobile ? 10 : 24),
              // 선택 방향 화살표 힌트 (호버 시 노출)
              AnimatedOpacity(
                opacity: _isAiHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'AI로 시작하기',
                      style: TextStyle(
                        fontFamily: 'WantedSans',
                        fontSize: isMobile ? 11 : 13,
                        color: AppColors.neonPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.neonPurple,
                      size: isMobile ? 13 : 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 직접 입력 카드
  Widget _buildManualCard(BuildContext context, bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isManualHovered = true),
      onExit: (_) => setState(() => _isManualHovered = false),
      child: GestureDetector(
        onTap: () => _onManualInput(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 14 : 28,
            vertical: isMobile ? 16 : 40,
          ),
          decoration: BoxDecoration(
            color: _isManualHovered
                ? AppColors.neonBlue.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.03),
            border: Border.all(
              color: _isManualHovered
                  ? AppColors.neonBlue
                  : AppColors.pixelPurple.withValues(alpha: 0.5),
              width: _isManualHovered ? 2 : 1,
            ),
            boxShadow: _isManualHovered
                ? [
                    BoxShadow(
                      color: AppColors.neonBlue.withValues(alpha: 0.2),
                      blurRadius: 16,
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 직접 입력 아이콘 (연필)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isMobile ? 40 : 68,
                height: isMobile ? 40 : 68,
                decoration: BoxDecoration(
                  color: _isManualHovered
                      ? AppColors.neonBlue.withValues(alpha: 0.15)
                      : AppColors.pixelPurple.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isManualHovered
                        ? AppColors.neonBlue
                        : AppColors.pixelPurple,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.edit_rounded,
                  color: _isManualHovered
                      ? AppColors.neonBlue
                      : AppColors.pixelPurple,
                  size: isMobile ? 20 : 36,
                ),
              ),
              SizedBox(height: isMobile ? 10 : 24),
              // 카드 타이틀
              Text(
                '직접 입력',
                style: TextStyle(
                  fontFamily: 'PFStardustS',
                  fontSize: isMobile ? 15 : 22,
                  color: _isManualHovered ? Colors.white : Colors.white70,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: isMobile ? 6 : 14),
              // 카드 설명
              Text(
                '다소 시간은 소요되지만,\n처음부터 끝까지 직접 입력합니다.',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'WantedSans',
                  fontSize: isMobile ? 11 : 13,
                  color: Colors.white38,
                  height: 1.7,
                ),
              ),
              SizedBox(height: isMobile ? 10 : 24),
              // 선택 방향 화살표 힌트 (호버 시 노출)
              AnimatedOpacity(
                opacity: _isManualHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '직접 시작하기',
                      style: TextStyle(
                        fontFamily: 'WantedSans',
                        fontSize: isMobile ? 11 : 13,
                        color: AppColors.neonBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.neonBlue,
                      size: isMobile ? 13 : 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
