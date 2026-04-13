# 가챠 추첨 비즈니스 로직

> 이 문서의 목적: 수신자가 캡슐 뽑기를 할 때 실행되는 추첨 로직, 히스토리 관리, 결과 화면 이동 및 데이터 동기화 흐름을 상세히 이해한다.

## 관련 파일

- `lib/features/content/application/gacha/gacha_bloc.dart`
- `lib/features/content/presentation/gacha/gacha_view.dart`
- `lib/features/content/presentation/gacha/gacha_widgets.dart`
- `lib/core/router/app_router.dart`
- `lib/features/lobby/application/lobby_bloc.dart`

## 데이터 초기화 및 최적화 (InitGacha)

현재 가챠 시스템은 로비에서 이미 가져온 데이터를 활용하여 **네트워크 지연 없는 즉각적인 렌더링**을 수행한다.

1.  **초기 주입**: `GoRouter`를 통해 전달된 `lobbyData`를 `LobbyBloc`과 `GachaBloc`에 즉시 주입한다.
2.  **이벤트 핸들러**:
    ```dart
    void _onInitGacha(InitGacha event, Emitter<GachaState> emit) {
      final gacha = event.data.content!.gacha!;
      emit(state.copyWith(
        userName: event.data.user,
        gachaContent: gacha,
        remainingCount: gacha.remainingDrawCount, // 서버에서 내려준 남은 횟수 사용
        inviteCode: event.inviteCode,
        isResultRefreshing: false, // 초기화 시 갱신 플래그 해제
      ));
    }
    ```

## 추첨 및 서버 동기화 로직 (DrawGacha)

뽑기 실행 버튼 클릭 시 다음 과정이 순차적으로 발생한다.

1.  **서버 요청**: `DrawGacha` 이벤트를 통해 API를 호출한다. 이때 `isResultRefreshing` 플래그를 `true`로 설정하여 UI를 보호한다.
2.  **결과 응답**: 서버에서 추첨된 아이템 정보를 반환하면 `lastDrawnItem`을 업데이트한다.
3.  **애니메이션 실행**: UI에서 `lastDrawnItem`의 변화를 감지하여 캡슐 애니메이션을 트리거한다.
4.  **백그라운드 갱신 (Silent Refresh)**: 
    - 애니메이션이 진행되는 동안 `LobbyBloc`은 `SilentRefreshLobbyData` 이벤트를 수행하여 서버의 최신 상태(남은 뽑기 횟수 등)를 백그라운드에서 다시 가져온다.
    - 데이터 갱신이 완료되면 `GachaBloc`은 새로운 `lobbyData`로 다시 `InitGacha` 되어 최신 상태를 유지하게 된다.

## 히스토리 관리

뽑기 기록은 서버의 응답을 기반으로 역순(최신 먼저) 리스트로 관리된다.
- **포맷**: `"MM월 dd일 오전/오후 hh시 mm분"`
- **배지**: 현재 세션 또는 누적 당첨 기록의 개수를 실시간으로 UI 배지에 반영한다.

## 결과 모달 및 상태 리셋

결과 확인 후 다음 뽑기를 위해 상태를 정리한다.
- **모달 닫기**: `ClearLastDrawnItem` 이벤트를 통해 `lastDrawnItem`을 `null`로 리셋한다.
- **플래그 해제**: 모든 데이터 동기화가 완료되면 `isResultRefreshing`을 `false`로 돌려 `CircularProgressIndicator`를 제거한다.

## UI/UX 성능 고려 사항

- **SingleChildScrollView**: 모바일 레이아웃에서 화면 크기에 상관없이 머신 전체가 접근 가능하도록 스크롤을 허용한다.
- **고정 높이 컨테이너**: 스크롤 뷰 내에서 애니메이션의 깨짐을 방지하기 위해 머신 섹션에 스케일 기반 고정 높이를 부여한다.
- **반응형 정렬**: 태블릿 이상의 화면에서는 `Center` 위젯을 사용하여 가챠 머신이 항상 시각적 중심에 오도록 조정한다.

## 가챠 확률 모델: 상대적 비율 계산 (No-Blank Policy)

Gifo의 가챠 시스템은 '꽝 없는 선물'을 목표로 하며, 아이템이 당첨되어 사라질 때마다 남은 아이템들끼리의 **상대적 비율**을 다시 계산하여 100%를 유지한다.

1.  **초기 상태**: 모든 아이템의 가중치 합(Total Weight)을 기준으로 확률 계산
    - 예: 아이템 A(15), B(500), C(485) → 합계 1000
    - 확률: A(1.5%), B(50.0%), C(48.5%)
2.  **아이템 당첨 후**: 당첨된 아이템을 제외한 남은 아이템들의 가중치 합으로 재계산
    - 예: 아이템 C가 뽑힘 → 남은 합계 15 + 500 = 515
    - 새로운 확률: A(15/515 ≈ 2.9%), B(500/515 ≈ 97.1%)
3.  **특징**: 어떤 아이템이 먼저 뽑히더라도 남은 아이템들 중에서 항상 다음 당첨자가 결정되므로, 모든 참가자가 낙첨 없이 선물을 받을 수 있다.
