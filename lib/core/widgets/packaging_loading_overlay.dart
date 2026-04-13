import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

// 포장하기 제출 중 전체 화면을 덮는 로딩 오버레이
// 이미지 업로드 + 이벤트 전송 완료 전까지 표시됩니다.
class PackagingLoadingOverlay extends StatelessWidget {
  const PackagingLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 40),
            decoration: BoxDecoration(
              color: AppColors.darkBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.neonBlue.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.neonBlue.withValues(alpha: 0.15),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.neonBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  '선물을 포장하고 있어요...',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'WantedSans',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '잠시만 기다려 주세요.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.5),
                    fontFamily: 'WantedSans',
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
