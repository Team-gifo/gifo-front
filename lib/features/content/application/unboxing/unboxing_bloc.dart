import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../lobby/model/lobby_data.dart';

part 'unboxing_event.dart';
part 'unboxing_state.dart';

// 바로 오픈(언박싱) 콘텐츠 상태 관리 BLoC
class UnboxingBloc extends Bloc<UnboxingEvent, UnboxingState> {
  UnboxingBloc() : super(const UnboxingState()) {
    on<InitUnboxing>(_onInitUnboxing);
    on<ReceiveGift>(_onReceiveGift);
    on<ResetUnboxing>(_onResetUnboxing);
  }

  // LobbyBloc에서 전달받은 LobbyData로 언박싱 상태 초기화
  void _onInitUnboxing(InitUnboxing event, Emitter<UnboxingState> emit) {
    final LobbyData lobbyData = event.lobbyData;
    if (lobbyData.content?.unboxing == null) return;

    final UnboxingContent unboxing = lobbyData.content!.unboxing!;
    emit(
      state.copyWith(
        userName: lobbyData.user,
        subTitle: lobbyData.subTitle,
        inviteCode: event.inviteCode,
        unboxingContent: unboxing,
        isReceived: false,
      ),
    );
  }

  // 선물 받기 처리
  void _onReceiveGift(ReceiveGift event, Emitter<UnboxingState> emit) {
    emit(state.copyWith(isReceived: true));
  }

  void _onResetUnboxing(ResetUnboxing event, Emitter<UnboxingState> emit) {
    emit(const UnboxingState());
  }
}
