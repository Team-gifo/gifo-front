# 개발 환경 설정

> 이 문서의 목적: 프로젝트를 로컬에서 실행하기 위한 환경 설정 방법을 안내한다.

## 요구사항

- Flutter SDK: Dart ^3.11.0 이상
- Flutter 버전: `pubspec.yaml`의 `sdk: ">=3.11.0 <4.0.0"` 참고

## 1. 의존성 설치

```bash
flutter pub get
```

## 2. .env 파일 설정

프로젝트 루트에 `.env` 파일 생성:

```
url=https://your-api-server.com
```

`.env`는 `.gitignore`에 포함되어 있으므로 각 개발자가 직접 생성해야 한다.
`pubspec.yaml`에 assets로 등록되어 있어 `dotenv.load()`로 읽힌다.

## 3. 코드 생성 (build_runner)

Freezed, json_serializable, Retrofit 코드 생성이 필요하다.

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 코드 생성이 필요한 파일

**Freezed (불변 모델 클래스):**
- `lib/features/addgift/model/gacha_content.dart` → `gacha_content.freezed.dart`, `gacha_content.g.dart`
- `lib/features/addgift/model/quiz_content.dart` → `quiz_content.freezed.dart`, `quiz_content.g.dart`
- `lib/features/addgift/model/unboxing_content.dart` → `unboxing_content.freezed.dart`, `unboxing_content.g.dart`
- `lib/features/addgift/model/gift_content.dart` → `gift_content.freezed.dart`, `gift_content.g.dart`
- `lib/features/addgift/model/gift_request.dart` → `gift_request.freezed.dart`, `gift_request.g.dart`
- `lib/features/addgift/model/gallery_item.dart` → `gallery_item.freezed.dart`, `gallery_item.g.dart`

**Retrofit (API 클라이언트):**
- `lib/features/addgift/repository/addgift_api.dart` → `addgift_api.g.dart`
- `lib/features/content/repository/content_api.dart` → `content_api.g.dart`

## 4. 앱 실행

```bash
# 웹 (개발 중 주로 사용)
flutter run -d chrome

# 모바일
flutter run -d android
flutter run -d ios

# 특정 환경 (release)
flutter run --release
```

## 5. 앱 빌드

```bash
# 웹
flutter build web

# Android APK
flutter build apk

# iOS
flutter build ios
```

## CI/CD

`.github/workflows/` 폴더에 GitHub Actions 설정이 있다.
자세한 파이프라인 내용은 해당 파일 참고.

## 분석 및 린팅

```bash
flutter analyze
```

`analysis_options.yaml`에 엄격한 린트 규칙 설정:
- 항상 타입 명시 (타입 추론 회피)
- `print` 대신 `debugPrint` 사용
- trailing comma 필수
- single quote 선호
자세한 내용: [development/conventions.md](../development/conventions.md)
