# 언박싱 컨텐츠 (바로 오픈)

> 이 문서의 목적: 수신자가 선물을 바로 개봉하는 화면 구성, 상태, BLoC 이벤트를 이해한다.

## 라우트

`/content/unboxing` → `UnboxingView` (with `UnboxingBloc`)

## 파일 목록

| 파일 | 역할 |
|------|------|
| `lib/features/content/presentation/unboxing/unboxing_view.dart` | 언박싱 게임 UI |
| `lib/features/content/application/unboxing/unboxing_bloc.dart` | 언박싱 로직 |
| `lib/features/content/application/unboxing/unboxing_event.dart` | 이벤트 정의 |
| `lib/features/content/application/unboxing/unboxing_state.dart` | 상태 정의 |

## UnboxingBloc 이벤트

| 이벤트 | 설명 |
|--------|------|
| `InitUnboxing(code)` | 코드로 더미 데이터 조회, 초기화 |
| `ReceiveGift()` | 선물 받기 처리 (박스 열기) |
| `ResetUnboxing()` | 상태 초기화 |

## UnboxingState 구조

```dart
class UnboxingState {
  final String? userName;
  final String? subTitle;
  final UnboxingContent? unboxingContent;  // 선물 아이템 정보
  final bool isReceived;                   // 선물 수령 여부 (박스 열기 트리거)
}
```

## 화면 진입 → 개봉 흐름

```
LobbyView "시작" 버튼
    ↓ context.go('/content/unboxing', extra: code)
UnboxingView 빌드
    ↓ initState()에서 UnboxingBloc.add(InitUnboxing(code))
BLoC: LobbyData.getDummyByCode(code) 조회
    ↓ emit state with userName, subTitle, unboxingContent, isReceived: false
UI: 선물 박스 애니메이션 표시 (닫힌 상태)
    ↓ 사용자 선물 박스 탭/버튼 클릭
UnboxingBloc.add(ReceiveGift())
    ↓ emit state.copyWith(isReceived: true)
UI: isReceived == true 상태 감지 → 열리는 애니메이션 후 `ResultView` 인라인 렌더링
```

## 결과 화면 표시

`isReceived: true` 및 애니메이션 완료 상태가 되면 `UnboxingView` 내부에서 기존 박스를 지우고 `ResultView` 위젯을 생성하여 표시한다. 이 때 보상 아이템 정보와 초대코드가 전달된다.

자세한 로직: [business-logic/unboxing-logic.md](../business-logic/unboxing-logic.md)
