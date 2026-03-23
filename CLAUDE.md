# Gifo Frontend - Claude 컨텍스트 인덱스

## 프로젝트 개요

**Gifo**는 Flutter 기반 선물 포장 플랫폼이다. 발신자(선물 포장)와 수신자(선물 개봉)가 각각 다른 플로우를 경험한다.
- 발신자: 8단계 선물 포장 플로우 → 서버 전송 → 공유 URL 생성
- 수신자: 초대 코드로 입장 → 가챠/퀴즈/언박싱 중 하나의 컨텐츠 경험
- 기술 스택: Flutter BLoC + GoRouter + Dio/Retrofit + Freezed + GetIt

---

## 아키텍처

| 문서 | 내용 |
|------|------|
| [architecture/overview.md](docs/architecture/overview.md) | Clean Architecture 레이어 구조, 앱 진입점, 전체 플로우 |
| [architecture/folder-structure.md](docs/architecture/folder-structure.md) | `lib/` 폴더 트리와 각 폴더의 역할 |
| [architecture/state-management.md](docs/architecture/state-management.md) | BLoC 패턴, 이벤트/상태 흐름, 전체 BLoC 목록 |
| [architecture/routing.md](docs/architecture/routing.md) | GoRouter 라우트 구조, ShellRoute, 파라미터 전달 |
| [architecture/networking.md](docs/architecture/networking.md) | Dio + Retrofit 설정, GetIt 서비스 로케이터, .env |

---

## 환경 설정

| 문서 | 내용 |
|------|------|
| [environment/setup.md](docs/environment/setup.md) | 개발환경 설정, .env 파일, build_runner 실행 방법 |
| [environment/dependencies.md](docs/environment/dependencies.md) | pubspec.yaml 주요 의존성 목록 및 사용 목적 |
| [environment/seo.md](docs/environment/seo.md) | 검색 엔진 최적화(SEO), sitemap 및 robots.txt 설정 정보 |

---

## 기능별 문서

| 문서 | 내용 |
|------|------|
| [features/home.md](docs/features/home.md) | 메인 홈 화면, 선물 포장하기/초대 모달 |
| [features/addgift.md](docs/features/addgift.md) | 선물 포장 8단계 플로우, ShellRoute, BLoC 이벤트 |
| [features/lobby.md](docs/features/lobby.md) | 로비 화면, 초대 코드 검증, 컨텐츠 진입 |
| [features/content-gacha.md](docs/features/content-gacha.md) | 캡슐 뽑기 게임 화면 구성 및 상태 |
| [features/content-quiz.md](docs/features/content-quiz.md) | 퀴즈 게임 화면 구성 및 상태 |
| [features/content-unboxing.md](docs/features/content-unboxing.md) | 바로 오픈 화면 구성 및 상태 |

---

## 비즈니스 로직

상세한 입력→처리→출력 플로우가 필요할 때 참조.

| 문서 | 내용 |
|------|------|
| [business-logic/gift-packaging-flow.md](docs/business-logic/gift-packaging-flow.md) | 선물 포장 전체 데이터 플로우 다이어그램, GiftRequest 조립 구조 |
| [business-logic/gacha-logic.md](docs/business-logic/gacha-logic.md) | 가챠 추첨 로직, 히스토리 타임스탬프, 결과 화면 이동 |
| [business-logic/quiz-logic.md](docs/business-logic/quiz-logic.md) | 퀴즈 채점, 라이프 시스템, 성공/실패 조건 |
| [business-logic/unboxing-logic.md](docs/business-logic/unboxing-logic.md) | 언박싱 초기화, 선물 수령, 결과 이동 |
| [business-logic/lobby-validation.md](docs/business-logic/lobby-validation.md) | 초대 코드 검증 흐름 (BLoC → Repository → dummy/API) |
| [business-logic/memory-gallery-logic.md](docs/business-logic/memory-gallery-logic.md) | 메모리 갤러리 정렬/재정렬, 부모 BLoC 동기화 |

---

## 개발 현황

| 문서 | 내용 |
|------|------|
| [development/completed.md](docs/development/completed.md) | 완료된 기능 목록 |
| [development/todo.md](docs/development/todo.md) | 미완성/TODO 항목, 알려진 한계 |
| [development/conventions.md](docs/development/conventions.md) | 코딩 컨벤션, Freezed 패턴, BLoC 네이밍 규칙 |

---

## 핵심 파일 위치

자주 참조하는 파일 경로 빠른 참조:

```
lib/main.dart                                              # 앱 진입점
lib/core/router/app_router.dart                           # 전체 라우트 정의
lib/core/di/service_locator.dart                          # GetIt DI 설정

# 선물 포장 (발신자)
lib/features/addgift/application/gift_packaging_bloc.dart  # 핵심 BLoC
lib/features/addgift/model/gift_request.dart               # API 요청 모델
lib/features/addgift/repository/addgift_api.dart           # POST /api/events

# 컨텐츠 (수신자)
lib/features/content/application/gacha/gacha_bloc.dart
lib/features/content/application/quiz/quiz_bloc.dart
lib/features/content/application/unboxing/unboxing_bloc.dart

# 로비
lib/features/lobby/model/lobby_data.dart                   # 더미 데이터 + 코드 검증
lib/features/lobby/application/lobby_bloc.dart

# 상수/공통
lib/core/constants/app_colors.dart
lib/core/constants/app_breakpoints.dart
```
