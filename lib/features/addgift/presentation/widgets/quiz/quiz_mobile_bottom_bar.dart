import 'package:flutter/material.dart';

import 'quiz_complete_button.dart';

class QuizMobileBottomBar extends StatelessWidget {
  const QuizMobileBottomBar({
    super.key,
    required this.isSubmitting,
    required this.canComplete,
    required this.onShowSettings,
    required this.onComplete,
  });

  final bool isSubmitting;
  final bool canComplete;
  final VoidCallback onShowSettings;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          border: const Border(top: BorderSide(color: Colors.white12)),
        ),
        child: Row(
          children: <Widget>[
            const Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: Duration(seconds: 4),
              message: '⚠️ 포장 완료 조건\n'
                  '• 문제 최소 1개 이상 생성\n'
                  '• 상단 닉네임 및 서브타이틀 입력\n'
                  '• 미완성 문제 없음 (제목 + 정답 필수)\n'
                  '• 성공 보상 물품 이름 입력',
              child: Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.info_outline, size: 20, color: Colors.white38),
              ),
            ),
            InkWell(
              onTap: onShowSettings,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
                child: const Icon(Icons.settings, color: Colors.white60),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: QuizCompleteButton(
                enabled: canComplete && !isSubmitting,
                onPressed: onComplete,
                height: 56,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
