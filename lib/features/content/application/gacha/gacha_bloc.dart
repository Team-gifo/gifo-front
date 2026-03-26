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
    on<ClearLastDrawnItem>(_onClearLastDrawnItem);
  }

  // 더미 데이터 기반 초기화 (추후 서버 데이터로 교체 예정)
  void _onInitGacha(InitGacha event, Emitter<GachaState> emit) {
    final LobbyData? lobbyData = LobbyData.getDummyByCode(event.code);
    if (lobbyData == null || lobbyData.content?.gacha == null) return;

    final GachaContent gacha = lobbyData.content!.gacha!;
    emit(
      state.copyWith(
        userName: lobbyData.user,
        gachaContent: gacha,
        remainingCount: gacha.playCount,
        history: const <Map<String, dynamic>>[],
        lastDrawnItem: null,
      ),
    );
  }

  // 캡슐 뽑기 실행
  void _onDrawGacha(DrawGacha event, Emitter<GachaState> emit) {
    if (state.remainingCount <= 0 || state.gachaContent == null) return;

    final List<GachaItem> items = state.gachaContent!.list;
    final GachaItem randomItem = items[Random().nextInt(items.length)];

    emit(
      state.copyWith(
        remainingCount: state.remainingCount - 1,
        lastDrawnItem: randomItem,
      ),
    );
  }

  void _onResetGacha(ResetGacha event, Emitter<GachaState> emit) {
    emit(const GachaState());
  }

  // 결과 모달 닫기 후 lastDrawnItem 초기화 및 히스토리 추가
  void _onClearLastDrawnItem(
    ClearLastDrawnItem event,
    Emitter<GachaState> emit,
  ) {
    if (state.lastDrawnItem == null) return;

    final String timeStr = _formatTime(DateTime.now());
    final List<Map<String, dynamic>> newHistory = <Map<String, dynamic>>[
      <String, dynamic>{'time': timeStr, 'item': state.lastDrawnItem},
      ...state.history,
    ];

    emit(
      state.copyWith(
        lastDrawnItem: null,
        history: newHistory,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final int month = time.month;
    final int day = time.day;
    final int hour = time.hour;
    final String minute = time.minute.toString().padLeft(2, '0');
    final String ampm = hour < 12 ? '오전' : '오후';
    final int hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$month월 $day일 $ampm $hour12시 $minute분';
  }
}
