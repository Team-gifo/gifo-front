# 가챠 컨텐츠 (캡슐 뽑기)

> 이 문서의 목적: 수신자가 캡슐 뽑기를 경험하는 화면 구성, 상태, BLoC 이벤트를 이해한다.

## 라우트

`/content/gacha` → `GachaView` (with `GachaBloc`)

## 파일 목록

| 파일 | 역할 |
|------|------|
| `lib/features/content/presentation/gacha/gacha_view.dart` | 가챠 게임 UI |
| `lib/features/content/application/gacha/gacha_bloc.dart` | 가챠 게임 로직 |
| `lib/features/content/application/gacha/gacha_event.dart` | 이벤트 정의 |
| `lib/features/content/application/gacha/gacha_state.dart` | 상태 정의 |

## GachaBloc 이벤트

| 이벤트 | 설명 |
|--------|------|
| `InitGacha(code)` | 코드로 더미 데이터 조회, 초기 상태 설정 |
| `DrawGacha()` | 캡슐 1개 뽑기 (랜덤 선택, 히스토리 추가) |
| `ResetGacha()` | 상태 초기화 |

## GachaState 구조

```dart
class GachaState {
  final String? userName;              // 받는 분 성함
  final GachaContent? gachaContent;   // 뽑기 아이템 목록 + play_count
  final int remainingCount;            // 남은 뽑기 횟수
  final List<Map<String, dynamic>> history; // 뽑기 기록 [{time, item}]
  final GachaItem? lastDrawnItem;     // 가장 최근 뽑은 아이템 (결과 화면 이동 트리거)
}
```

## 화면 진입 → 게임 흐름

```
LobbyView "시작" 버튼
    ↓ context.go('/content/gacha', extra: code)
GachaView 빌드
    ↓ initState()에서 GachaBloc.add(InitGacha(code))
BLoC: LobbyData.getDummyByCode(code) 조회
    ↓ emit state with gachaContent, remainingCount
UI: 아이템 목록과 뽑기 버튼 표시
    ↓ 사용자 뽑기 버튼 클릭
GachaBloc.add(DrawGacha())
    ↓ 랜덤 선택 + history 업데이트 + remainingCount - 1
    ↓ emit state with lastDrawnItem
UI(BlocListener): lastDrawnItem != null → 결과 모달(`showGachaResultModal`) 표시
    ↓ 사용자가 모달 "확인" 버튼 클릭
GachaBloc.add(ClearLastDrawnItem())
    ↓ lastDrawnItem 초기화 (재추첨 가능 상태)
```

## 뽑기 히스토리

뽑기 기록은 역순(최신 먼저) 리스트로 관리:
```dart
final newHistory = [
  {'time': timeStr, 'item': randomItem.itemName},
  ...state.history,  // 기존 기록을 뒤에 추가
];
```

타임스탬프 형식: `"3월 22일 오후 2시 30분"` (한국어, 12시간제)

## 디자인 & UX 사양

### 가챠 머신 디자인
- **유리 돔 (Glass Dome)**: 상단이 둥근 캡슐 보관통 형태이며, 유리 반사광 하이라이트와 내부 조명 효과 적용
- **메탈릭 림 (Metallic Rim)**: 보관통과 본체 사이에 선명한 그라데이션 금속 띠 배치
- **네온 글로우**: 보관통 테두리와 본체 곳곳에 보라색 네온 조명 효과 부여

### 캡슐 물리 및 애니메이션
- **내부 적재**: 18개의 캡슐이 헥스 그리드(Hex Grid) 좌표 계산을 통해 기계 내부에 가득 차 있도록 배치
- **캡슐 디자인**: 68px 크기로 축소되었으며, `ClipOval`을 이용해 외곽선 잘림 없는 완벽한 원형 유지
- **폭죽 효과**: 당첨 시 모달 박스 내부가 아닌 **전체 화면**에서 색종이가 터지도록 레이어 분리
- **애니메이션 타이밍**: 캡슐 오픈 후 결과 모달이 뜨기까지의 불필요한 딜레이(500ms) 제거로 빠른 반응성 확보

### UI 컴포넌트
- **경품 목록**: 각 아이템 좌측에 네온 포인트 바를 배치하고 번개 아이콘 테마 적용
- **히스토리**: 사용자가 뽑은 최신 순으로 리스트 정렬 시각화


자세한 로직: [business-logic/gacha-logic.md](../business-logic/gacha-logic.md)
