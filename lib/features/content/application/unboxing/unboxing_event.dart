part of 'unboxing_bloc.dart';

abstract class UnboxingEvent {
  const UnboxingEvent();
}

// LobbyBloc에서 수신한 LobbyData와 초대 코드를 직접 전달받아 초기화
class InitUnboxing extends UnboxingEvent {
  final LobbyData lobbyData;
  // 결과 화면 공유 링크에 사용되는 초대 코드
  final String inviteCode;
  const InitUnboxing(this.lobbyData, {this.inviteCode = ''});
}

// 선물 받기 실행
class ReceiveGift extends UnboxingEvent {
  const ReceiveGift();
}

// 상태 초기화
class ResetUnboxing extends UnboxingEvent {
  const ResetUnboxing();
}
