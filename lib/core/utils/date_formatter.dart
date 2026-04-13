class GifoDateFormatter {
  /// ISO 8601 문자열을 받아서 "MM월 dd일 a h시 mm분" 형식으로 변환합니다.
  /// 예: 2026-04-10T12:35:43.072076 -> 04월 10일 오후 12시 35분
  static String formatDrawnAt(String? drawnAt) {
    if (drawnAt == null || drawnAt.isEmpty) return '이전 기록';

    try {
      final DateTime dateTime = DateTime.parse(drawnAt).toLocal();

      final String period = dateTime.hour < 12 ? '오전' : '오후';
      final int displayHour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
      final String minute = dateTime.minute.toString().padLeft(2, '0');

      return '${dateTime.month}월 ${dateTime.day}일 $period $displayHour시 $minute분';
    } catch (e) {
      return '이전 기록';
    }
  }
}
