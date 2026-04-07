part of 'lobby_bloc.dart';

// 코드 검증 및 데이터 로딩 처리 단계를 명확히 구분
enum LobbyStatus {
  idle,     // 초기 상태
  loading,  // API 요청 중 (로딩 인디케이터 표시)
  success,  // 데이터 수신 완료
  failure,  // 유효하지 않은 코드 또는 서버 오류
}

class LobbyState {
  final LobbyStatus status;
  // API 응답으로 받은 전체 로비 데이터
  final LobbyData? lobbyData;
  // 유효성이 확인된 코드 (이후 라우팅에 재사용)
  final String? validatedCode;
  // failure 상태일 때 사용자에게 보여줄 메시지
  final String? errorMessage;

  const LobbyState({
    this.status = LobbyStatus.idle,
    this.lobbyData,
    this.validatedCode,
    this.errorMessage,
  });

  LobbyState copyWith({
    LobbyStatus? status,
    LobbyData? lobbyData,
    String? validatedCode,
    String? errorMessage,
  }) {
    return LobbyState(
      status: status ?? this.status,
      lobbyData: lobbyData ?? this.lobbyData,
      validatedCode: validatedCode ?? this.validatedCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory LobbyState.initial() => const LobbyState();
}
