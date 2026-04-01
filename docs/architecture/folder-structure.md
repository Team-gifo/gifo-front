# 폴더 구조

> 이 문서의 목적: `lib/` 폴더 트리와 각 폴더/파일의 역할을 빠르게 파악한다.

## 최상위 구조

```
gifo-front/
├── lib/                    # Dart 소스 코드 (메인)
├── assets/                 # 정적 자원 (이미지, 폰트, Lottie)
├── android/ ios/ web/      # 플랫폼별 네이티브 코드
├── pubspec.yaml            # 의존성 정의
├── .env                    # 환경 변수 (API URL 등, git 제외)
├── CLAUDE.md               # Claude 컨텍스트 인덱스
└── docs/                   # 프로젝트 문서
```

## lib/ 상세 구조

```
lib/
├── main.dart                          # 앱 진입점
├── test_reorder.dart                  # 드래그 재정렬 테스트 (임시)
│
├── core/                              # 공통 인프라
│   ├── config/                        # (placeholder, 미구현)
│   ├── constants/
│   │   ├── app_colors.dart            # 앱 색상 상수 (네온 테마)
│   │   └── app_breakpoints.dart       # 반응형 브레이크포인트
│   ├── di/
│   │   └── service_locator.dart       # GetIt DI 설정
│   ├── error/                         # (placeholder, 미구현)
│   ├── network/                       # (placeholder, 미구현)
│   ├── router/
│   │   └── app_router.dart            # GoRouter 전체 라우트
│   ├── blocs/
│   │   └── download/                  # 공용 파일 다운로드 BLoC (피처 공유)
│   │       ├── download_bloc.dart
│   │       ├── download_event.dart
│   │       └── download_state.dart
│   ├── utils/
│   │   ├── file_download_helper.dart  # 웹 기반 파일 다운로드 유틸리티
│   │   └── share_helper.dart          # 공용 클립보드 공유 유틸 (ResultView, GachaHistoryPanel 공유)
│   └── widgets/
│       ├── center_burst_confetti_widget.dart
│       ├── grid_background_painter.dart
│       └── shared_confetti_widget.dart
│
└── features/                          # 피처별 모듈
    ├── home/
    │   └── presentation/views/
    │       ├── home_view.dart          # 랜딩 페이지
    │       ├── gift_mode_modal.dart    # 선물 포장 시작 모달
    │       └── invite_modal_content.dart # 초대 코드 입력 모달
    │
    ├── addgift/                        # 선물 포장 (발신자)
    │   ├── application/
    │   │   ├── gift_packaging_bloc.dart    # 메인 BLoC
    │   │   ├── gift_packaging_event.dart
    │   │   ├── gift_packaging_state.dart
    │   │   ├── gacha_setting/
    │   │   │   ├── gacha_setting_bloc.dart
    │   │   │   ├── gacha_setting_event.dart
    │   │   │   └── gacha_setting_state.dart
    │   │   └── memory_gallery_setting/
    │   │       ├── memory_gallery_setting_bloc.dart
    │   │       ├── memory_gallery_setting_event.dart
    │   │       └── memory_gallery_setting_state.dart
    │   ├── model/
    │   │   ├── gift_request.dart           # 서버 전송 최상위 모델
    │   │   ├── gift_content.dart           # 컨텐츠 타입 유니온
    │   │   ├── gacha_content.dart          # 가챠 컨텐츠 모델
    │   │   ├── quiz_content.dart           # 퀴즈 컨텐츠 모델
    │   │   ├── unboxing_content.dart       # 언박싱 컨텐츠 모델
    │   │   ├── gallery_item.dart           # 메모리 갤러리 아이템
    │   │   ├── direct_open_setting_models.dart
    │   │   └── quiz_setting_models.dart
    │   ├── presentation/views/
    │   │   ├── receiver_name_view.dart     # Step 1: 받는 분 성함
    │   │   ├── memory_decision_view.dart   # Step 2: 추억 공유 여부
    │   │   ├── memory_gallery_setting_view.dart # Step 3: 갤러리 설정
    │   │   ├── gift_delivery_method_view.dart   # Step 4: 전달 방식 선택
    │   │   ├── gacha_setting_view.dart     # Step 5a: 가챠 설정
    │   │   ├── quiz_setting_view.dart      # Step 5b: 퀴즈 설정
    │   │   ├── direct_open_setting_view.dart    # Step 5c: 바로 오픈 설정
    │   │   └── package_complete_view.dart  # Step 6: 포장 완료
    │   └── repository/
    │       ├── addgift_api.dart            # Retrofit - POST /api/events
    │       └── addgift_api.g.dart          # 코드 생성 (수정 금지)
    │
    ├── lobby/                          # 로비 (수신자 입장)
    │   ├── application/
    │   │   ├── lobby_bloc.dart
    │   │   ├── lobby_event.dart
    │   │   ├── lobby_state.dart
    │   │   └── memory_gallery_action/      # 추억 갤러리 다운로드 처리
    │   │       ├── memory_gallery_action_bloc.dart
    │   │       ├── memory_gallery_action_event.dart
    │   │       └── memory_gallery_action_state.dart
    │   ├── model/
    │   │   └── lobby_data.dart         # 더미 데이터 + getDummyByCode()
    │   ├── presentation/views/
    │   │   ├── lobby_view.dart
    │   │   └── memory_gallery_view.dart
    │   └── repository/
    │       └── lobby_repository.dart   # 추후 API 연동 레이어
    │
    └── content/                        # 컨텐츠 (수신자 게임플레이)
        ├── application/
        │   ├── content_bloc.dart
        │   ├── gacha/
        │   │   ├── gacha_bloc.dart
        │   │   ├── gacha_event.dart
        │   │   └── gacha_state.dart
        │   ├── quiz/
        │   │   ├── quiz_bloc.dart
        │   │   ├── quiz_event.dart
        │   │   └── quiz_state.dart
        │   └── unboxing/
        │       ├── unboxing_bloc.dart
        │       ├── unboxing_event.dart
        │       └── unboxing_state.dart
        ├── model/
        │   ├── content_wrapper.dart
        │   ├── content_data.dart
        │   ├── content_gallery_item.dart
        │   ├── gacha/gacha_content_model.dart
        │   ├── quiz/quiz_content_model.dart
        │   └── unboxing/unboxing_content_model.dart
        ├── presentation/
        │   ├── gacha/
        │   │   ├── gacha_view.dart         # 메인 뷰 (레이아웃 조합)
        │   │   ├── gacha_widgets.dart      # 서브 위젯 분리 (패널, 머신, 버튼)
        │   │   └── gacha_result_modal.dart # 뽑기 결과 인라인 모달
        │   ├── widgets/
        │   │   └── gifticon_frame.dart     # 캡쳐/공유용 기프티콘 프레임 위젯
        │   ├── quiz/quiz_view.dart
        │   ├── unboxing/unboxing_view.dart
        │   └── result/
        │       ├── result_view.dart        # 공용 결과 화면 (다크 테마, 그리드 배경)
        │       └── result_cubit.dart       # 스크린샷 캡쳐 + DownloadBloc 위임
        └── repository/
            └── content_api.dart        # GET /api/events/{code} (미연동)
```

## assets/ 구조

```
assets/
├── fonts/
│   ├── PFStardust*.ttf     # PFStardust 폰트 패밀리 (3 weight)
│   ├── PFStardustS*.ttf    # PFStardustS 폰트 패밀리 (3 weight)
│   └── WantedSans*.otf     # WantedSans 폰트 패밀리 (6 weight)
├── images/
│   ├── item/               # 상품/보상 이미지 (nitendo.jpg, cow.jpg 등)
│   ├── icons/              # 앱 아이콘
│   └── example/            # 예시 이미지
└── lottie/                 # Lottie 애니메이션 JSON
```

## 코드 생성 파일 (수정 금지)

Freezed 및 Retrofit으로 자동 생성되는 파일은 직접 수정하지 않는다:
- `*.freezed.dart` - Freezed 생성 (불변 클래스, copyWith, 등)
- `*.g.dart` - json_serializable / retrofit_generator 생성

재생성 방법:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
