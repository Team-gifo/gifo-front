# 언박싱 컨텐츠 (바로 오픈)

> 이 문서의 목적: 수신자가 선물을 바로 개봉하는 화면 구성, 상태, BLoC 이벤트를 이해한다.

## 라우트

`/content/unboxing` → `UnboxingView` (with `UnboxingBloc`, `LobbyBloc`)

## 파일 목록

| 파일 | 역할 |
|------|------|
| `lib/features/content/presentation/unboxing/unboxing_view.dart` | 언박싱 게임 UI |
| `lib/features/content/application/unboxing/unboxing_bloc.dart` | 언박싱 로직 및 컨텐츠 API 연동 |
| `lib/features/content/application/unboxing/unboxing_event.dart` | 이벤트 정의 |
| `lib/features/content/application/unboxing/unboxing_state.dart` | 상태 정의 |
| `lib/features/content/repository/content_repository.dart` | 선물 개봉 API 요청 처리 |

## UnboxingBloc 이벤트

| 이벤트 | 설명 |
|--------|------|
| `InitUnboxing(lobbyData, inviteCode)` | 전달받은 로비 데이터를 기반으로 초기 정보 설정 |
| `ReceiveGift()` | 선물 개봉 API 요청 처리 및 수령 완료 상태 변경 |
| `ResetUnboxing()` | 상태 초기화 |

## UnboxingState 구조

```dart
class UnboxingState {
  final String userName;
  final String subTitle;
  final String inviteCode;
  final UnboxingContent? unboxingContent;  // 선물 아이콘/내용 정보
  final bool isOpening;                    // API 요청 중 로딩 상태
  final bool isReceived;                   // 선물 수령 완료 여부 (박스 열기 완료)
}
```

## 화면 진입 → 개봉 흐름

```
LobbyView "선물 열기" 버튼 클릭
    ↓ context.go('/content/unboxing', extra: { 'data': lobbyData, 'code': inviteCode })
app_router.dart: UnboxingBloc 생성 및 InitUnboxing(lobbyData, inviteCode) 발행
    ↓ MultiBlocProvider를 통해 LobbyBloc과 UnboxingBloc을 함께 주입
UnboxingView 빌드
    ↓ InitUnboxing 이벤트 처리 후 state 구성 (unboxingContent 등 로드)
UI: Skeletonizer 및 Image.network를 이용해 배경(선물 이미지) 및 애니메이션 표시
    ↓ 사용자 "🎁 선물 개봉하기" 버튼 클릭
UnboxingBloc.add(ReceiveGift())
    ↓ emit state.copyWith(isOpening: true)
    ↓ ContentRepository.openGift(inviteCode) API 호출 (또는 시뮬레이션)
    ↓ emit state.copyWith(isOpening: false, isReceived: true)
UI: isReceived == true 상태 감지 → ResultView 위젯 렌더링
```

## 가로채기 및 동기화 (LobbyBloc 연동)

언박싱 화면 로딩 중 또는 진행 중에 로비 데이터가 서버로부터 갱신될 경우(예: 웹소켓 등), `UnboxingView`는 `LobbyBloc`의 상태 변화를 감지하여 `InitUnboxing`을 다시 발행함으로써 최신 데이터를 유지한다. (가챠, 퀴즈와 동일한 동기화 패턴 적용)

## 결과 화면 표시

`isReceived: true` 상태가 되면 `UnboxingView` 내부의 `BlocConsumer`가 이를 감지하고, 기존 언박싱 UI 대신 `ResultView` 위젯을 렌더링하여 최종 보상 아이템 정보와 감사 카드 정보를 표시한다.

자세한 로직: [business-logic/unboxing-logic.md](../business-logic/unboxing-logic.md)
