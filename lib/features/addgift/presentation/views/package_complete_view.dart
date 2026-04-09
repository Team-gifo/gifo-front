import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../../core/widgets/shared_confetti_widget.dart';
import '../../application/gift_packaging_bloc.dart';

class PackageCompleteView extends StatefulWidget {
  const PackageCompleteView({super.key});

  @override
  State<PackageCompleteView> createState() => _PackageCompleteViewState();
}

class _PackageCompleteViewState extends State<PackageCompleteView> {
  Future<void> _shareLink(GiftPackagingState state) async {
    final String message =
        """
[Gifo]
'${state.receiverName}'님만을 위한 선물을 준비하였습니다. 🎁

아래 사이트에 접속해서 확인해주세요! 🎉

초대 코드 : ${state.shareCode}

https://gifo.co.kr/gift/code/${state.shareUrl}
"""
            .trim();
    await Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '선물 포장하기 - Gifo',
      color: AppColors.darkBg,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          if (didPop) return;
          context.go('/');
        },
        child: Scaffold(
          backgroundColor: AppColors.darkBg,
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: CustomPaint(painter: GridBackgroundPainter()),
              ),
              SafeArea(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints viewportConstraints) {
                    return SingleChildScrollView(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 800,
                            minHeight: viewportConstraints.maxHeight,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 40,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 20),
                                Image.asset(
                                  'assets/images/title_logo.png',
                                  height: 80,
                                  fit: BoxFit.contain,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 128),
                                SvgPicture.asset(
                                  'assets/images/pixel_gift.svg',
                                  width: 150,
                                  height: 150,
                                ),
                                const SizedBox(height: 32),
                                const Text(
                                  '선물 포장이 완료되었어요!',
                                  style: TextStyle(
                                    fontFamily: 'PFStardust',
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  '소중한 마음이 잘 전달될 거예요.',
                                  style: TextStyle(
                                    fontFamily: 'WantedSans',
                                    fontSize: 16,
                                    color: Colors.white60,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                BlocBuilder<
                                  GiftPackagingBloc,
                                  GiftPackagingState
                                >(
                                  builder: (context, state) {
                                    final String displayCode =
                                        state.shareCode.isNotEmpty
                                        ? state.shareCode
                                        : '-';
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Text(
                                          '초대코드 : ',
                                          style: TextStyle(
                                            fontFamily: 'WantedSans',
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: SelectableText(
                                            displayCode,
                                            style: const TextStyle(
                                              fontFamily: 'WantedSans',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.neonPurpleLight,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: state.shareCode.isEmpty
                                              ? null
                                              : () async {
                                                  await Clipboard.setData(
                                                    ClipboardData(
                                                      text:
                                                          """
[Gifo]
'${state.receiverName}'님만을 위한 선물을 준비하였습니다 🎁

아래 사이트에 접속해서 확인해주세요!🎉

초대 코드 : ${state.shareCode}

${state.shareUrl}
"""
                                                              .trim(),
                                                    ),
                                                  );
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                          '초대코드가 복사되었습니다.',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'WantedSans',
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            AppColors
                                                                .neonPurple,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                        width: 280,
                                                      ),
                                                    );
                                                  }
                                                },
                                          icon: Icon(
                                            Icons.copy_rounded,
                                            color: state.shareCode.isEmpty
                                                ? Colors.white24
                                                : Colors.white,
                                            size: 18,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          tooltip: '초대코드 복사',
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 128,
                                ), // Adjust to keep spacing consistent
                                LayoutBuilder(
                                  builder:
                                      (
                                        BuildContext context,
                                        BoxConstraints constraints,
                                      ) {
                                        final bool isCompact =
                                            constraints.maxWidth < 600;

                                        Widget shareButton =
                                            BlocBuilder<
                                              GiftPackagingBloc,
                                              GiftPackagingState
                                            >(
                                              builder:
                                                  (
                                                    BuildContext context,
                                                    GiftPackagingState state,
                                                  ) {
                                                    final bool hasShareUrl =
                                                        state
                                                            .shareUrl
                                                            .isNotEmpty;
                                                    return _buildPremiumActionButton(
                                                      onPressed: hasShareUrl
                                                          ? () => _shareLink(
                                                              state,
                                                            )
                                                          : null,
                                                      label: '공유하기',
                                                      icon: Icons.share_rounded,
                                                      isPrimary: true,
                                                    );
                                                  },
                                            );

                                        Widget homeButton =
                                            _buildPremiumActionButton(
                                              onPressed: () {
                                                context.go('/');
                                              },
                                              label: '홈으로 돌아가기',
                                              icon: Icons.home_rounded,
                                              isPrimary: false,
                                            );

                                        if (isCompact) {
                                          return Column(
                                            children: <Widget>[
                                              shareButton,
                                              const SizedBox(height: 12),
                                              homeButton,
                                            ],
                                          );
                                        } else {
                                          return Row(
                                            children: <Widget>[
                                              Expanded(child: shareButton),
                                              const SizedBox(width: 16),
                                              Expanded(child: homeButton),
                                            ],
                                          );
                                        }
                                      },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Align(
                alignment: Alignment.topCenter,
                child: SharedConfettiWidget(autoPlay: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumActionButton({
    required VoidCallback? onPressed,
    required String label,
    required IconData icon,
    required bool isPrimary,
  }) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(14),
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: isPrimary && onPressed != null
                  ? const LinearGradient(
                      colors: <Color>[Color(0xFFBC13FE), Color(0xFF8B5CF6)],
                    )
                  : null,
              color: !isPrimary || onPressed == null
                  ? const Color(0xFF1E1626)
                  : null,
              border: !isPrimary || onPressed == null
                  ? Border.all(
                      color: AppColors.neonPurple.withValues(alpha: 0.4),
                    )
                  : null,
              boxShadow: isPrimary && onPressed != null
                  ? <BoxShadow>[
                      BoxShadow(
                        color: AppColors.neonPurple.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon,
                    color: onPressed == null
                        ? Colors.white38
                        : (isPrimary ? Colors.white : AppColors.neonPurple),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'WantedSans',
                      fontSize: 16,
                      color: onPressed == null ? Colors.white38 : Colors.white,
                      fontWeight: FontWeight.bold,
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
