import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';


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

  // BGM 프리셋 목록 조회
  @GET('/api/bgm/presets')
  Future<HttpResponse<dynamic>> getBgmPresets();

  // 이미지 업로드 (type: MEMORY | GIFT | QUIZ)
  @POST('/api/images')
  @MultiPart()
  Future<HttpResponse<dynamic>> uploadImage(
    @Query('type') String type,
    @Part(name: 'file') MultipartFile file,
  );
}
