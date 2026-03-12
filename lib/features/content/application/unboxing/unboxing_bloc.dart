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

  void _onInitUnboxing(InitUnboxing event, Emitter<UnboxingState> emit) {
    final lobbyData = LobbyData.getDummyByCode(event.code);
    if (lobbyData == null || lobbyData.content?.unboxing == null) return;

    final unboxing = lobbyData.content!.unboxing!;
    emit(
      state.copyWith(
        userName: lobbyData.user,
        subTitle: lobbyData.subTitle,
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
