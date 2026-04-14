# 코딩 컨벤션

> 이 문서의 목적: 이 프로젝트의 코딩 스타일, 패턴, 네이밍 규칙을 이해한다.

## 린트 규칙 (`analysis_options.yaml`)

엄격한 린트 규칙이 적용되어 있다:

- **타입 명시:** 타입 추론 회피, 항상 명시적 타입 선언
- **로그:** `print` 대신 `debugPrint` 사용
- **따옴표:** single quote 선호 (`'string'`)
- **trailing comma:** 함수 파라미터, 리스트 마지막 요소에 trailing comma 필수 (Git diff 가독성)
- **const:** 가능한 경우 항상 `const` 사용
- **import 순서:** dart → package → relative

## BLoC 패턴 컨벤션

### 파일 구조
```
feature/
└── application/
    ├── my_feature_bloc.dart   # BLoC 클래스 (part 선언 포함)
    ├── my_feature_event.dart  # part of 'my_feature_bloc.dart'
    └── my_feature_state.dart  # part of 'my_feature_bloc.dart'
```

### 이벤트 네이밍
- 동사 + 명사: `SetReceiverName`, `SubmitPackage`, `DrawGacha`
- 초기화: `Init{Feature}` (`InitGacha`, `InitQuiz`)
- 리셋: `Reset{Feature}` (`ResetGacha`, `ResetQuiz`)

### 상태 네이밍
- 클래스: `{Feature}State` (`GiftPackagingState`, `GachaState`)
- 상태 필드는 불변, `copyWith`로만 변경
- 비동기 상태 enum: `{Action}Status { idle, loading, success, failure }`

### BLoC 핸들러 네이밍
```dart
on<SetReceiverName>(_onSetReceiverName);
// 핸들러: _on + 이벤트명 (camelCase)
```

## Freezed 모델 컨벤션

모든 서버 통신 데이터 모델에 Freezed + JsonSerializable 사용:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String name,
    @JsonKey(name: 'image_url') required String imageUrl,  // snake_case 매핑
    @Default(0) int count,  // 기본값
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

**규칙:**
- JSON 필드가 snake_case일 경우 `@JsonKey(name: 'field_name')` 사용
- `part` 선언은 파일 상단에 위치
- 코드 생성 후 `.freezed.dart`, `.g.dart` 파일은 git에 포함 (빌드 없이 실행 가능)

## Retrofit API 클라이언트 컨벤션

```dart
@RestApi()
abstract class MyApi {
  factory MyApi(Dio dio, {String baseUrl}) = _MyApi;

  @GET('/api/resource/{id}')
  Future<HttpResponse<dynamic>> getResource(@Path('id') String id);

  @POST('/api/resource')
  Future<HttpResponse<dynamic>> createResource(@Body() Map<String, dynamic> body);
}
```

**규칙:**
- `@RestApi()` 어노테이션으로 코드 생성
- 반환 타입: `HttpResponse<dynamic>` (상태 코드 접근용)
- 파일 위치: `lib/features/{feature}/repository/`
- 생성 파일: `*.g.dart`

## GetIt 의존성 주입 컨벤션

```dart
// 등록 (service_locator.dart에서)
getIt.registerLazySingleton<MyApi>(() => MyApi(dio));

// 사용 (BLoC에서)
final api = getIt<MyApi>();
```

- API 클라이언트는 `lazySingleton`으로 등록
- BLoC 생성자에 직접 주입하지 않고, 사용 시점에 `getIt<>()` 호출

## 네이밍 규칙

| 대상 | 규칙 | 예시 |
|------|------|------|
| 클래스 | PascalCase | `GiftPackagingBloc` |
| 파일 | snake_case | `gift_packaging_bloc.dart` |
| 변수/함수 | camelCase | `receiverName`, `_onSetReceiverName` |
| 상수 | camelCase | `appColors` |
| BLoC 이벤트 | PascalCase 동사형 | `SetReceiverName` |
| 라우트 경로 | kebab-case | `/addgift/memory-gallery` |

## 주석 언어

한국어 주석 사용 (팀 표준):
```dart
// 포장 완료 후 addgift 루트 접근 차단
// 위젯이 완전히 렌더링된 이후에 이동 (build 중 context 사용 방지)
```

## 화면(View) 컨벤션

- 뷰 파일: `{name}_view.dart`
- 모달 컨텐츠: `{name}_modal_content.dart` 또는 `{name}_modal.dart`
- 위치: `lib/features/{feature}/presentation/views/`
- 기본적으로 `StatelessWidget`, 애니메이션 필요 시 `StatefulWidget`
- **오버레이 가이드**: 전체 화면 로딩 오버레이는 반드시 `Material` 위젯을 사용하여 텍스트 하단 노란 줄 이슈를 방지한다.
- **버튼 스타일**: 리스트 내 추가 버튼 등은 `_DashedRectPainter`를 사용하여 점선 외곽선 스타일을 적용하고 `AppColors.neonBlue`를 사용한다.

## 기타 리소스 컨벤션

### 사운드 및 BGM
- **BGM 미리듣기**: 설정 화면의 BGM 미리보기는 사용자가 화면을 벗어날 때(`dispose`) 반드시 `StopBgmPreview` 이벤트를 호출하여 중단해야 한다.

## 에러 처리 컨벤션

BLoC에서:
```dart
try {
  // API 호출
  emit(state.copyWith(submitStatus: SubmitStatus.success));
} catch (e, stackTrace) {
  debugPrint('[BlocName] 에러 발생: $e');
  debugPrint('스택 트레이스: \n$stackTrace');
  emit(state.copyWith(submitStatus: SubmitStatus.failure));
}
```

View에서 `BlocListener`로 failure 감지 → 토스트 표시.
