import 'package:flutter/material.dart';

class GachaMobileBottomBar extends StatelessWidget {
  const GachaMobileBottomBar({
    super.key,
    required this.totalPercent,
    required this.itemCount,
    required this.canComplete,
    required this.onComplete,
    required this.onShowSettings,
  });

  final double totalPercent;
  final int itemCount;
  final bool canComplete;
  final VoidCallback onComplete;
  final VoidCallback onShowSettings;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          border: const Border(top: BorderSide(color: Colors.white12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: Duration(seconds: 4),
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.all(12),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  message:
                      '⚠️ 포장 완료 조건\n'
                      '• 캡슐 최소 1개 이상 생성\n'
                      '• 상단 닉네임 및 서브타이틀 입력\n'
                      '• 뽑기 가능 횟수 최소 1 이상\n'
                      '• 미완성 캡슐 없음\n'
                      '• 전체 확률 100% 충족',
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Colors.white38,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PFStardust',
                      color: Colors.white,
                    ),
                    children: <InlineSpan>[
                      const TextSpan(text: '전체 확률 : '),
                      TextSpan(
                        text: '${totalPercent.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color:
                              (totalPercent >= 99.99 && totalPercent <= 100.01)
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const TextSpan(text: ' / 100.00%'),
                      const TextSpan(text: ' [ '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Image.asset(
                          'assets/images/gacha.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                      TextSpan(
                        text: ' : $itemCount개 ]',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
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
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: canComplete ? onComplete : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canComplete
                            ? const Color(0xFF6DE1F1)
                            : Colors.grey.shade300,
                        disabledBackgroundColor: Colors.grey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        '포장 완료',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              canComplete ? Colors.black : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
