import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'curate_api.g.dart';

@RestApi()
abstract class CurateApi {
  factory CurateApi(Dio dio, {String baseUrl}) = _CurateApi;

  @POST('/curate/create')
  Future<HttpResponse<dynamic>> createCurate(
    @Body() Map<String, dynamic> request,
  );
}

