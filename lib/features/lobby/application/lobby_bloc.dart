import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/lobby_data.dart';
import '../repository/lobby_repository.dart';

part 'lobby_event.dart';
part 'lobby_state.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  final LobbyRepository _repository;

  LobbyBloc({required LobbyRepository repository})
      : _repository = repository,
        super(LobbyState.initial()) {
    on<FetchLobbyData>(_onFetchLobbyData);
    on<ResetLobby>(_onResetLobby);
  }

  // 초대 코드로 서버에 이벤트 데이터를 요청하고 상태를 갱신
  Future<void> _onFetchLobbyData(
    FetchLobbyData event,
    Emitter<LobbyState> emit,
  ) async {
    final String code = event.code.trim();
    if (code.isEmpty) return;

    emit(state.copyWith(status: LobbyStatus.loading));

    try {
      final LobbyData? data = await _repository.fetchByCode(code);

      if (data != null) {
        emit(state.copyWith(
          status: LobbyStatus.success,
          lobbyData: data,
          validatedCode: code,
        ));
      } else {
        emit(state.copyWith(
          status: LobbyStatus.failure,
          errorMessage: '유효하지 않은 초대 코드입니다.',
        ));
      }
    } catch (e, stackTrace) {
      debugPrint('[LobbyBloc] 이벤트 데이터 조회 중 오류 발생: $e');
      debugPrintStack(stackTrace: stackTrace);
      emit(state.copyWith(
        status: LobbyStatus.failure,
        errorMessage: '서버 연결에 실패했습니다. 잠시 후 다시 시도해주세요.',
      ));
    }
  }

  void _onResetLobby(ResetLobby event, Emitter<LobbyState> emit) {
    emit(LobbyState.initial());
  }
}
