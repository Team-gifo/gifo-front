import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'content_api.g.dart';

// Content 영역 API 인터페이스 (추후 서버 연동 시 엔드포인트 추가 예정)
@RestApi()
abstract class ContentApi {
  factory ContentApi(Dio dio, {String baseUrl}) = _ContentApi;

  // 초대코드 기반 콘텐츠 데이터 조회 (추후 구현 예정)
  @GET('/api/events/{code}')
  Future<HttpResponse<dynamic>> getContentByCode(@Path('code') String code);
}
