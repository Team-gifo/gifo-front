import 'package:freezed_annotation/freezed_annotation.dart';

import 'lobby_data.dart';

part 'lobby_response.freezed.dart';
part 'lobby_response.g.dart';

// GET /events/{eventUrl} 응답의 최상위 래퍼
@freezed
abstract class LobbyResponse with _$LobbyResponse {
  const factory LobbyResponse({
    required String code,
    required String message,
    LobbyData? data,
  }) = _LobbyResponse;

  factory LobbyResponse.fromJson(Map<String, dynamic> json) =>
      _$LobbyResponseFromJson(json);
}
