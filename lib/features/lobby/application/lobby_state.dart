part of 'lobby_bloc.dart';

// ---- Lobby BLoC 상태 정의 ----

// 코드 검증 처리 단계를 명확히 구분
enum LobbyCodeStatus { idle, loading, valid, invalid }

class LobbyState {
  final LobbyCodeStatus status;
  // 유효한 코드가 확인되면 해당 코드값을 보존 (라우팅에 사용)
  final String? validatedCode;

  const LobbyState({
    this.status = LobbyCodeStatus.idle,
    this.validatedCode,
  });

  LobbyState copyWith({
    LobbyCodeStatus? status,
    String? validatedCode,
  }) {
    return LobbyState(
      status: status ?? this.status,
      validatedCode: validatedCode ?? this.validatedCode,
    );
  }

  factory LobbyState.initial() => const LobbyState();
}
