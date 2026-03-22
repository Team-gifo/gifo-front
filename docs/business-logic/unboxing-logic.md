# 언박싱 비즈니스 로직

> 이 문서의 목적: 바로 오픈(언박싱) 컨텐츠의 초기화, 선물 수령, 결과 화면 이동 로직을 이해한다.

## 관련 파일

- `lib/features/content/application/unboxing/unboxing_bloc.dart`
- `lib/features/content/application/unboxing/unboxing_state.dart`

## 초기화 로직 (InitUnboxing)

```dart
void _onInitUnboxing(InitUnboxing event, Emitter<UnboxingState> emit) {
  final lobbyData = LobbyData.getDummyByCode(event.code);
  if (lobbyData == null || lobbyData.content?.unboxing == null) return;

  final unboxing = lobbyData.content!.unboxing!;
  emit(state.copyWith(
    userName: lobbyData.user,
    subTitle: lobbyData.subTitle,       // 부제목 (ex: "두근두근")
    unboxingContent: unboxing,
    isReceived: false,                  // 아직 선물 안 받음
  ));
}
```

**입력:** 초대 코드
**처리:** `LobbyData.getDummyByCode(code)` → unboxing 컨텐츠 추출
**출력:** userName, subTitle, unboxingContent, isReceived: false

## 선물 수령 로직 (ReceiveGift)

```dart
void _onReceiveGift(ReceiveGift event, Emitter<UnboxingState> emit) {
  emit(state.copyWith(isReceived: true));
}
```

단순 상태 플래그 변경. `isReceived: false → true`로 변경 시 UI에서:
1. 박스 열리는 애니메이션 재생
2. 애니메이션 완료 후 `/content/result`로 이동

## 상태 전이

```
초기 (isReceived: false)
  ↓ UI: 닫힌 선물 박스 표시
  ↓ 사용자: 박스 탭 또는 버튼 클릭
  ↓ UnboxingBloc.add(ReceiveGift())
박스 열기 (isReceived: true)
  ↓ BlocListener: isReceived 변화 감지
  ↓ 애니메이션 재생 (AnimatedContainer, Lottie 등)
  ↓ context.go('/content/result', extra: {...})
```

## UnboxingState 구조

```dart
class UnboxingState {
  final String? userName;                   // 받는 분 성함
  final String? subTitle;                   // 부제목
  final UnboxingContent? unboxingContent;  // 선물 아이템 정보
  final bool isReceived;                    // 수령 여부 (false=아직, true=열림)
}
```

## 확장: 열기 전 힌트/티저 추가

`isReceived` 플래그 외 힌트 공개 단계를 추가하려면:
1. `UnboxingState`에 `hintRevealed: bool` 필드 추가
2. `RevealHint` 이벤트 추가
3. View에서 hint → open 두 단계 처리
