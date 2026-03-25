# 가챠 추첨 비즈니스 로직

> 이 문서의 목적: 수신자가 캡슐 뽑기를 할 때 실행되는 추첨 로직, 히스토리 관리, 결과 화면 이동을 상세히 이해한다.

## 관련 파일

- `lib/features/content/application/gacha/gacha_bloc.dart`
- `lib/features/content/application/gacha/gacha_event.dart`
- `lib/features/content/application/gacha/gacha_state.dart`
- `lib/features/content/presentation/gacha/gacha_view.dart`
- `lib/features/content/presentation/gacha/gacha_widgets.dart`
- `lib/features/content/presentation/gacha/gacha_result_modal.dart`
- `lib/features/lobby/model/lobby_data.dart`

## 초기화 로직 (InitGacha)

```dart
void _onInitGacha(InitGacha event, Emitter<GachaState> emit) {
  final lobbyData = LobbyData.getDummyByCode(event.code);
  if (lobbyData == null || lobbyData.content?.gacha == null) return;

  final gacha = lobbyData.content!.gacha!;
  emit(state.copyWith(
    userName: lobbyData.user,
    gachaContent: gacha,
    remainingCount: gacha.playCount,  // 설정된 총 뽑기 횟수
    history: const [],
    lastDrawnItem: null,
  ));
}
```

**입력:** 초대 코드 (String)
**처리:** `LobbyData.getDummyByCode(code)` → gacha 컨텐츠 추출
**출력:** userName, gachaContent, remainingCount 초기화

현재 서버 연동 없이 더미 데이터 사용. 서버 연동 시 `LobbyData.getDummyByCode()` 대신 API 호출로 교체.

## 추첨 로직 (DrawGacha)

```dart
void _onDrawGacha(DrawGacha event, Emitter<GachaState> emit) {
  if (state.remainingCount <= 0 || state.gachaContent == null) return;

  final items = state.gachaContent!.list;
  final randomItem = items[Random().nextInt(items.length)];  // 단순 균등 랜덤
  final timeStr = _formatTime(DateTime.now());

  final List<Map<String, dynamic>> newHistory = <Map<String, dynamic>>[
    <String, dynamic>{'time': timeStr, 'item': randomItem},
    ...state.history,  // 최신 항목이 앞에 오도록 역순 삽입
  ];

  emit(state.copyWith(
    remainingCount: state.remainingCount - 1,
    history: newHistory,
    lastDrawnItem: randomItem,
  ));
}
```

**현재 추첨 방식:** 균등 랜덤 (`Random().nextInt(items.length)`)
- 각 아이템의 `percent` 필드는 UI 표시용 메타데이터로만 사용 (실제 확률에 미적용)
- 추후 가중치 랜덤 구현 시 이 부분을 교체

**Guard 조건:**
- `remainingCount <= 0`: 뽑기 횟수 소진 시 무시
- `gachaContent == null`: 미초기화 상태 시 무시

## 히스토리 타임스탬프 포맷

```dart
String _formatTime(DateTime time) {
  final month = time.month;
  final day = time.day;
  final hour = time.hour;
  final minute = time.minute.toString().padLeft(2, '0');
  final ampm = hour < 12 ? '오전' : '오후';
  final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  return '$month월 $day일 $ampm $hour12시 $minute분';
}
```

출력 예시: `"3월 22일 오후 2시 30분"`, `"12월 1일 오전 12시 05분"`

**특이사항:** 자정(0시) → "12시"로 처리

## 결과 모달 표시 트리거 (ClearLastDrawnItem 포함)

`GachaView`에서 `BlocConsumer`로 `lastDrawnItem` 변화를 감지한 뒤,
`result_view`로 이동하는 대신 **인라인 모달**(`showGachaResultModal`)을 표시한다.

```dart
BlocConsumer<GachaBloc, GachaState>(
  // lastDrawnItem이 새 값으로 바뀔 때만 리스너 실행
  listenWhen: (prev, curr) =>
      curr.lastDrawnItem != null && prev.lastDrawnItem != curr.lastDrawnItem,
  listener: (context, state) {
    showGachaResultModal(context, state.lastDrawnItem!);
  },
)
```

모달 닫기 시 `ClearLastDrawnItem` 이벤트를 dispatch해 상태를 초기화한다:

```dart
// gacha_result_modal.dart 내부 onClose 콜백
onClose: () {
  Navigator.of(ctx).pop();
  context.read<GachaBloc>().add(const ClearLastDrawnItem());
},
```

```dart
// gacha_bloc.dart
void _onClearLastDrawnItem(
  ClearLastDrawnItem event,
  Emitter<GachaState> emit,
) {
  emit(state.copyWith(lastDrawnItem: null));
}
```

## GachaItem 모델 구조

`lib/features/addgift/model/gacha_content.dart`:
```dart
@freezed
class GachaItem with _$GachaItem {
  const factory GachaItem({
    @JsonKey(name: 'item_name') required String itemName,
    @JsonKey(name: 'image_url') required String imageUrl,
    required int percent,            // 확률 표시값 (현재 추첨에 미적용)
    @JsonKey(name: 'percent_open') required bool percentOpen, // 확률 공개 여부
  }) = _GachaItem;
}
```

## 가중치 랜덤 구현 시 확장 방법

현재 균등 랜덤을 가중치 랜덤으로 교체하려면 `_onDrawGacha`에서:

```dart
// 현재 (균등):
final randomItem = items[Random().nextInt(items.length)];

// 확장 (가중치):
final totalWeight = items.fold(0, (sum, item) => sum + item.percent);
int randomValue = Random().nextInt(totalWeight);
GachaItem selectedItem = items.last;
for (final item in items) {
  randomValue -= item.percent;
  if (randomValue < 0) { selectedItem = item; break; }
}
```
