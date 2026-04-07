part of 'gacha_bloc.dart';

class GachaState {
  final String userName;
  // 공유 링크 및 QR 코드 생성에 사용되는 초대 코드
  final String inviteCode;
  final GachaContent? gachaContent;
  final int remainingCount;
  final List<Map<String, dynamic>> history;
  final GachaItem? lastDrawnItem;
  final bool isDrawing; // API 호출 중 여부
  final bool isResultRefreshing; // 결과 모달 닫힌 후 데이터 백그라운드 새로고침 상태

  const GachaState({
    this.userName = '',
    this.inviteCode = '',
    this.gachaContent,
    this.remainingCount = 0,
    this.history = const <Map<String, dynamic>>[],
    this.lastDrawnItem,
    this.isDrawing = false,
    this.isResultRefreshing = false,
  });

  GachaState copyWith({
    String? userName,
    String? inviteCode,
    GachaContent? gachaContent,
    int? remainingCount,
    List<Map<String, dynamic>>? history,
    GachaItem? lastDrawnItem,
    bool? isDrawing,
    bool? isResultRefreshing,
  }) {
    return GachaState(
      userName: userName ?? this.userName,
      inviteCode: inviteCode ?? this.inviteCode,
      gachaContent: gachaContent ?? this.gachaContent,
      remainingCount: remainingCount ?? this.remainingCount,
      history: history ?? this.history,
      lastDrawnItem: lastDrawnItem,
      isDrawing: isDrawing ?? this.isDrawing,
      isResultRefreshing: isResultRefreshing ?? this.isResultRefreshing,
    );
  }
}
