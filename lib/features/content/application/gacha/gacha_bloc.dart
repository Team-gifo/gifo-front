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
    final List<Map<String, dynamic>> loadedHistory = gacha.drawHistory.map((h) {
      return <String, dynamic>{
        'time': '이전 기록', 
        'item': GachaItem(
          itemName: h.giftName ?? '알 수 없음',
          imageUrl: h.giftImageUrl ?? '',
          percent: 0.0,
          percentOpen: false,
          capsuleId: h.capsuleId,
          description: h.description,
        ),
      };
    }).toList();

    emit(
      state.copyWith(
        userName: lobbyData.user,
        inviteCode: event.inviteCode,
        gachaContent: gacha,
        remainingCount: gacha.playCount,
        history: loadedHistory,
        lastDrawnItem: null,
        isResultRefreshing: false,
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
          itemName: response.data!.giftName ?? '',
          imageUrl: response.data!.giftImageUrl ?? '',
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

  // 결과 모달 닫기 후 lastDrawnItem 초기화 및 터치 불가용 로딩 플래그 활성화
  void _onClearLastDrawnItem(
    ClearLastDrawnItem event,
    Emitter<GachaState> emit,
  ) {
    if (state.lastDrawnItem == null) return;

    emit(
      state.copyWith(
        lastDrawnItem: null,
        isResultRefreshing: true, // 로비 데이터 갱신을 기다리는 상태 진입
      ),
    );
  }
}
