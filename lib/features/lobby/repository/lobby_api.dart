import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/lobby_response.dart';

part 'lobby_api.g.dart';

// Retrofit 기반 로비 API 인터페이스 (수신자 진입 전용)
@RestApi()
abstract class LobbyApi {
  factory LobbyApi(Dio dio, {String baseUrl}) = _LobbyApi;

  // 초대 코드(eventUrl)로 이벤트 데이터 조회
  @GET('/api/events/{eventUrl}')
  Future<LobbyResponse> getEvent(
    @Path('eventUrl') String eventUrl,
  );
}
