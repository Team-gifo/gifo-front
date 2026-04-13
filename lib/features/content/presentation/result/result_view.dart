import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/gift_image_widget.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../../core/widgets/shared_confetti_widget.dart';
import '../../application/result/result_bloc.dart';

class ResultView extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  final String userName;
  final String inviteCode;

  const ResultView({
    super.key,
    required this.itemName,
    required this.imageUrl,
    this.userName = '',
    this.inviteCode = '',
  });

  @override
  Widget build(BuildContext context) {
    // 결과 화면에 필요한 ResultBloc 주입
    // DownloadBloc은 라우트 상위에서 주입되어 있어야 한다
    return BlocProvider<ResultBloc>(
      create: (_) => ResultBloc(),
      child: _ResultBody(
        itemName: itemName,
        imageUrl: imageUrl,
        userName: userName,
        inviteCode: inviteCode,
      ),
    );
  }
}

class _ResultBody extends StatefulWidget {
  final String itemName;
  final String imageUrl;
  final String userName;
  final String inviteCode;

  const _ResultBody({
    required this.itemName,
    required this.imageUrl,
    required this.userName,
    required this.inviteCode,
  });

  @override
  State<_ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<_ResultBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showText = false;
  bool _showButtons = false;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // 다소 빠른 속도
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // 딜레이 없이 즉시 이미지 팝업 애니메이션 시작
    _animationController.forward().then((_) {
      // 크기가 다 커진 후 타이핑 애니메이션 플래그 활성화
      if (mounted) {
        setState(() {
          _showText = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= AppBreakpoints.desktop;
    final bool isTablet = screenWidth >= AppBreakpoints.tablet;

    return Title(
      title: 'Happy Birthday, ${widget.userName} | Gifo',
      color: Colors.black,
      child: Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Stack(
          children: <Widget>[
            // 그리드 배경
            Positioned.fill(
              child: CustomPaint(painter: GridBackgroundPainter()),
            ),
            // 상단 색종이 효과 (타이핑 끝난 후 터짐)
            if (_showConfetti)
              const Align(
                alignment: Alignment.topCenter,
                child: SharedConfettiWidget(autoPlay: true),
              ),
            // 메인 콘텐츠
            SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isDesktop ? 800 : double.infinity,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 48 : 24,
                        vertical: isDesktop ? 60 : 40,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildLogoAndCongrats(isTablet),
                          SizedBox(height: isDesktop ? 48 : 32),
                          _buildItemImage(isDesktop, isTablet),
                          SizedBox(height: isDesktop ? 40 : 28),
                          _buildItemNameCard(isDesktop),
                          SizedBox(height: isDesktop ? 48 : 36),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            child: _showButtons
                                ? _buildActionRow(context)
                                : const SizedBox(
                                    height: 56,
                                    width: double.infinity,
                                  ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
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

  // 상단 로고 및 축하 메시지
  Widget _buildLogoAndCongrats(bool isTabletOrLarger) {
    return Column(
      children: <Widget>[
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              final Uri homeUri = Uri.base.resolve('/');
              if (await canLaunchUrl(homeUri)) {
                await launchUrl(homeUri, webOnlyWindowName: '_blank');
              } else {
                if (mounted) context.go('/');
              }
            },
            child: Image.asset(
              'assets/images/title_logo.png',
              height: 60,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '생일 축하드립니다!',
          style: TextStyle(
            fontFamily: 'PFStardust',
            fontSize: isTabletOrLarger ? 38 : 24,
            color: Colors.white.withValues(alpha: 0.9),
            letterSpacing: 1,
            shadows: <Shadow>[
              Shadow(
                color: AppColors.neonPurple.withValues(alpha: 0.5),
                blurRadius: 10,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildItemImage(bool isDesktop, bool isTablet) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: isDesktop ? 480 : (isTablet ? 380 : 300),
          maxWidth: isDesktop ? 560 : (isTablet ? 440 : double.infinity),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: GiftImageWidget(
            width: 400,
            height: 400,
            imageUrl: widget.imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  // 당첨 아이템 이름 카드
  Widget _buildItemNameCard(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF130E1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: <Widget>[
          const Text(
            '선물 결과',
            style: TextStyle(
              fontFamily: 'WantedSans',
              fontSize: 16,
              color: AppColors.neonPurpleLight,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          if (_showText)
            AnimatedTextKit(
              animatedTexts: <AnimatedText>[
                TyperAnimatedText(
                  widget.itemName,
                  speed: const Duration(milliseconds: 80),
                  textStyle: TextStyle(
                    fontFamily: 'WantedSans',
                    fontWeight: FontWeight.bold,
                    fontSize: isDesktop ? 30 : 22,
                    color: Colors.white,
                    letterSpacing: 1,
                    shadows: <Shadow>[
                      Shadow(
                        color: AppColors.neonPurple.withValues(alpha: 0.5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              isRepeatingAnimation: false,
              displayFullTextOnTap: true,
              onFinished: () {
                if (mounted) {
                  setState(() {
                    _showButtons = true;
                    _showConfetti = true;
                  });
                }
              },
            )
          else
            // 빈 공간 확보 (점프 방지)
            SizedBox(height: isDesktop ? 35 : 26),
        ],
      ),
    );
  }

  // 공유 / 다운로드 버튼 Row
  Widget _buildActionRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _ShareButton(
            userName: widget.userName,
            inviteCode: widget.inviteCode,
            itemName: widget.itemName,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DownloadButton(
            itemName: widget.itemName,
            imageUrl: widget.imageUrl,
            userName: widget.userName,
            inviteCode: widget.inviteCode,
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 친구에게 결과 공유하기 버튼
// ShareHelper 대신 Native Share API를 사용하도록 변경
// ==========================================
class _ShareButton extends StatelessWidget {
  final String userName;
  final String inviteCode;
  final String itemName;

  const _ShareButton({
    required this.userName,
    required this.inviteCode,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Material(
        borderRadius: BorderRadius.circular(14),
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final String message =
                """
[Gifo]
"$userName"님이 당신이 준비해 주신 선물을 뽑았습니다! 🎁

🎉  당첨 목록  🎉
- $itemName

당첨된 결과에 대해 기쁜 마음으로 선물해주세요! 🎉

https://gifo.co.kr/gift/code/$inviteCode
"""
                    .trim();

            await Share.share(message);
          },
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFFBC13FE), Color(0xFF8B5CF6)],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.neonPurple.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.share_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '친구에게 결과 공유',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'WantedSans',
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 이미지 다운로드 버튼
// ResultBloc -> DownloadBloc 위임 처리
// ==========================================
class _DownloadButton extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  final String userName;
  final String inviteCode;

  const _DownloadButton({
    required this.itemName,
    required this.imageUrl,
    required this.userName,
    required this.inviteCode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResultBloc, ResultState>(
      builder: (BuildContext context, ResultState state) {
        final bool isLoading =
            state.downloadStatus == ResultDownloadStatus.loading;

        return SizedBox(
          height: 56,
          child: Material(
            borderRadius: BorderRadius.circular(14),
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading
                  ? null
                  : () => context.read<ResultBloc>().add(
                      DownloadGifticonEvent(
                        context: context,
                        itemName: itemName,
                        imageUrl: imageUrl,
                        userName: userName,
                        inviteCode: inviteCode,
                      ),
                    ),
              borderRadius: BorderRadius.circular(14),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFF1E1626),
                  border: Border.all(
                    color: AppColors.neonPurple.withValues(alpha: 0.4),
                  ),
                ),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.neonPurple,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.file_download_outlined,
                              color: AppColors.neonPurple,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '이미지 다운로드',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'WantedSans',
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
