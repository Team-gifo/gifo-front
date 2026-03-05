import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/gift_request.dart';

part 'gift_api.g.dart';

// Retrofit 기반 API 인터페이스 정의
// 실제 서버 연동 시 baseUrl을 설정하고 Dio 인스턴스를 주입
@RestApi()
abstract class GiftApi {
  factory GiftApi(Dio dio, {String baseUrl}) = _GiftApi;

  // 선물 포장 데이터를 서버에 전송
  @POST('/api/gifts')
  Future<HttpResponse<dynamic>> createGift(@Body() GiftRequest request);
}
