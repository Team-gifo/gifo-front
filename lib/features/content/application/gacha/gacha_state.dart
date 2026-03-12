part of 'gacha_bloc.dart';

class GachaState {
  final String userName;
  final GachaContent? gachaContent;
  final int remainingCount;
  final List<Map<String, String>> history;
  final GachaItem? lastDrawnItem;

  const GachaState({
    this.userName = '',
    this.gachaContent,
    this.remainingCount = 0,
    this.history = const [],
    this.lastDrawnItem,
  });

  GachaState copyWith({
    String? userName,
    GachaContent? gachaContent,
    int? remainingCount,
    List<Map<String, String>>? history,
    GachaItem? lastDrawnItem,
  }) {
    return GachaState(
      userName: userName ?? this.userName,
      gachaContent: gachaContent ?? this.gachaContent,
      remainingCount: remainingCount ?? this.remainingCount,
      history: history ?? this.history,
      lastDrawnItem: lastDrawnItem,
    );
  }
}
