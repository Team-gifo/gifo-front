import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';

// ==========================================
// 앱 전반에서 재사용 가능한 클립보드 공유 유틸리티
//
// 사용처: GachaHistoryPanel, ResultView
// ==========================================
abstract final class ShareHelper {
  ShareHelper._();

  /// 당첨 결과 목록을 클립보드에 복사하고 토스트를 표시한다.
  ///
  /// [context]      : 토스트 표시를 위한 BuildContext
  /// [userName]     : 수신자 이름
  /// [inviteCode]   : 초대 코드 (링크 생성에 사용)
  /// [itemNames]    : 당첨 아이템 이름 목록
  static void shareResultToClipboard({
    required BuildContext context,
    required String userName,
    required String inviteCode,
    required List<String> itemNames,
  }) {
    if (itemNames.isEmpty) return;

    final String origin = Uri.base.origin;
    final String link = '$origin/gift/code/$inviteCode';

    final String message = '''[ Gifo ]
"$userName"님이 당신이 준비해 주신 선물을 뽑았습니다!

🎉 당첨 목록 🎉
${itemNames.map((String name) => '- $name').join('\n')}

당첨된 결과에 대해 기쁜 마음으로 선물해주세요!

"$link"''';

    Clipboard.setData(ClipboardData(text: message)).then((_) {
      if (!context.mounted) return;
      toastification.show(
        context: context,
        title: const Text(
          '클립보드에 복사되었습니다. 친구에게 공유해주세요!',
          style: TextStyle(fontFamily: 'WantedSans', fontSize: 13),
        ),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.minimal,
        alignment: Alignment.topCenter,
      );
    });
  }
}
