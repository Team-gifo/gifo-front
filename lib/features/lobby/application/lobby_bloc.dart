import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/lobby_data.dart';
import '../repository/lobby_repository.dart';

part 'lobby_event.dart';
part 'lobby_state.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  final LobbyRepository _repository;

  LobbyBloc({LobbyRepository? repository})
      : _repository = repository ?? LobbyRepository(),
        super(LobbyState.initial()) {
    on<SubmitInviteCode>(_onSubmitInviteCode);
    on<ResetLobby>(_onResetLobby);
  }

  // 초대 코드 제출: repository를 통해 데이터 조회 후 유효성 판단
  Future<void> _onSubmitInviteCode(
    SubmitInviteCode event,
    Emitter<LobbyState> emit,
  ) async {
    final String code = event.code.trim();
    if (code.isEmpty) return;

    emit(state.copyWith(status: LobbyCodeStatus.loading));

    final LobbyData? data = await _repository.fetchByCode(code);

    if (data != null) {
      // 유효한 코드: validatedCode를 저장하여 뷰가 라우팅에 사용
      emit(state.copyWith(
        status: LobbyCodeStatus.valid,
        validatedCode: code,
      ));
    } else {
      emit(state.copyWith(status: LobbyCodeStatus.invalid));
    }
  }

  void _onResetLobby(ResetLobby event, Emitter<LobbyState> emit) {
    emit(LobbyState.initial());
  }
}
