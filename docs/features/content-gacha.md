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
UI(BlocListener): lastDrawnItem != null → 결과 화면 이동
    ↓ context.go('/content/result', extra: { itemName, imageUrl, userName })
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

## 결과 화면 이동

마지막 `lastDrawnItem`을 extra로 ResultView에 전달:
```dart
context.go('/content/result', extra: {
  'itemName': state.lastDrawnItem!.itemName,
  'imageUrl': state.lastDrawnItem!.imageUrl,
  'userName': state.userName ?? '',
});
```

자세한 로직: [business-logic/gacha-logic.md](../business-logic/gacha-logic.md)
