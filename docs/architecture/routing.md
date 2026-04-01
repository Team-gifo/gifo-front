# 라우팅 (GoRouter)

> 이 문서의 목적: 전체 라우트 구조, ShellRoute 패턴, 파라미터 전달 방식, 리다이렉트 로직을 이해한다.

**파일:** `lib/core/router/app_router.dart`

## 전체 라우트 트리

```
/                              → HomeView (랜딩)
/lobby                         → LobbyView (레거시, extra로 code 전달)
/gift/code/:code               → LobbyView (공유 URL, URL 경로에 코드 포함)
/memory-gallery                → MemoryGalleryView (수신자 추억 갤러리)
/content/gacha                 → GachaView (캡슐 뽑기)
/content/quiz                  → QuizView (퀴즈)
/content/unboxing              → UnboxingView (바로 오픈)

ShellRoute (GiftPackagingBloc 공유)
  /addgift                     → ReceiverNameView (Step 1)
  /addgift/memory-decision     → MemoryDecisionView (Step 2)
  /addgift/memory-gallery      → MemoryGallerySettingView (Step 3)
  /addgift/delivery-method     → GiftDeliveryMethodView (Step 4)
  /addgift/gacha-setting       → GachaSettingView (Step 5a)
  /addgift/quiz-setting        → QuizSettingView (Step 5b)
  /addgift/direct-open-setting → DirectOpenSettingView (Step 5c)
  /addgift/package-complete    → PackageCompleteView (Step 6)
```

## ShellRoute 패턴

ShellRoute는 `/addgift/*` 라우트 전체를 감싸서 `GiftPackagingBloc` 인스턴스를 유지한다.
각 서브 라우트로 이동해도 BLoC 상태가 보존된다.

```dart
ShellRoute(
  builder: (context, state, child) {
    return BlocProvider<GiftPackagingBloc>.value(
      value: giftPackagingBloc,  // 전역 인스턴스
      child: child,
    );
  },
  routes: [ ... ],
)
```

## 파라미터 전달 방식

### 1. 경로 파라미터 (path parameters)
URL 경로에 포함되는 방식. 공유 가능한 URL에 사용.

```dart
GoRoute(path: '/gift/code/:code', ...)
// 접근: state.pathParameters['code']
```

### 2. extra 파라미터
`context.go(path, extra: data)` 방식. URL에 노출되지 않으며 새로고침 시 유지되지 않음.

```dart
// 전달
context.go('/content/gacha', extra: code);

// 수신
final code = state.extra as String? ?? 'helloworld';
final extra = state.extra as Map<String, dynamic>?;
```

## 리다이렉트 로직

`GoRouter`의 `redirect` 콜백에서 두 가지 경우를 처리:

### 1. 포장 완료 후 addgift 재진입 차단
```dart
if (isPackageComplete) {
  if (state.matchedLocation.startsWith('/addgift') &&
      state.matchedLocation != '/addgift/package-complete') {
    return '/';  // 홈으로 리다이렉트
  }
}
```

`isPackageComplete`는 전역 bool 변수. `PackageCompleteView`에서 true로 설정.

### 2. 유효하지 않은 초대 코드 사전 검증
```dart
if (state.matchedLocation.startsWith('/gift/code/')) {
  final code = state.matchedLocation.replaceFirst('/gift/code/', '').trim();
  if (code.isEmpty || LobbyData.getDummyByCode(code) == null) {
    _shouldShowInvalidCodeToast = true;
    return '/';  // 홈으로 리다이렉트
  }
}
```

## 에러 처리

정의되지 않은 경로 접근 시 `_ErrorRedirectPage`로 처리:

```dart
errorBuilder: (context, state) => const _ErrorRedirectPage()
```

`_ErrorRedirectPage`는:
1. `initState()`에서 `addPostFrameCallback` 등록 (build 중 context 사용 방지)
2. 콜백에서 `_shouldShowInvalidCodeToast = true` 설정
3. `GoRouter.of(context).go('/')` 실행
4. 빈 검은 화면 렌더링 (깜빡임 최소화)

## 전역 플래그

`app_router.dart` 파일 최상단에 전역 플래그 두 개가 선언되어 있다:

```dart
bool isPackageComplete = false;           // 포장 완료 여부
bool _shouldShowInvalidCodeToast = false; // 잘못된 코드 토스트 1회성 표시
```

`HomeView`는 `showInvalidCodeToast` 파라미터로 토스트 표시 여부를 받아 처리.
URL 파라미터 대신 전역 플래그를 사용하는 이유: URL이 더러워지고 새로고침 시 계속 뜨는 문제 방지.
