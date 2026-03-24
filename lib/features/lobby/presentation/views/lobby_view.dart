import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/center_burst_confetti_widget.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../model/lobby_data.dart';

class LobbyView extends StatefulWidget {
  final LobbyData data;
  final String code;

  const LobbyView({super.key, required this.data, required this.code});

  @override
  State<LobbyView> createState() => _LobbyViewState();
}

class _LobbyViewState extends State<LobbyView> {
  int _currentTypingIndex = 0;
  bool _showConfetti = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < AppBreakpoints.mobile;
    final bool isTablet = screenWidth >= AppBreakpoints.mobile && screenWidth < AppBreakpoints.tablet;

    // 반응형 수치 설정
    final double logoHeight = isMobile ? 50 : (isTablet ? 65 : 80);
    final double titleFontSize = isMobile ? 30 : (isTablet ? 38 : 45);
    final double nameFontSize = isMobile ? 48 : (isTablet ? 60 : 70);
    final double distLogoToText = isMobile ? 40 : (isTablet ? 60 : 80);
    final double distTextToButton = isMobile ? 60 : (isTablet ? 80 : 100);
    final double buttonFontSize = isMobile ? 22 : (isTablet ? 28 : 35);

    return Title(
      title: 'Happy Birthday, ${widget.data.user} | Gifo',
      color: Colors.black, // Android 테스크 매니저 등에서 사용되는 테마 색상
      child: Scaffold(
        backgroundColor: AppColors.darkBg,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              // 배경 그리드 패턴 추가
              Positioned.fill(
                child: CustomPaint(painter: GridBackgroundPainter()),
              ),
              // 타이핑 애니메이션 종료 후 중앙에서 터지는 폭죽 애니메이션
              if (_showConfetti)
                const Align(
                  alignment: Alignment.center,
                  child: CenterBurstConfettiWidget(autoPlay: true),
                ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // 0. 메인 로고 (타이핑 완료 후 버튼과 함께 노출, 애니메이션 X)
                      if (_showConfetti) ...<Widget>[
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () async {
                              final Uri homeUri = Uri.base.resolve('/');
                              if (await canLaunchUrl(homeUri)) {
                                await launchUrl(
                                  homeUri,
                                  webOnlyWindowName: '_blank',
                                );
                              } else {
                                if (context.mounted) context.go('/');
                              }
                            },
                            child: Image.asset(
                              'assets/images/title_logo.png',
                              height: logoHeight,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: distLogoToText),
                      ],
                      // 1. 상단 텍스트 타이핑 영역 (순차적 실행)
                      if (_currentTypingIndex >= 0)
                        AnimatedTextKit(
                          animatedTexts: <AnimatedText>[
                            TyperAnimatedText(
                              'Happy Birthday,',
                              speed: const Duration(milliseconds: 80),
                              textStyle: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          isRepeatingAnimation: false,
                          displayFullTextOnTap: true,
                          pause: Duration.zero,
                          onFinished: () {
                            setState(() {
                              _currentTypingIndex = 1;
                            });
                          },
                        ),
                      if (_currentTypingIndex >= 1)
                        AnimatedTextKit(
                          animatedTexts: <AnimatedText>[
                            TyperAnimatedText(
                              '${widget.data.user}!',
                              speed: const Duration(
                                milliseconds: 80,
                              ), // 이름은 약간 더 천천히 타이핑
                              textStyle: TextStyle(
                                fontSize: nameFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange, // 이름을 주황색으로 강조
                                fontFamily: 'WantedSans', // 원티드 산스 폰트 적용
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          isRepeatingAnimation: false,
                          displayFullTextOnTap: true,
                          pause: Duration.zero,
                          onFinished: () {
                            setState(() {
                              // 애니메이션 최종 완료 후 폭죽 터뜨림
                              _showConfetti = true;
                            });
                          },
                        ),
                      // 2. 입장하기 버튼 (페이드인 애니메이션 적용)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1500), // 1.5초 동안 서서히 등장
                        child: _showConfetti
                            ? Column(
                                key: const ValueKey('lobby_enter_button'),
                                children: <Widget>[
                                  SizedBox(height: distTextToButton),
                                  ElevatedButton(
                                    onPressed: () {
                                      // 갤러리 데이터 존재 여부 판단
                                      if (widget.data.gallery.isNotEmpty) {
                                        context.push('/memory-gallery', extra: widget.code);
                                      } else if (widget.data.content != null) {
                                        // 추억 갤러리 스킵 후 바로 콘텐츠로 이동
                                        if (widget.data.content!.gacha != null) {
                                          context.push(
                                            '/content/gacha',
                                            extra: widget.code,
                                          );
                                        } else if (widget.data.content!.quiz != null) {
                                          context.push('/content/quiz', extra: widget.code);
                                        } else if (widget.data.content!.unboxing != null) {
                                          context.push(
                                            '/content/unboxing',
                                            extra: widget.code,
                                          ); // 차후 생성될 뷰 가정
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.neonPurple,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 24.0 : 40.0,
                                        vertical: isMobile ? 14.0 : 20.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 2,
                                        ), // 네온 스타일 보더
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    child: Text(
                                      '입장하기',
                                      style: TextStyle(
                                        fontSize: buttonFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(key: ValueKey('lobby_button_empty')),
                      ),
                    ],
                  ),
                ),
              ),
              // 하단 푸터 (저작권 표시) 영역
              const Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Text(
                  '© 2026 GIFO. ALL RIGHTS RESERVED.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
