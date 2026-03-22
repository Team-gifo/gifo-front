# 주요 의존성

> 이 문서의 목적: `pubspec.yaml`의 주요 패키지와 각각의 사용 목적을 이해한다.

**프로젝트 정보:**
- Name: `gifo`
- Version: `1.0.3+1`
- Dart SDK: `>=3.11.0 <4.0.0`

## 상태 관리

| 패키지 | 버전 | 용도 |
|--------|------|------|
| `flutter_bloc` | ^9.1.1 | BLoC 패턴 구현. `Bloc`, `BlocProvider`, `BlocBuilder`, `BlocListener` 제공 |
| `equatable` | (bloc 의존) | BLoC 상태 비교를 위한 값 동등성 |

## 라우팅

| 패키지 | 버전 | 용도 |
|--------|------|------|
| `go_router` | ^17.1.0 | 선언적 라우팅. `GoRoute`, `ShellRoute`, `GoRouter` |

## 직렬화 및 코드 생성

| 패키지 | 버전 | 용도 |
|--------|------|------|
| `freezed_annotation` | ^3.1.0 | Freezed 어노테이션 (`@freezed`, `@Default`) |
| `json_annotation` | ^4.11.0 | JSON 어노테이션 (`@JsonSerializable`, `@JsonKey`) |
| `retrofit` | ^4.9.2 | Retrofit HTTP 클라이언트 어노테이션 (`@RestApi`, `@POST`, `@Body`) |

**dev_dependencies:**

| 패키지 | 버전 | 용도 |
|--------|------|------|
| `freezed` | ^3.2.5 | Freezed 코드 생성기 |
| `json_serializable` | ^6.13.0 | JSON 직렬화 코드 생성 |
| `retrofit_generator` | ^10.2.3 | Retrofit 클라이언트 구현체 생성 |
| `build_runner` | ^2.12.1 | 코드 생성 실행 도구 |

## 네트워킹

| 패키지 | 버전 | 용도 |
|--------|------|------|
| `dio` | ^5.9.1 | HTTP 클라이언트. 인터셉터, 타임아웃, LogInterceptor |
| `flutter_dotenv` | ^6.0.0 | `.env` 파일에서 환경변수 로드 (API base URL 등) |

## 의존성 주입

| 패키지 | 버전 | 용도 |
|--------|------|------|
| `get_it` | ^9.2.1 | 서비스 로케이터 패턴. `GetIt.instance`로 전역 접근 |

## 저장소 및 보안

| 패키지 | 버전 | 용도 |
|--------|------|------|
| `flutter_secure_storage` | ^10.0.0 | 민감한 데이터 안전 저장 (현재 미활용, 추후 토큰 저장용) |

## UI 및 애니메이션

| 패키지 | 버전 | 용도 |
|--------|------|------|
| `confetti` | ^0.8.0 | 컨페티(폭죽) 애니메이션 |
| `flutter_svg` | ^2.2.3 | SVG 이미지 렌더링 |
| `toastification` | ^3.0.3 | 토스트 알림 메시지 |
| `animated_text_kit` | ^4.3.0 | 텍스트 타이핑/페이드 등 애니메이션 |
| `visibility_detector` | ^0.4.0+2 | 위젯 화면 표시 여부 감지 |
| `cupertino_icons` | ^1.0.8 | iOS 스타일 아이콘 |

## 미디어

| 패키지 | 버전 | 용도 |
|--------|------|------|
| `image_picker` | ^1.2.1 | 기기 갤러리/카메라에서 이미지 선택 (메모리 갤러리 설정에 사용) |

## 유틸리티

| 패키지 | 버전 | 용도 |
|--------|------|------|
| `logger` | ^2.6.2 | 구조화된 로그 출력 |
| `url_launcher` | ^6.3.2 | 외부 URL 열기 |
| `reorderable_grid_view` | ^2.2.8 | 드래그로 재정렬 가능한 그리드 뷰 |

## 커스텀 폰트

`pubspec.yaml`에 등록된 폰트:

| 폰트 패밀리 | 파일 위치 | 웨이트 |
|------------|----------|--------|
| `PFStardust` | `assets/fonts/PFStardust*.ttf` | Regular, Bold(700), ExtraBold(800) |
| `PFStardustS` | `assets/fonts/PFStardustS*.ttf` | Regular, Bold(700), ExtraBold(800) |
| `WantedSans` | `assets/fonts/WantedSans*.otf` | Regular, Medium(500), SemiBold(600), Bold(700), ExtraBold(800), Black(900) |

기본 폰트: `PFStardust` (ThemeData에 `fontFamily: 'PFStardust'` 설정)
