import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/blocs/download/download_bloc.dart';
import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/gift_image_widget.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../../core/widgets/pixel_envelope_widget.dart';
import '../../../lobby/application/lobby_bloc.dart';
import '../../application/content_audio/content_audio_bloc.dart';
import '../../application/unboxing/unboxing_bloc.dart';
import '../result/result_view.dart';
import '../widgets/content_audio_toggle.dart';

class UnboxingView extends StatefulWidget {
  const UnboxingView({super.key});

  @override
  State<UnboxingView> createState() => _UnboxingViewState();
}

class _UnboxingViewState extends State<UnboxingView>
    with TickerProviderStateMixin {
  bool _isHovering = false;
  bool _hasStartedAnim = false;
  bool _startTyping = false;

  late AnimationController _introAnimCtrl;
  late AnimationController _btnAnimCtrl;

  late Animation<double> _envDrop;
  late Animation<double> _envScale;
  late Animation<double> _envOpacity;
  late Animation<double> _bgOpacity;
  late Animation<double> _textBgOpacity;
  late Animation<double> _textDrop;

  late Animation<double> _btnOpacity;
  late Animation<double> _btnSlideUp;

  @override
  void initState() {
    super.initState();
    // InitUnboxing는 라우터에서 BLoC 생성 시 이미 발행되므로 여기서는 불필요
    _introAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _btnAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // 사전 로드만 시도 (이미 재생 중이면 방해하지 않음).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final audioBloc = context.read<ContentAudioBloc>();
        if (audioBloc.state.isPlaying) return; // 이미 재생 중이면 스킵

        final lobbyState = context.read<LobbyBloc>().state;
        if (lobbyState.lobbyData != null &&
            lobbyState.lobbyData!.bgm.isNotEmpty) {
          audioBloc.add(PreloadContentAudio(lobbyState.lobbyData!.bgm));
        }
      }
    });

    _envDrop = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _introAnimCtrl,
        curve: const Interval(0.0, 0.35, curve: Curves.bounceOut),
      ),
    );
    _envScale = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _introAnimCtrl,
        curve: const Interval(0.45, 0.6, curve: Curves.easeIn),
      ),
    );
    _envOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _introAnimCtrl,
        curve: const Interval(0.45, 0.6, curve: Curves.easeIn),
      ),
    );

    _bgOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introAnimCtrl,
        curve: const Interval(0.6, 0.8, curve: Curves.easeOut),
      ),
    );

    _textDrop = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _introAnimCtrl,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _textBgOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introAnimCtrl,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );

    _btnSlideUp = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(parent: _btnAnimCtrl, curve: Curves.easeOutCubic),
    );
    _btnOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _btnAnimCtrl, curve: Curves.easeOut));

    _introAnimCtrl.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _startTyping = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _introAnimCtrl.dispose();
    _btnAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width >= AppBreakpoints.desktop;

    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        // 로비 데이터 동기화 리스너 추가 (Gacha/Quiz 패턴 동일 적용)
        BlocListener<LobbyBloc, LobbyState>(
          listenWhen: (LobbyState prev, LobbyState curr) =>
              prev.lobbyData != curr.lobbyData && curr.lobbyData != null,
          listener: (BuildContext context, LobbyState lobbyState) {
            final String inviteCode = context
                .read<UnboxingBloc>()
                .state
                .inviteCode;
            context.read<UnboxingBloc>().add(
              InitUnboxing(lobbyState.lobbyData!, inviteCode: inviteCode),
            );
          },
        ),
      ],
      child: BlocConsumer<UnboxingBloc, UnboxingState>(
        listener: (BuildContext context, UnboxingState state) {},
        builder: (BuildContext context, UnboxingState state) {
          if (state.isReceived && state.unboxingContent != null) {
            return BlocProvider<DownloadBloc>(
              create: (_) => DownloadBloc(),
              child: ResultView(
                itemName: state.unboxingContent!.afterOpen.itemName,
                imageUrl: state.unboxingContent!.afterOpen.imageUrl,
                userName: state.userName,
                inviteCode: state.inviteCode,
              ),
            );
          }

          if (state.unboxingContent == null) {
            return Title(
              title: 'Happy Birthday, ${state.userName} | Gifo',
              color: AppColors.darkBg,
              child: const Scaffold(
                backgroundColor: AppColors.darkBg,
                body: Center(
                  child: CircularProgressIndicator(color: AppColors.neonPurple),
                ),
              ),
            );
          }

          if (!_hasStartedAnim) {
            _hasStartedAnim = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _introAnimCtrl.forward();
            });
          }

          return Title(
            title: 'Happy Birthday, ${state.userName} | Gifo',
            color: AppColors.darkBg,
            child: Scaffold(
              backgroundColor: AppColors.darkBg,
              body: SafeArea(
                child: AnimatedBuilder(
                  animation: Listenable.merge(<Listenable?>[
                    _introAnimCtrl,
                    _btnAnimCtrl,
                  ]),
                  builder: (BuildContext context, Widget? child) {
                    final double topInset = size.width < AppBreakpoints.tablet
                        ? 64
                        : 72;
                    final double responsiveFontSize;

                    if (size.width >= AppBreakpoints.desktop) {
                      responsiveFontSize = 22.0;
                    } else if (size.width >= AppBreakpoints.tablet) {
                      responsiveFontSize = 18.0;
                    } else {
                      responsiveFontSize = 16.0;
                    }

                    // 이미지 URL 유무에 따라 텍스트 컨테이너 배치 방식 분기
                    final bool hasImage = state
                        .unboxingContent!
                        .beforeOpen
                        .imageUrl
                        .trim()
                        .isNotEmpty;

                    return Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        // 1. Grid Background
                        Positioned.fill(
                          child: CustomPaint(painter: GridBackgroundPainter()),
                        ),

                        // 2. 배경 이미지: URL이 있을 때만 렌더링
                        if (hasImage && _bgOpacity.value > 0)
                          Positioned.fill(
                            child: Opacity(
                              opacity: _bgOpacity.value,
                              child: GiftImageWidget(
                                imageUrl:
                                    state.unboxingContent!.beforeOpen.imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                        // 3. Pixel Envelope Drop & Burst
                        if (_envOpacity.value > 0)
                          Align(
                            alignment: FractionalOffset(
                              0.5,
                              0.5 + (_envDrop.value * 1.5),
                            ),
                            child: Transform.scale(
                              scale: _envScale.value,
                              child: Opacity(
                                opacity: _envOpacity.value,
                                child: const PixelEnvelopeWidget(),
                              ),
                            ),
                          ),

                        // 4. Text Container
                        // - 이미지 있음: AppBar 아래 상단 고정
                        // - 이미지 없음: 화면 중앙 배치
                        if (_textBgOpacity.value > 0)
                          if (hasImage)
                            Positioned(
                              top: topInset + 24,
                              left: 24,
                              right: 24,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Transform.translate(
                                  offset: Offset(0, _textDrop.value),
                                  child: Opacity(
                                    opacity: _textBgOpacity.value,
                                    child: _buildTextBox(
                                      isDesktop: isDesktop,
                                      responsiveFontSize: responsiveFontSize,
                                      state: state,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else
                            Positioned.fill(
                              child: Padding(
                                padding: EdgeInsets.only(top: topInset),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    child: Transform.translate(
                                      offset: Offset(0, _textDrop.value),
                                      child: Opacity(
                                        opacity: _textBgOpacity.value,
                                        child: _buildTextBox(
                                          isDesktop: isDesktop,
                                          responsiveFontSize:
                                              responsiveFontSize,
                                          state: state,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                        // 5. Button Sliding Up
                        if (_btnOpacity.value > 0)
                          Positioned(
                            bottom: 48,
                            left: 0,
                            right: 0,
                            child: Transform.translate(
                              offset: Offset(0, _btnSlideUp.value),
                              child: Opacity(
                                opacity: _btnOpacity.value,
                                child: Center(
                                  child: _buildReceiveButton(
                                    isDesktop: isDesktop,
                                    state: state,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // 6. AppBar fixed at Top
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: _buildAppBar(state, size),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(UnboxingState state, Size size) {
    final bool isMobileOrSmall = size.width < AppBreakpoints.tablet;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: AppColors.neonPurple.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppBar(
        toolbarHeight: isMobileOrSmall ? 64.0 : 72.0,
        primary: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: isMobileOrSmall ? 16.0 : 32.0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  final Uri homeUri = Uri.base.resolve('/');
                  if (await canLaunchUrl(homeUri)) {
                    await launchUrl(homeUri, webOnlyWindowName: '_blank');
                  } else {
                    if (context.mounted) context.go('/');
                  }
                },
                child: Image.asset(
                  'assets/images/title_logo.png',
                  height: isMobileOrSmall ? 40 : 48,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            if (size.width >= AppBreakpoints.tablet)
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WantedSans',
                  ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: state.userName,
                      style: const TextStyle(color: AppColors.neonPurple),
                    ),
                    const TextSpan(text: '님의 '),
                    TextSpan(
                      text: state.subTitle.isNotEmpty ? state.subTitle : '',
                      style: const TextStyle(color: AppColors.neonPurple),
                    ),
                    const TextSpan(text: ' 선물상자'),
                  ],
                ),
              )
            else
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'WantedSans',
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: state.userName,
                        style: const TextStyle(color: AppColors.neonPurple),
                      ),
                      const TextSpan(text: '님의 '),
                      TextSpan(
                        text: state.subTitle.isNotEmpty ? state.subTitle : '',
                        style: const TextStyle(color: AppColors.neonPurple),
                      ),
                      const TextSpan(text: ' 선물상자'),
                    ],
                  ),
                ),
              ),
            const Spacer(),
            const ContentAudioToggle(),
          ],
        ),
      ),
    );
  }

  // 텍스트 컨테이너 위젯 빌드 (이미지 유무 관계없이 동일한 UI)
  Widget _buildTextBox({
    required bool isDesktop,
    required double responsiveFontSize,
    required UnboxingState state,
  }) {
    return Container(
      width: isDesktop ? 490 : double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppColors.neonPurple.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.neonPurpleLight.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40),
        child: Center(
          heightFactor: 1.0,
          child: _startTyping
              ? DefaultTextStyle(
                  style: TextStyle(
                    fontSize: responsiveFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'WantedSans',
                    height: 1.5,
                  ),
                  child: AnimatedTextKit(
                    key: ValueKey(
                      state.unboxingContent!.beforeOpen.description,
                    ),
                    pause: Duration.zero,
                    isRepeatingAnimation: false,
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                    animatedTexts: <AnimatedText>[
                      TypewriterAnimatedText(
                        state.unboxingContent!.beforeOpen.description,
                        textAlign: TextAlign.center,
                        speed: const Duration(milliseconds: 60),
                      ),
                    ],
                    onFinished: () {
                      if (mounted &&
                          !_btnAnimCtrl.isAnimating &&
                          !_btnAnimCtrl.isCompleted) {
                        _btnAnimCtrl.forward();
                      }
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildReceiveButton({
    required bool isDesktop,
    required UnboxingState state,
  }) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovering ? -5 : 0, 0),
        width: isDesktop ? 400 : double.infinity,
        constraints: const BoxConstraints(maxWidth: 400),
        height: 60,
        child: ElevatedButton(
          onPressed: state.isOpening
              ? null
              : () => context.read<UnboxingBloc>().add(const ReceiveGift()),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.neonPurple,
            foregroundColor: Colors.white,
            elevation: _isHovering ? 8 : 4,
            shadowColor: AppColors.neonPurple.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(
                color: Colors.white,
                width: 2,
              ), // 네온 스타일 보더
            ),
          ),
          child: state.isOpening
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  '🎁 선물 개봉하기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PFStardust',
                  ),
                ),
        ),
      ),
    );
  }
}
