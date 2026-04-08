import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import '../../features/addgift/repository/addgift_api.dart';
import '../../features/addgift/repository/curate_api.dart';

final GetIt getIt = GetIt.instance;

// 앱 시작 시 호출하여 의존성을 등록
void setupServiceLocator() {
  // Dio 설정 (BaseUrl + LogInterceptor)
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['url'] ?? '',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  // 로깅 인터셉터 추가 (요청/응답 바디 및 헤더 확인용)
  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
    ),
  );

  // AddGiftApi 등록
  getIt.registerLazySingleton<AddGiftApi>(() => AddGiftApi(dio));

  // CurateApi 등록 (AI 추천)
  getIt.registerLazySingleton<CurateApi>(() => CurateApi(dio));
}
