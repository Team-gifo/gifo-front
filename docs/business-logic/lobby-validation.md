# 초대 코드 검증 로직

> 이 문서의 목적: 수신자가 초대 코드로 진입할 때 검증이 이루어지는 전체 흐름을 이해한다.

## 관련 파일

- `lib/core/router/app_router.dart` - GoRouter redirect에서 1차 검증
- `lib/features/lobby/application/lobby_bloc.dart` - 앱 내 코드 입력 검증
- `lib/features/lobby/model/lobby_data.dart` - 더미 데이터 + 코드 조회 함수
- `lib/features/lobby/repository/lobby_repository.dart` - 미래 API 연동 레이어

## 검증 흐름 (URL 직접 접근)

```
사용자가 /gift/code/helloworld 접근
    ↓
GoRouter.redirect() 실행
    ↓
state.matchedLocation.startsWith('/gift/code/')
    ↓
code = 'helloworld' 추출
    ↓
LobbyData.getDummyByCode('helloworld')
    ↓
null 아님 → 정상 통과 → LobbyView 렌더링
null이면 → _shouldShowInvalidCodeToast = true → return '/'
    ↓
HomeView(showInvalidCodeToast: true) → 토스트 표시
```

## 검증 흐름 (앱 내 코드 입력)

```
HomeView의 InviteModalContent
    ↓
사용자가 코드 입력 + 확인
    ↓
context.go('/gift/code/$enteredCode')
    ↓
GoRouter.redirect()에서 동일한 검증 실행
```

## LobbyData.getDummyByCode()

**파일:** `lib/features/lobby/model/lobby_data.dart`

```dart
static LobbyData? getDummyByCode(String code) {
  switch (code) {
    case 'helloworld': return _gachaDummy;   // 가챠 컨텐츠
    case 'quiz123':    return _quizDummy;    // 퀴즈 컨텐츠
    case 'open123':    return _openDummy;    // 언박싱 컨텐츠
    default:           return null;          // 유효하지 않은 코드
  }
}
```

반환값 `null` = 유효하지 않은 코드 → 라우터에서 홈 리다이렉트.

## LobbyBloc (앱 내 검증)

`LobbyBloc`은 `LobbyView` 내부에서 추가적인 상태 관리를 위해 사용될 수 있다.

| 이벤트 | 설명 |
|--------|------|
| `SubmitInviteCode(code)` | 코드 검증 요청 |
| `ResetLobby()` | 상태 초기화 |

**상태:**
```dart
enum LobbyCodeStatus { initial, valid, invalid }

class LobbyState {
  final LobbyCodeStatus status;
  final String? validatedCode;
}
```

## 실제 서버 연동으로 확장

현재는 더미 데이터로 동작하며, 실제 서버 API 연동 시:

**변경 범위: `LobbyRepository`만 교체**

```dart
// 현재 (더미):
class LobbyRepository {
  Future<LobbyData?> fetchByCode(String code) async {
    return LobbyData.getDummyByCode(code);  // 더미 데이터 반환
  }
}

// 변경 후 (실제 API):
class LobbyRepository {
  final ContentApi _api;

  Future<LobbyData?> fetchByCode(String code) async {
    try {
      final response = await _api.getContentByCode(code); // GET /api/events/{code}
      return LobbyData.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
```

BLoC과 View 레이어는 변경 불필요.

## 토스트 표시 메커니즘

잘못된 코드 진입 시 URL 파라미터 대신 전역 플래그 사용:

```dart
// 전역 플래그 (app_router.dart)
bool _shouldShowInvalidCodeToast = false;

// redirect에서 설정
_shouldShowInvalidCodeToast = true;
return '/';

// HomeView 빌더에서 읽고 즉시 리셋
final bool showToast = _shouldShowInvalidCodeToast;
if (showToast) _shouldShowInvalidCodeToast = false;
return HomeView(showInvalidCodeToast: showToast);
```

**이유:** URL 파라미터 방식 사용 시 새로고침마다 토스트가 반복 표시되고 URL이 지저분해지는 문제 방지.
