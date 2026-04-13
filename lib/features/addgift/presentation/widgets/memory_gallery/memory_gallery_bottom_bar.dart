import 'package:flutter/material.dart';

import '../../../../../core/constants/app_breakpoints.dart';
import '../../../../../core/constants/app_colors.dart';

class MemoryGalleryBottomBar extends StatelessWidget {
  const MemoryGalleryBottomBar({
    super.key,
    required this.itemCount,
    required this.canSave,
    required this.onComplete,
  });

  final int itemCount;
  final bool canSave;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isDesktop = screenWidth >= AppBreakpoints.desktop;
    final bool isMobile = screenWidth < 600;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: AppColors.darkBg,
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.photo_library_rounded,
                  size: 20,
                  color: Colors.white70,
                ),
                const SizedBox(width: 6),
                Text(
                  isMobile ? '[ $itemCount개 ]' : '추억 목록 [ $itemCount개 ]',
                  style: const TextStyle(
                    fontFamily: 'WantedSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 20),
                  // 추억 갯수 안내문구 추가
                  const Row(
                    children: <Widget>[
                      Icon(Icons.info_outline, color: Colors.yellow, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '최대 10개까지 등록이 가능합니다.',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 16,
                          fontFamily: 'WantedSans',
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            const Spacer(),
            const Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: Duration(seconds: 5),
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(12),
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.5,
              ),
              message:
                  '⚠️ 저장 완료 조건\n'
                  '• 추억 최소 1개 이상 등록\n'
                  '• 각 추억에 제목, 이미지, 설명 모두 입력',
              child: Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.info_outline, size: 20, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: canSave ? onComplete : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonPurple,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.white12,
                disabledForegroundColor: Colors.white38,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 18.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0,
              ),
              child: const Text(
                '추억 저장 완료',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
