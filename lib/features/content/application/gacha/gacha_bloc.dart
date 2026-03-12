import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../lobby/model/lobby_data.dart';

part 'gacha_event.dart';
part 'gacha_state.dart';

// 캡슐 뽑기 콘텐츠 상태 관리 BLoC
class GachaBloc extends Bloc<GachaEvent, GachaState> {
  GachaBloc() : super(const GachaState()) {
    on<InitGacha>(_onInitGacha);
    on<DrawGacha>(_onDrawGacha);
    on<ResetGacha>(_onResetGacha);
  }

  // 더미 데이터 기반 초기화 (추후 서버 데이터로 교체 예정)
  void _onInitGacha(InitGacha event, Emitter<GachaState> emit) {
    final lobbyData = LobbyData.getDummyByCode(event.code);
    if (lobbyData == null || lobbyData.content?.gacha == null) return;

    final gacha = lobbyData.content!.gacha!;
    emit(
      state.copyWith(
        userName: lobbyData.user,
        gachaContent: gacha,
        remainingCount: gacha.playCount,
        history: const [],
        lastDrawnItem: null,
      ),
    );
  }

  // 캡슐 뽑기 실행
  void _onDrawGacha(DrawGacha event, Emitter<GachaState> emit) {
    if (state.remainingCount <= 0 || state.gachaContent == null) return;

    final items = state.gachaContent!.list;
    final randomItem = items[Random().nextInt(items.length)];
    final timeStr = _formatTime(DateTime.now());

    final newHistory = [
      {'time': timeStr, 'item': randomItem.itemName},
      ...state.history,
    ];

    emit(
      state.copyWith(
        remainingCount: state.remainingCount - 1,
        history: newHistory,
        lastDrawnItem: randomItem,
      ),
    );
  }

  void _onResetGacha(ResetGacha event, Emitter<GachaState> emit) {
    emit(const GachaState());
  }

  String _formatTime(DateTime time) {
    final month = time.month;
    final day = time.day;
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final ampm = hour < 12 ? '오전' : '오후';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$month월 $day일 $ampm $hour12시 $minute분';
  }
}
