part of 'lobby_bloc.dart';

// ---- Lobby BLoC 이벤트 정의 ----

sealed class LobbyEvent {}

// 초대 코드를 제출하여 검증 요청
class SubmitInviteCode extends LobbyEvent {
  final String code;
  SubmitInviteCode(this.code);
}

// 상태 초기화 (모달 닫기 등)
class ResetLobby extends LobbyEvent {}
