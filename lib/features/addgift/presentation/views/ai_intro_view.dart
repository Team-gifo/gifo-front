import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/addgift_scaffold.dart';

/// AI 추천 선물 포장 진입 화면 (플레이스홀더)
/// 실제 AI 플로우는 세동이와 협의 후 이 파일만 수정
class AiIntroView extends StatelessWidget {
  const AiIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return AddgiftScaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        backgroundColor: AppColors.darkBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 72,
                  color: AppColors.neonPurple.withValues(alpha: 0.8),
                ),
                const SizedBox(height: 32),
                const Text(
                  'AI 추천 기능\n준비 중이에요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PFStardustS',
                    fontSize: 28,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '더 멋진 선물 포장 경험을 위해\n열심히 준비하고 있습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'WantedSans',
                    fontSize: 16,
                    color: Colors.white54,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/addgift'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.edit_rounded, size: 20),
                    label: const Text(
                      '직접 입력으로 전환',
                      style: TextStyle(
                        fontFamily: 'WantedSans',
                        fontSize: 17,
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
    );
  }
}
