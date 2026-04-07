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

// 화면을 막지 않고 로비 데이터만 백그라운드 갱신
class SilentRefreshLobbyData extends LobbyEvent {}

// 기존 데이터를 바탕으로 로비 상태를 초기화 (API 호출 없이 GachaView 등에서 재사용 시 활용)
class InitLobbyWithData extends LobbyEvent {
  final LobbyData data;
  final String code;
  InitLobbyWithData({required this.data, required this.code});
}
