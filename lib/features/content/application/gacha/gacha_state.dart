part of 'gacha_bloc.dart';

class GachaState {
  final String userName;
  // 공유 링크 및 QR 코드 생성에 사용되는 초대 코드
  final String inviteCode;
  final GachaContent? gachaContent;
  final int remainingCount;
  final List<Map<String, dynamic>> history;
  final GachaItem? lastDrawnItem;

  const GachaState({
    this.userName = '',
    this.inviteCode = '',
    this.gachaContent,
    this.remainingCount = 0,
    this.history = const <Map<String, dynamic>>[],
    this.lastDrawnItem,
  });

  GachaState copyWith({
    String? userName,
    String? inviteCode,
    GachaContent? gachaContent,
    int? remainingCount,
    List<Map<String, dynamic>>? history,
    GachaItem? lastDrawnItem,
  }) {
    return GachaState(
      userName: userName ?? this.userName,
      inviteCode: inviteCode ?? this.inviteCode,
      gachaContent: gachaContent ?? this.gachaContent,
      remainingCount: remainingCount ?? this.remainingCount,
      history: history ?? this.history,
      lastDrawnItem: lastDrawnItem,
    );
  }
}
