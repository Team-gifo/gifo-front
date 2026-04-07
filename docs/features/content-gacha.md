# 가챠 컨텐츠 (캡슐 뽑기)

> 이 문서의 목적: 수신자가 캡슐 뽑기를 경험하는 화면 구성, 상태, BLoC 이벤트를 이해한다.

## 라우트

`/content/gacha` → `GachaView` (with `GachaBloc`)

## 파일 목록

| 파일 | 역할 |
|------|------|
| `lib/features/content/presentation/gacha/gacha_view.dart` | 가챠 게임 UI (반응형 레이아웃 포함) |
| `lib/features/content/application/gacha/gacha_bloc.dart` | 가챠 게임 로직 및 상태 관리 |
| `lib/features/content/application/gacha/gacha_event.dart` | 이벤트 정의 (Init, Draw, Reset 등) |
| `lib/features/content/application/gacha/gacha_state.dart` | 상태 정의 (아이템 목록, 히스토리, 갱신 플래그 등) |
| `lib/features/content/presentation/gacha/gacha_widgets.dart` | 머신, 뱃지, 경품 목록 등 하위 위젯 |

## GachaBloc 이벤트

| 이벤트 | 설명 |
|--------|------|
| `InitGacha(lobbyData, inviteCode)` | 초기 데이터 주입 또는 갱신, 초기 상태 설정 |
| `DrawGacha()` | 캡슐 1개 뽑기 (서버 요청 병행) |
| `ResetGacha()` | 상태 초기화 |

## GachaState 구조

```dart
class GachaState {
  final String? userName;              // 받는 분 성함
  final GachaContent? gachaContent;   // 뽑기 아이템 목록 (모델)
  final int remainingCount;            // 남은 뽑기 횟수 (API 필드: remainingDrawCount)
  final List<Map<String, dynamic>> history; // 뽑기 기록 [{time, item}]
  final GachaItem? lastDrawnItem;     // 가장 최근 뽑은 아이템 (결과 화면 이동 트리거)
  final bool isResultRefreshing;      // 뽑기 후 백그라운드 데이터 동기화 여부
}
```

## 화면 진입 → 게임 흐름 (데이터 최적화)

1.  **초기 진입**: `LobbyView`에서 시작 버튼 클릭 시 `lobbyData`와 `code`를 `extra`로 전달.
2.  **데이터 주입**: `app_router.dart`에서 `LobbyBloc`에 `InitLobbyWithData`를 실행하여 즉시 초기화. `GachaView`의 `initState`에서 `InitGacha`를 통해 UI 데이터 설정. (불필요한 첫 API 호출 제거)
3.  **뽑기 실행**: `DrawGacha` 이벤트 발생 시 서버 API 호출. 결과 수신 후 `isResultRefreshing: true` 설정.
4.  **백그라운드 갱신**: 애니메이션 도중 또는 완료 후 `LobbyBloc`에서 `SilentRefreshLobbyData`를 수행하여 최신 데이터(남은 횟수 등)를 백그라운드에서 가져옴.
5.  **상태 동기화**: 신규 데이터 도착 시 `GachaBloc`을 다시 초기화하고 `isResultRefreshing: false`로 전환하여 UI 잠금 해제.

## 디자인 & UX 사양

### 반응형 레이아웃 (Responsive Layout)
- **데스크톱 (1024px ~)**: 3단 레이아웃 (좌: 히스토리 | 중: 머신 | 우: 경품목록).
- **태블릿 (768px ~ 1024px)**: 히스토리와 경품목록을 앱바/바텀시트로 숨기고, 가챠 머신을 **중앙 정렬(Centered)**하여 표시.
- **모바일 (~ 768px)**: 단일 컬럼 레이아웃. 전체 페이지가 `SingleChildScrollView`로 구성되어 작은 화면에서도 스크롤 가능.

### 가챠 머신 디자인
- **유리 돔 (Glass Dome)**: 상단이 둥근 캡슐 보관통 형태이며, 유리 반사광 하이라이트와 내부 조명 효과 적용.
- **메탈릭 림 (Metallic Rim)**: 보관통과 본체 사이에 선명한 그라데이션 금속 띠 배치.
- **네온 글로우**: 보관통 테두리와 본체 곳곳에 보라색 네온 조명 효과 부여.

### UI 컴포넌트 & UX 개선
- **남은 횟수 뱃지 (GachaRemainingBadge)**:
  - **모바일**: 가챠 머신 바로 상단에 배치.
  - **태블릿/데스크톱**: 상단 AppBar의 우측 액션 영역으로 이동하여 공간 효율성 증대.
  - 디자인: 네온 퍼플 테마, `Icons.generating_tokens_rounded` 아이콘 적용.
- **경품 목록 빈 상태 (Empty State)**:
  - 경품이 모두 소진되었거나 목록이 없을 경우, "경품이 없습니다." 메시지와 함께 `Icons.inbox_outlined` 아이콘을 중앙에 배치.
- **폭죽 효과**: 당첨 시 모달 박스 내부가 아닌 **전체 화면**에서 색종이가 터지도록 레이어 분리.
- **애니메이션 타이밍**: 캡슐 오픈 후 결과 모달이 뜨기까지의 부드럽고 빠른 전환.

### 기프티콘 프레임 (GifticonFrame)
- **용도**: 당첨된 경품을 이미지로 저장(캡쳐)하기 위한 고정 규격(400x750) 위젯.
- **디자인 사양**:
  - **그리드 배경**: `GridBackgroundPainter` 적용.
  - **QR 코드**: 이름 우측 상단 배치 (60x60).
  - **브랜드 로고**: 하단 중앙 경계선 배치 (높이 50px).
  - **정보 표기**: 받는이, 당첨일시, 유효코드 상세 표기.

자세한 로직: [business-logic/gacha-logic.md](../business-logic/gacha-logic.md)
