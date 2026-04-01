import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../../core/widgets/shared_confetti_widget.dart';
import '../../application/gift_packaging_bloc.dart';

class PackageCompleteView extends StatefulWidget {
  const PackageCompleteView({super.key});

  @override
  State<PackageCompleteView> createState() => _PackageCompleteViewState();
}

class _PackageCompleteViewState extends State<PackageCompleteView> {
  Future<void> _copyLink(String shareUrl) async {
    await Clipboard.setData(ClipboardData(text: shareUrl));
    if (!mounted) return;
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: const Text('링크가 복사되었어요!'),
      description: const Text('친구에게 공유해보세요.'),
      autoCloseDuration: const Duration(seconds: 3),
    );
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
          appBar: AppBar(
            toolbarHeight: 68,
            backgroundColor: AppColors.darkBg,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Image.asset('assets/images/title_logo.png', height: 40),
            centerTitle: false,
          ),
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: CustomPaint(painter: GridBackgroundPainter()),
              ),
              SafeArea(
                child: Stack(
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.topCenter,
                      child: SharedConfettiWidget(autoPlay: true),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/images/pixel_gift.svg',
                            width: 150,
                            height: 150,
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            '선물 포장이 완료되었어요!',
                            style: TextStyle(
                              fontFamily: 'PFStardustS',
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BlocBuilder<GiftPackagingBloc, GiftPackagingState>(
                    builder: (
                      BuildContext context,
                      GiftPackagingState state,
                    ) {
                      final bool hasShareUrl = state.shareUrl.isNotEmpty;
                      return SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: hasShareUrl
                              ? () => _copyLink(state.shareUrl)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.neonPurple,
                            disabledBackgroundColor: Colors.white12,
                            disabledForegroundColor: Colors.white38,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.link_rounded, size: 22),
                          label: const Text(
                            '링크 복사하기',
                            style: TextStyle(
                              fontFamily: 'WantedSans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        isPackageComplete = false;
                        context.go('/');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neonBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.home_rounded, size: 22),
                      label: const Text(
                        '홈으로 돌아가기',
                        style: TextStyle(
                          fontFamily: 'WantedSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
