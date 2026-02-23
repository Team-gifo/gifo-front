import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';

class PackageCompleteView extends StatefulWidget {
  const PackageCompleteView({super.key});

  @override
  State<PackageCompleteView> createState() => _PackageCompleteViewState();
}

class _PackageCompleteViewState extends State<PackageCompleteView> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // 뷰가 그려진 직후 색종이 애니메이션 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        context.go('/');
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // 뒤로가기 숨김
          title: Image.asset('assets/images/title_logo.png', height: 40),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              // 상단 중앙에서 하단으로 내리는 컨페티 애니메이션
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality:
                      BlastDirectionality.explosive, // 부채꼴/사방으로 흩뿌림
                  emissionFrequency: 0.02, // 빈도
                  numberOfParticles: 8, // 개수
                  maxBlastForce: 50, // 더 세게 흩뿌림
                  minBlastForce: 20,
                  gravity: 1.0, // 더 빠르게 떨어지게 함
                  colors: const <Color>[
                    Colors.redAccent,
                    Colors.blueAccent,
                    Colors.yellowAccent,
                    Colors.greenAccent,
                    Colors.purpleAccent,
                    Colors.orangeAccent,
                  ],
                ),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '소중한 마음이 잘 전달될 거예요.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 스토어로 돌아가거나 등 다른 라우팅 추가 예정
                  isPackageComplete = false;
                  context.go('/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6DE1F1), // 하늘색 톤
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '홈으로 돌아가기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
