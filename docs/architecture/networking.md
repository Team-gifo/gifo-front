# 네트워킹 (Dio + Retrofit)

> 이 문서의 목적: HTTP 클라이언트 설정, API 클라이언트 구조, DI 등록 방식을 이해한다.

## 전체 구조

```
.env 파일 (url=https://...)
    ↓ dotenv.load()
Dio (BaseOptions + LogInterceptor)
    ↓ GetIt 등록
AddGiftApi (Retrofit 클라이언트)
    ↓ getIt<AddGiftApi>()
GiftPackagingBloc._onSubmitPackage()
```

## Dio 설정

**파일:** `lib/core/di/service_locator.dart`

```dart
final dio = Dio(
  BaseOptions(
    baseUrl: dotenv.env['url'] ?? '',   // .env에서 읽음
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

dio.interceptors.add(LogInterceptor(
  request: true,
  requestHeader: true,
  requestBody: true,
  responseBody: true,
  responseHeader: true,
));
```

## GetIt 서비스 로케이터

```dart
final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // ...Dio 설정...
  getIt.registerLazySingleton<AddGiftApi>(() => AddGiftApi(dio));
  getIt.registerLazySingleton<LobbyRepository>(() => LobbyRepository(LobbyApi(dio)));
  getIt.registerLazySingleton<ContentRepository>(() => ContentRepository(ContentApi(dio)));
}
```

`registerLazySingleton`: 첫 번째 `getIt<AddGiftApi>()` 호출 시 인스턴스 생성, 이후 재사용.

BLoC에서 사용:
```dart
final api = getIt<AddGiftApi>();
final response = await api.createGift(jsonMap);
```

## Retrofit API 클라이언트

### AddGiftApi

**파일:** `lib/features/addgift/repository/addgift_api.dart`

```dart
@RestApi()
abstract class AddGiftApi {
  factory AddGiftApi(Dio dio, {String baseUrl}) = _AddGiftApi;

  @POST('/api/events')
  Future<HttpResponse<dynamic>> createGift(@Body() Map<String, dynamic> body);
}
```

- `@RestApi()` - Retrofit 어노테이션, `_AddGiftApi` 구현체 코드 생성
- `@POST('/api/events')` - POST 메서드, 경로
- `@Body()` - 요청 바디 (JSON 직렬화됨)
- 반환: `HttpResponse<dynamic>` (응답 상태코드 등 접근 가능)

### ContentApi

**파일:** `lib/features/content/repository/content_api.dart`

```dart
@RestApi()
abstract class ContentApi {
  // 퀴즈 답안 제출
  @POST('/api/events/{eventUrl}/quiz/answer')
  @Headers(<String, dynamic>{'Content-Type': 'application/json'})
  Future<QuizAnswerResponse> submitQuizAnswer(
    @Path('eventUrl') String eventUrl,
    @Body() QuizAnswerRequest request,
  );

  // 퀴즈 결과 조회
  @POST('/api/events/{eventUrl}/quiz/result')
  @Headers(<String, dynamic>{'Content-Type': 'application/json'})
  Future<QuizResultResponse> getQuizResult(
    @Path('eventUrl') String eventUrl,
  );
}
```

- `@Headers`: 특정 모델(Freezed)을 전송할 때 Dio가 Content-Type을 누락하는 경우를 대비해 명시적으로 `application/json` 설정.
- `@Path`: URL 경로 내의 `{eventUrl}` 변수를 매핑.
- `@Body`: `toJson()`이 구현된 모델 객체를 JSON으로 자동 변환.

## 요청 데이터 구조

`GiftPackagingBloc._onSubmitPackage()`에서 `GiftRequest.toJson()`으로 직렬화:

```dart
final GiftRequest request = GiftRequest(
  user: event.receiverName,
  subTitle: event.subTitle,
  bgm: event.bgm,
  gallery: event.gallery,
  content: event.content,
);
final Map<String, dynamic> jsonMap = request.toJson();
await api.createGift(jsonMap);
```

**GiftRequest JSON 구조:**
```json
{
  "user": "받는 분 성함",
  "sub_title": "두근두근",
  "bgm": "bgm_1",
  "gallery": [
    { "title": "추억 제목", "image_url": "...", "description": "설명" }
  ],
  "content": {
    "gacha": { "play_count": 3, "list": [...] },
    "quiz": null,
    "unboxing": null
  }
}
```

## 환경 변수 (.env)

앱 루트의 `.env` 파일:
```
url=https://your-api-server.com
```

`pubspec.yaml`에 assets로 등록됨:
```yaml
assets:
  - .env
```

`main.dart`에서 앱 시작 시 로드:
```dart
await dotenv.load(fileName: '.env');
```

## 에러 처리

BLoC의 try-catch에서 처리:
```dart
try {
  final response = await api.createGift(jsonMap);
  emit(state.copyWith(submitStatus: SubmitStatus.success));
} catch (e, stackTrace) {
  debugPrint('[GiftPackagingBloc] 서버 전송 중 예외 발생!');
  emit(state.copyWith(submitStatus: SubmitStatus.failure));
}
```

View에서 `BlocListener`로 failure 상태 감지 → 에러 토스트 표시.
