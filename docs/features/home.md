# 홈 기능 (Home)

> 이 문서의 목적: 앱 랜딩 화면 구성, 진입점 모달, 초대 코드 입력 흐름을 이해한다.

## 라우트

`/` → `HomeView`

## 파일 목록

| 파일 | 역할 |
|------|------|
| `lib/features/home/presentation/views/home_view.dart` | 메인 랜딩 화면 |
| `lib/features/home/presentation/views/gift_mode_modal.dart` | 선물 포장하기 시작 모달 |
| `lib/features/home/presentation/views/invite_modal_content.dart` | 초대 코드 입력 모달 |

## HomeView

- 앱의 진입 화면. Gifo 브랜드 UI와 두 가지 CTA 버튼 제공
- `showInvalidCodeToast` 파라미터: 잘못된 초대 코드 진입 시 토스트 표시 (전역 플래그에서 전달)
- **SEO 최적화**: 
  - `SeoText`, `SeoImage` 커스텀 위젯을 사용하여 캔버스 렌더링 영역 뒤의 HTML DOM에 실제 텍스트와 이미지 태그를 주입.
  - 이를 통해 검색 엔진 크롤러가 사이트의 주요 제목과 설명, 이미지를 색인할 수 있도록 지원.
- **반응형 레이아웃**:
  - `_SectionLayout`을 통해 데스크톱/태블릿/모바일별 그리드/리스트 전환.
  - **데스크톱 특화 여백**: 텍스트가 화면 끝에 너무 붙지 않도록 가로 배치 시 외부 여백(`SizedBox(width: 60)`)을 추가하여 중앙 집중 효과 부여.

**두 가지 진입 경로:**

| 버튼 | 동작 |
|------|------|
| 선물 포장하기 | `GiftModeModal` 표시 → `/addgift` 이동 |
| 선물 받기 / 초대 코드 입력 | `InviteModalContent` 표시 → 코드 검증 → `/gift/code/:code` 이동 |

## GiftModeModal

선물 포장 시작 전 확인 모달. 사용자가 "시작" 선택 시 `/addgift`로 이동.

## InviteModalContent

초대 코드 입력 모달.
- 사용자가 코드 입력 후 확인 → `context.go('/gift/code/$code')` 이동
- 라우터의 `redirect`에서 코드 유효성 검증 후 로비 또는 홈(에러 토스트)으로 처리

## 배경 및 시각 요소

- `GridBackgroundPainter` (`lib/core/widgets/grid_background_painter.dart`): 격자 배경 패턴
- 메인 화면 애니메이션 이미지 (Lottie/assets 기반)
- 네온 색상 팔레트: `lib/core/constants/app_colors.dart`
