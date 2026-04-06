part of 'lobby_bloc.dart';

// ---- Lobby BLoC 이벤트 정의 ----

sealed class LobbyEvent {}

// 초대 코드를 제출하여 서버에 이벤트 데이터 요청
class FetchLobbyData extends LobbyEvent {
  final String code;
  FetchLobbyData(this.code);
}

// 상태 초기화 (모달 닫기 등)
class ResetLobby extends LobbyEvent {}
