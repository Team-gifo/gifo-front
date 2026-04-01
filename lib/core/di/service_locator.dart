import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import '../../features/addgift/repository/addgift_api.dart';

final GetIt getIt = GetIt.instance;

// 앱 시작 시 호출하여 의존성을 등록
void setupServiceLocator() {
  final String rawBaseUrl = _readBaseUrlFromEnv();
  final String baseUrl = _sanitizeBaseUrl(rawBaseUrl);
  final Uri? parsedBaseUri = Uri.tryParse(baseUrl);
  final bool isValidBaseUrl =
      parsedBaseUri != null &&
      parsedBaseUri.hasScheme &&
      parsedBaseUri.host.isNotEmpty;

  if (kDebugMode) {
    debugPrint('[ServiceLocator] .env url(raw): "$rawBaseUrl"');
    debugPrint('[ServiceLocator] .env url(normalized): "$baseUrl"');
    if (!isValidBaseUrl) {
      debugPrint(
        '[ServiceLocator] 경고: API Base URL이 비어있거나 형식이 올바르지 않습니다. (.env 예시: url=https://gifo.co.kr)',
      );
    }
  }

  // Dio 설정 (BaseUrl + LogInterceptor)
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
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
}

String _sanitizeBaseUrl(String rawBaseUrl) {
  String sanitized = rawBaseUrl.trim();
  if (sanitized.length >= 2) {
    final bool wrappedBySingleQuotes =
        sanitized.startsWith("'") && sanitized.endsWith("'");
    final bool wrappedByDoubleQuotes =
        sanitized.startsWith('"') && sanitized.endsWith('"');
    if (wrappedBySingleQuotes || wrappedByDoubleQuotes) {
      sanitized = sanitized.substring(1, sanitized.length - 1).trim();
    }
  }
  return sanitized;
}

String _readBaseUrlFromEnv() {
  final String direct = dotenv.env['url'] ?? '';
  if (direct.isNotEmpty) return direct;

  for (final MapEntry<String, String> entry in dotenv.env.entries) {
    if (entry.key.trim().toLowerCase() == 'url') {
      return entry.value;
    }
  }
  return '';
}
