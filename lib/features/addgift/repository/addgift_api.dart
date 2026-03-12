import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/gift_request.dart';

part 'addgift_api.g.dart';

// Retrofit 기반 API 인터페이스 정의 (addgift 전용)
// 실제 서버 연동 시 baseUrl을 설정하고 Dio 인스턴스를 주입
@RestApi()
abstract class AddGiftApi {
  factory AddGiftApi(Dio dio, {String baseUrl}) = _AddGiftApi;

  // 선물 포장 데이터를 서버에 전송
  @POST('/api/events')
  Future<HttpResponse<dynamic>> createGift(
    @Body() Map<String, dynamic> request,
  );
}
