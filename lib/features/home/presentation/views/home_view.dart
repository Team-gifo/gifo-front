import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../lobby/model/lobby_data.dart';

const double _kCompactBreakpoint = 768.0;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showInviteModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            child: const _InviteModalContent(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < _kCompactBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: Colors.black.withValues(alpha: 0.8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white, width: 4),
                ),
              ),
            ),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: isCompact ? 8.0 : 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.2),
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 16,
                        height: 16,
                        color: AppColors.neonPurple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'gifo',
                    style: TextStyle(
                      fontFamily: 'PFStardust',
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
              // Action
              GestureDetector(
                onTap: () => _showInviteModal(context),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: AppColors.neonPurple, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonPurple.withValues(alpha: 0.3),
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      '초대코드 입력',
                      style: TextStyle(
                        fontFamily: 'PFStardust',
                        color: AppColors.neonPurpleLight,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // 그리드 배경
          Positioned.fill(child: CustomPaint(painter: GridBackgroundPainter())),
          SingleChildScrollView(
            child: Column(
              children: [
                // 1. 메인 히어로 섹션
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 120.0,
                    horizontal: 24.0,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Pixel Art 박스 (애니메이션 적용)
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: _buildMockPixelGiftBox(),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          '기쁨을 전합니다,\n픽셀 단위로',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PFStardust',
                            fontSize: isCompact ? 32 : 56,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          '가장 특별한 형태의 디지털 선물이 당신을 기다립니다.\n레트로한 픽셀과 함께 소중한 마음을 배달해보세요.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 48),
                        // 선물 버튼
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final Uri url = Uri.base.resolve('/addgift');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    webOnlyWindowName: '_blank',
                                  );
                                } else {
                                  if (context.mounted) {
                                    context.push('/');
                                  }
                                }
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.neonPurple,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                  ),
                                  child: const Text(
                                    '선물 보내기',
                                    style: TextStyle(
                                      fontFamily: 'PFStardust',
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. 서비스 소개 섹션 (기존 것을 유지하되 다크 모드 톤 앤 매너로 변경)
                Container(
                  width: double.infinity,
                  color: Colors.white.withValues(alpha: 0.05),
                  padding: const EdgeInsets.symmetric(
                    vertical: 100.0,
                    horizontal: 24.0,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'HOW IT WORKS',
                        style: TextStyle(
                          fontFamily: 'PFStardust',
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Wrap(
                        spacing: 24.0,
                        runSpacing: 24.0,
                        alignment: WrapAlignment.center,
                        children: List.generate(3, (index) {
                          return Container(
                            width: 300,
                            padding: const EdgeInsets.all(32.0),
                            decoration: BoxDecoration(
                              color: AppColors.darkBg,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        offset: const Offset(4, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '0${index + 1}',
                                      style: const TextStyle(
                                        fontFamily: 'PFStardust',
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  index == 0
                                      ? '선택하기'
                                      : index == 1
                                      ? '커스텀하기'
                                      : '전달하기',
                                  style: const TextStyle(
                                    fontFamily: 'PFStardust',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  index == 0
                                      ? 'ai를 통해서 간편하게 만들지, 본인이 직접 만들지 선택할 수 있어요.'
                                      : index == 1
                                      ? '추억이 담긴 사진첩, 다양한 선물 컨텐츠를 통해 선물을 꾸며보세요.'
                                      : '포장이 완료되면 생성된 링크를 그대로 친구에게 보내주세요!',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white54,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // 3. 하단 권유 섹션
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 120.0,
                    horizontal: 24.0,
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '지금 바로 특별한 선물을 준비해보세요.',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        '몇 번의 클릭만으로 링크로 전달할 수 있습니다.',
                        style: TextStyle(fontSize: 16, color: Colors.white54),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockPixelGiftBox() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: AppColors.neonPurple, width: 4),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: 0.3),
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // 심플 픽셀 큐브
            SizedBox(
              width: 100,
              height: 100,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  // 임의의 패턴
                  final isWhite = [2, 5, 8, 11, 14].contains(index);
                  return Container(
                    color: isWhite ? Colors.white : AppColors.neonPurple,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 초대 코드 모달
// ==========================================
class _InviteModalContent extends StatefulWidget {
  const _InviteModalContent();

  @override
  State<_InviteModalContent> createState() => _InviteModalContentState();
}

class _InviteModalContentState extends State<_InviteModalContent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  late AnimationController _glowController;
  late Animation<Color?> _borderColorAnim;
  late Animation<double> _shadowBlurAnim;

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

    _shadowBlurAnim = Tween<double>(
      begin: 10.0,
      end: 20.0,
    ).animate(_glowController);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _handleEnter() {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    if (LobbyData.getDummyByCode(code) != null) {
      context.pop(); // 모달 닫기
      context.push('/lobby', extra: code);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.darkBg,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(0),
          ),
          title: const Text(
            '알림',
            style: TextStyle(color: Colors.white, fontFamily: 'PFStardust'),
          ),
          content: const Text(
            '잘못된 코드입니다',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text(
                '확인',
                style: TextStyle(color: AppColors.neonPurpleLight),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: AppColors.darkBg,
            border: Border.all(
              color: _borderColorAnim.value ?? AppColors.pixelPurple,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    _borderColorAnim.value?.withValues(alpha: 0.5) ??
                    AppColors.pixelPurple.withValues(alpha: 0.5),
                blurRadius: _shadowBlurAnim.value,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '초대 코드 입력',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PFStardust',
                  fontSize: 24,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              // 입력 필드 래퍼
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  // 약간의 포인트를 주기 위한 border
                  border: Border(
                    top: BorderSide(color: AppColors.pixelPurple, width: 2),
                    left: BorderSide(color: AppColors.pixelPurple, width: 2),
                    right: BorderSide(color: AppColors.pixelPurple, width: 2),
                    bottom: BorderSide(color: AppColors.pixelPurple, width: 2),
                  ),
                ),
                child: TextField(
                  controller: _codeController,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'PFStardust',
                    color: AppColors.pixelPurple,
                    fontSize: 20,
                    letterSpacing: 2.0,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  cursorColor: AppColors.neonPurpleLight,
                  decoration: InputDecoration(
                    hintText: 'ex) 1234ABC',
                    hintStyle: TextStyle(
                      fontFamily: 'PFStardust',
                      color: Colors.purple.shade900,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onSubmitted: (_) => _handleEnter(),
                ),
              ),
              const SizedBox(height: 32),
              // 버튼
              GestureDetector(
                onTap: _handleEnter,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColors.pixelPurple,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonPurpleLight.withValues(
                            alpha: 0.5,
                          ),
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '입장하기',
                        style: TextStyle(
                          fontFamily: 'PFStardust',
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
