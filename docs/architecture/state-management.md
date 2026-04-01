# 상태 관리 (BLoC 패턴)

> 이 문서의 목적: BLoC 패턴 사용법, 이벤트/상태 흐름, 전체 BLoC 목록을 이해한다.

## BLoC 기본 패턴

이 프로젝트는 `flutter_bloc` 패키지를 사용한다.

### 이벤트 → 상태 흐름

```
View (UI)
  ↓  context.read<MyBloc>().add(MyEvent(...))
BLoC
  ↓  on<MyEvent>((event, emit) => _onMyEvent(event, emit))
  ↓  _onMyEvent: 비즈니스 로직 수행
  ↓  emit(state.copyWith(field: newValue))
View (UI)
  ↑  BlocBuilder<MyBloc, MyState>(builder: (ctx, state) { ... })
  ↑  BlocListener<MyBloc, MyState>(listener: (ctx, state) { ... })
```

### 상태 변경 패턴 (copyWith)

상태는 불변(immutable)이며, `copyWith`로만 변경한다:

```dart
// BLoC 내부
emit(state.copyWith(receiverName: event.name));

// 상태 클래스
GiftPackagingState copyWith({String? receiverName, ...}) {
  return GiftPackagingState(
    receiverName: receiverName ?? this.receiverName,
    ...
  );
}
```

### 비동기 이벤트 핸들러

```dart
Future<void> _onSubmitPackage(
  SubmitPackage event,
  Emitter<GiftPackagingState> emit,
) async {
  emit(state.copyWith(submitStatus: SubmitStatus.loading));
  try {
    final response = await api.createGift(jsonMap);
    emit(state.copyWith(submitStatus: SubmitStatus.success));
  } catch (e) {
    emit(state.copyWith(submitStatus: SubmitStatus.failure));
  }
}
```

## 전체 BLoC 목록

### 발신자 (addgift)

| BLoC | 파일 | 역할 |
|------|------|------|
| `GiftPackagingBloc` | `lib/features/addgift/application/gift_packaging_bloc.dart` | 선물 포장 8단계 전체 오케스트레이션 |
| `GachaSettingBloc` | `lib/features/addgift/application/gacha_setting/gacha_setting_bloc.dart` | 가챠 아이템 설정 |
| `MemoryGallerySettingBloc` | `lib/features/addgift/application/memory_gallery_setting/memory_gallery_setting_bloc.dart` | 메모리 갤러리 편집 |

### 수신자 (content)

| BLoC | 파일 | 역할 |
|------|------|------|
| `GachaBloc` | `lib/features/content/application/gacha/gacha_bloc.dart` | 캡슐 뽑기 게임 로직 |
| `QuizBloc` | `lib/features/content/application/quiz/quiz_bloc.dart` | 퀴즈 진행 및 채점 |
| `UnboxingBloc` | `lib/features/content/application/unboxing/unboxing_bloc.dart` | 바로 오픈 선물 수령 |
| `ContentBloc` | `lib/features/content/application/content_bloc.dart` | 공용 컨텐츠 데이터 홀더 |
| `ResultBloc` | `lib/features/content/application/result/result_bloc.dart` | 결과 화면 스크린샷 캡쳐 → DownloadBloc 위임 |

### 로비

| BLoC | 파일 | 역할 |
|------|------|------|
| `LobbyBloc` | `lib/features/lobby/application/lobby_bloc.dart` | 초대 코드 검증 |
| `DownloadBloc` | `lib/core/blocs/download/download_bloc.dart` | **공용** 파일 다운로드 (단일 PNG / ZIP 압축). 추억 갤러리, 가챠 기프티콘 등에서 공유하여 사용 |

## GiftPackagingBloc 상세

`lib/features/addgift/application/gift_packaging_bloc.dart`

**이벤트 목록:**

| 이벤트 | 처리 핸들러 | 상태 변화 |
|--------|------------|-----------|
| `SetReceiverName(name)` | `_onSetReceiverName` | `receiverName` 업데이트 |
| `SetGalleryItems(items)` | `_onSetGalleryItems` | `gallery` 업데이트 |
| `SetSubTitle(subTitle)` | `_onSetSubTitle` | `subTitle` 업데이트 |
| `SetBgm(bgm)` | `_onSetBgm` | `bgm` 업데이트 |
| `SetContentType(type)` | `_onSetContentType` | `selectedContentType` 업데이트 |
| `SetGachaContent(gacha)` | `_onSetGachaContent` | `gachaContent` 업데이트 |
| `SetQuizContent(quiz)` | `_onSetQuizContent` | `quizContent` 업데이트 |
| `SetUnboxingContent(unboxing)` | `_onSetUnboxingContent` | `unboxingContent` 업데이트 |
| `SubmitPackage(...)` | `_onSubmitPackage` | `submitStatus`: idle→loading→success/failure |
| `ResetPackaging()` | `_onResetPackaging` | `GiftPackagingState.initial()` 리셋 |

**상태 구조 (`GiftPackagingState`):**

```dart
class GiftPackagingState {
  final String receiverName;        // 받는 분 성함
  final String subTitle;            // 부제목 (랜덤 생성 or 입력)
  final String bgm;                 // BGM 선택값
  final List<GalleryItem> gallery;  // 메모리 갤러리 아이템 목록
  final ContentType? selectedContentType;  // gacha / quiz / unboxing
  final GachaContent? gachaContent;
  final QuizContent? quizContent;
  final UnboxingContent? unboxingContent;
  final SubmitStatus submitStatus;  // idle / loading / success / failure
}
```

초기 상태: `GiftPackagingState.initial()` - subTitle은 10개 중 랜덤 선택

## ShellRoute와 BLoC 생명주기

`GiftPackagingBloc`은 전역 인스턴스로 ShellRoute를 통해 선물 포장 전 단계에 공유된다:

```dart
// app_router.dart
final GiftPackagingBloc giftPackagingBloc = GiftPackagingBloc(); // 전역

ShellRoute(
  builder: (context, state, child) {
    return BlocProvider<GiftPackagingBloc>.value(
      value: giftPackagingBloc,
      child: child,
    );
  },
  routes: [ /* /addgift/* 모든 라우트 */ ],
)
```

수신자 컨텐츠 BLoC(`GachaBloc`, `QuizBloc`, `UnboxingBloc`)는 각 라우트 진입 시 새로 생성:

```dart
GoRoute(
  path: '/content/gacha',
  builder: (context, state) {
    return BlocProvider<GachaBloc>(
      create: (_) => GachaBloc(),  // 매번 새 인스턴스
      child: GachaView(code: code),
    );
  },
)
```

## 부모-자식 BLoC 동기화 패턴

`MemoryGallerySettingBloc`과 `GachaSettingBloc`은 변경 시마다 부모 `GiftPackagingBloc`에 동기화한다:

```dart
// MemoryGallerySettingBloc 생성자
MemoryGallerySettingBloc(this._packagingBloc)

// 변경 후 동기화
void _pushToPackagingBloc(List<MemoryGalleryItemData> uiItems) {
  final galleryItems = uiItems.map((item) => GalleryItem(...)).toList();
  _packagingBloc.add(SetGalleryItems(galleryItems));
}
// 아이템 추가/삭제/수정 등 모든 변경 핸들러 마지막에 호출
```
