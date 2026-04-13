import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../lobby/model/lobby_data.dart';
import '../../repository/content_repository.dart';

part 'unboxing_event.dart';
part 'unboxing_state.dart';

// 바로 오픈(언박싱) 콘텐츠 상태 관리 BLoC
class UnboxingBloc extends Bloc<UnboxingEvent, UnboxingState> {
  final ContentRepository repository;

  UnboxingBloc({required this.repository}) : super(const UnboxingState()) {
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

  // 선물 받기 처리 (비동기 처리로 변경하여 API 연동 구조에 맞춤)
  Future<void> _onReceiveGift(ReceiveGift event, Emitter<UnboxingState> emit) async {
    if (state.isOpening) return;

    emit(state.copyWith(isOpening: true));

    // 현재는 바로 정보가 LobbyData에 포함되어 있으므로 추가 API 호출 없이 시뮬레이션
    // 필요 시 repository.receiveUnboxingGift(state.inviteCode) 호출 가능
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    emit(state.copyWith(
      isReceived: true,
      isOpening: false,
    ));
  }

  void _onResetUnboxing(ResetUnboxing event, Emitter<UnboxingState> emit) {
    emit(const UnboxingState());
  }
}
