# 아키텍처 개요

> 이 문서의 목적: Gifo 앱의 전체 구조, 레이어 책임, 데이터 흐름 방향을 이해한다.

## 앱 목적

Gifo는 **선물 포장 플랫폼**이다.
- **발신자(Gift Sender):** 8단계 선물 포장 → 서버 전송 → 공유 URL(초대 코드) 발급
- **수신자(Gift Receiver):** 초대 코드로 입장 → 가챠/퀴즈/언박싱 중 하나로 선물 개봉

## 아키텍처 패턴: Clean Architecture + BLoC

```
┌─────────────────────────────────────────────────┐
│  Presentation Layer (View)                       │
│  lib/features/*/presentation/views/*.dart        │
│  - StatelessWidget / StatefulWidget              │
│  - BlocBuilder / BlocListener로 상태 구독        │
├─────────────────────────────────────────────────┤
│  Application Layer (BLoC)                        │
│  lib/features/*/application/*_bloc.dart          │
│  - 이벤트 수신 → 비즈니스 로직 → 상태 emit      │
│  - UI와 완전히 분리된 순수 Dart 코드             │
├─────────────────────────────────────────────────┤
│  Repository Layer                                │
│  lib/features/*/repository/*_api.dart            │
│  - Retrofit 기반 HTTP 클라이언트                 │
│  - BLoC에서 직접 호출 (별도 레포지토리 클래스   │
│    없이 API 클라이언트가 레포지토리 역할)        │
├─────────────────────────────────────────────────┤
│  Model Layer                                     │
│  lib/features/*/model/*.dart                     │
│  - Freezed + JsonSerializable 불변 데이터 클래스│
│  - toJson() / fromJson() 지원                    │
└─────────────────────────────────────────────────┘
```

## 앱 진입점

**파일:** `lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();        // 웹: 해시(#) 없는 URL
  await dotenv.load(fileName: '.env');  // 환경변수 로드
  setupServiceLocator();       // GetIt DI 초기화
  runApp(const MyApp());
}
```

앱 시작 시 3가지 초기화 수행:
1. `.env` 파일 로드 (API base URL 등)
2. `setupServiceLocator()` - GetIt에 Dio, AddGiftApi 등록
3. `MaterialApp.router` with `appRouter` (GoRouter)

## 피처 구조

4개의 주요 피처 모듈이 `lib/features/` 아래에 위치:

| 피처 | 경로 | 대상 사용자 |
|------|------|-------------|
| `home` | `lib/features/home/` | 공통 - 랜딩 페이지 |
| `addgift` | `lib/features/addgift/` | 발신자 - 선물 포장 |
| `lobby` | `lib/features/lobby/` | 수신자 - 입장/초대코드 |
| `content` | `lib/features/content/` | 수신자 - 컨텐츠 소비 |

## 핵심 인프라

| 모듈 | 파일 | 역할 |
|------|------|------|
| DI | `lib/core/di/service_locator.dart` | GetIt으로 Dio + API 클라이언트 관리 |
| 라우터 | `lib/core/router/app_router.dart` | GoRouter 전체 라우트 정의 |
| 색상 | `lib/core/constants/app_colors.dart` | 앱 색상 팔레트 (네온 테마) |
| 반응형 | `lib/core/constants/app_breakpoints.dart` | 모바일/태블릿/데스크탑 브레이크포인트 |
| 공통 위젯 | `lib/core/widgets/` | 컨페티, 그리드 배경 페인터 |

## 전체 데이터 흐름

```
발신자 플로우:
UI 이벤트 → BLoC.add(Event) → _onEvent() → emit(newState)
                                           → API 호출 (SubmitPackage)
                                             ↓
                                      서버 POST /api/events

수신자 플로우:
URL /gift/code/:code → redirect() 검증 → LobbyView
                                          → 컨텐츠 선택 → /content/gacha|quiz|unboxing
                                            ↓
                                      BLoC.InitGacha(code) → LobbyData 조회
                                            ↓
                                      추첨/퀴즈/언박싱 → /content/result
```
