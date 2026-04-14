import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/center_burst_confetti_widget.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../content/application/content_audio/content_audio_bloc.dart';
import '../../../content/presentation/widgets/content_audio_toggle.dart';
import '../../application/lobby_bloc.dart';
import '../../model/lobby_data.dart';

class LobbyView extends StatelessWidget {
  final String code;

  const LobbyView({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LobbyBloc, LobbyState>(
      listenWhen: (LobbyState prev, LobbyState curr) =>
          prev.lobbyData == null && curr.lobbyData != null,
      listener: (BuildContext context, LobbyState state) {
        // 데이터 수신 시점에 BGM URL을 미리 로드만 해둔다.
        // 실제 재생은 사용자가 "입장하기"를 누를 때 수행 (브라우저 자동 재생 정책 대응).
        _preloadBgm(context, state.lobbyData?.bgm);
      },
      builder: (BuildContext context, LobbyState state) {
        // 로딩 중 또는 idle 상태: 로딩 화면 표시
        if (state.status == LobbyStatus.loading ||
            state.status == LobbyStatus.idle) {
          return _LoadingView();
        }

        // 코드가 유효하지 않거나 서버 오류 시 에러 화면 표시
        if (state.status == LobbyStatus.failure) {
          return _ErrorView(
            message: state.errorMessage ?? '알 수 없는 오류가 발생했습니다.',
            onRetry: () => context.go('/'),
          );
        }

        // 데이터 수신 완료: 실제 로비 화면 렌더링
        final LobbyData data = state.lobbyData!;

        // 이미 데이터가 로드된 상태로 진입한 경우(Hot Reload 등) URL 사전 로드
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            _preloadBgm(context, data.bgm);
          }
        });

        return _LobbyContent(data: data, code: code);
      },
    );
  }

  // BGM URL을 플레이어에 미리 등록만 한다 (재생은 하지 않음).
  // 재생은 사용자의 명시적 제스처(입장하기 버튼) 이후에 시작된다.
  void _preloadBgm(BuildContext context, String? url) {
    if (url != null && url.isNotEmpty) {
      context.read<ContentAudioBloc>().add(PreloadContentAudio(url));
    }
  }
}

// -------------------------------------------------------
// 데이터 로딩 중 표시되는 progress 화면
// -------------------------------------------------------
class _LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: <Widget>[
          Positioned.fill(child: CustomPaint(painter: GridBackgroundPainter())),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 로고 이미지
                Image.asset(
                  'assets/images/title_logo.png',
                  height: 50,
                  color: Colors.white,
                ),
                const SizedBox(height: 48),
                // 로딩 인디케이터
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: AppColors.neonPurple,
                    strokeWidth: 2.5,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '선물을 준비중입니다..',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'WantedSans',
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// 코드 오류 또는 서버 오류 시 표시되는 화면
// -------------------------------------------------------
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: <Widget>[
          Positioned.fill(child: CustomPaint(painter: GridBackgroundPainter())),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 48,
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'WantedSans',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('홈으로 돌아가기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// 실제 로비 콘텐츠 (API 데이터 수신 완료 후 렌더링)
// -------------------------------------------------------
class _LobbyContent extends StatefulWidget {
  final LobbyData data;
  final String code;

  const _LobbyContent({required this.data, required this.code});

  @override
  State<_LobbyContent> createState() => _LobbyContentState();
}

class _LobbyContentState extends State<_LobbyContent> {
  int _currentTypingIndex = 0;
  bool _showConfetti = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < AppBreakpoints.mobile;
    final bool isTablet =
        screenWidth >= AppBreakpoints.mobile &&
        screenWidth < AppBreakpoints.tablet;

    // 반응형 수치 설정
    final double logoHeight = isMobile ? 50 : (isTablet ? 65 : 80);
    final double titleFontSize = isMobile ? 30 : (isTablet ? 38 : 45);
    final double nameFontSize = isMobile ? 48 : (isTablet ? 60 : 70);
    final double distLogoToText = isMobile ? 40 : (isTablet ? 60 : 80);
    final double distTextToButton = isMobile ? 60 : (isTablet ? 80 : 100);
    final double buttonFontSize = isMobile ? 22 : (isTablet ? 28 : 35);

    return Title(
      title: 'Happy Birthday, ${widget.data.user} | Gifo',
      color: Colors.black,
      child: Scaffold(
        backgroundColor: AppColors.darkBg,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: CustomPaint(painter: GridBackgroundPainter()),
              ),
              // 타이핑 애니메이션 종료 후 중앙 폭죽 애니메이션
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
                      // 폭죽 터진 후 메인 로고 표시
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
                      // 1단계: "Happy Birthday," 타이핑 애니메이션
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
                      // 2단계: 이름 타이핑 애니메이션
                      if (_currentTypingIndex >= 1)
                        AnimatedTextKit(
                          animatedTexts: <AnimatedText>[
                            TyperAnimatedText(
                              '${widget.data.user}!',
                              speed: const Duration(milliseconds: 80),
                              textStyle: TextStyle(
                                fontSize: nameFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontFamily: 'WantedSans',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          isRepeatingAnimation: false,
                          displayFullTextOnTap: true,
                          pause: Duration.zero,
                          onFinished: () {
                            setState(() {
                              _showConfetti = true;
                            });
                          },
                        ),
                      // 입장 버튼 (폭죽 완료 후 페이드인)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1500),
                        child: _showConfetti
                            ? Column(
                                key: const ValueKey('lobby_enter_button'),
                                children: <Widget>[
                                  SizedBox(height: distTextToButton),
                                  ElevatedButton(
                                    onPressed: () => _onEnterPressed(context),
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
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
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
                            : const SizedBox.shrink(
                                key: ValueKey('lobby_button_empty'),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
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
              // 우측 상단 BGM 온/오프 토글
              const Positioned(
                top: 10,
                right: 10,
                child: ContentAudioToggle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 컨텐츠 타입에 따라 해당 화면으로 이동 (extra에 LobbyData와 code를 Map으로 전달)
  void _onEnterPressed(BuildContext context) {
    final LobbyData data = widget.data;

    final Map<String, dynamic> extra = <String, dynamic>{
      'data': data,
      'code': widget.code,
    };

    if (data.gallery.isNotEmpty) {
      context.push('/memory-gallery', extra: extra);
    } else if (data.content != null) {
      final LobbyContent content = data.content!;
      if (content.gacha != null) {
        context.push('/content/gacha', extra: extra);
      } else if (content.quiz != null) {
        context.push('/content/quiz', extra: extra);
      } else if (content.unboxing != null) {
        context.push('/content/unboxing', extra: extra);
      }
    }
  }
}
