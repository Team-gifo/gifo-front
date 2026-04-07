import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../lobby/model/lobby_data.dart';
import '../../repository/content_repository.dart';

part 'gacha_event.dart';
part 'gacha_state.dart';

// 캡슐 뽑기 콘텐츠 상태 관리 BLoC
class GachaBloc extends Bloc<GachaEvent, GachaState> {
  final ContentRepository repository;

  GachaBloc({required this.repository}) : super(const GachaState()) {
    on<InitGacha>(_onInitGacha);
    on<DrawGacha>(_onDrawGacha);
    on<ResetGacha>(_onResetGacha);
    on<ClearLastDrawnItem>(_onClearLastDrawnItem);
  }

  // LobbyBloc에서 전달받은 LobbyData로 가챠 상태 초기화
  void _onInitGacha(InitGacha event, Emitter<GachaState> emit) {
    final LobbyData lobbyData = event.lobbyData;
    if (lobbyData.content?.gacha == null) return;

    final GachaContent gacha = lobbyData.content!.gacha!;
    emit(
      state.copyWith(
        userName: lobbyData.user,
        inviteCode: event.inviteCode,
        gachaContent: gacha,
        remainingCount: gacha.playCount,
        history: const <Map<String, dynamic>>[],
        lastDrawnItem: null,
      ),
    );
  }

  // 캡슐 뽑기 실행 (서버 API 호출)
  Future<void> _onDrawGacha(DrawGacha event, Emitter<GachaState> emit) async {
    if (state.remainingCount <= 0 || state.isDrawing) return;

    emit(state.copyWith(isDrawing: true));

    try {
      final response = await repository.drawCapsule(state.inviteCode);
      
      if (response != null && response.data != null) {
        final gachaResult = GachaItem(
          itemName: response.data!.giftName,
          imageUrl: response.data!.giftImageUrl,
          percent: 0.0,
          percentOpen: false,
          capsuleId: response.data!.capsuleId,
          description: response.data!.description,
        );

        emit(
          state.copyWith(
            remainingCount: state.remainingCount - 1,
            lastDrawnItem: gachaResult,
            isDrawing: false,
          ),
        );
      } else {
        // API 실패 시 로컬 더미 처리 혹은 에러 상태 (현재는 로직상 API 성공 가정)
        emit(state.copyWith(isDrawing: false));
      }
    } catch (e) {
      emit(state.copyWith(isDrawing: false));
    }
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
