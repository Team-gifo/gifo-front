# 퀴즈 컨텐츠

> 이 문서의 목적: 수신자가 퀴즈를 푸는 화면 구성, 상태, BLoC 이벤트를 이해한다.

## 라우트

`/content/quiz` → `QuizView` (with `QuizBloc`)

## 파일 목록

| 파일 | 역할 |
|------|------|
| `lib/features/content/presentation/quiz/quiz_view.dart` | 퀴즈 게임 UI |
| `lib/features/content/application/quiz/quiz_bloc.dart` | 퀴즈 게임 로직 |
| `lib/features/content/application/quiz/quiz_event.dart` | 이벤트 정의 |
| `lib/features/content/application/quiz/quiz_state.dart` | 상태 정의 |

---

## 레이아웃 구조

`AppBreakpoints`를 기준으로 디바이스별 레이아웃이 분기된다.

| 구간 | 레이아웃 |
|------|----------|
| `width >= 1024` (desktop) | Row 분할: 좌측 - 문제/이미지/힌트/남은 기회, 우측 - 입력 영역 |
| `width < 1024` (mobile/tablet) | 단일 컬럼, `SingleChildScrollView` 로 감싸 스크롤 지원 |

### AppBar

- `GachaView`의 AppBar 스타일을 기준으로 동일한 높이(`toolbarHeight`)와 색상을 적용한다.
- `centerTitle: false`를 명시하여 로고와 타이틀 텍스트가 항상 좌측에 배치된다.
- `actions` 프로퍼티를 통해 우측 컨텐츠를 배치한다.
  - 데스크톱: `_buildProgress(...)` 위젯 (원형 + 선형 진행률 표시)
  - 모바일/태블릿: `현재 문제 번호 / 전체 문제 수` 형태의 텍스트

### 힌트 노출 정책

- 모바일(`width < AppBreakpoints.tablet`) 기준 힌트가 비어있으면 해당 텍스트 위젯 자체를 렌더링하지 않는다.
- 데스크톱/태블릿에서는 힌트가 없을 경우 "제공되지 않음"으로 표시한다.

---

## QuizBloc 이벤트

| 이벤트 | 설명 |
|--------|------|
| `InitQuiz(code)` | 코드로 더미 데이터 조회, 첫 번째 퀴즈 초기화 |
| `SetUserAnswer(answer)` | 사용자 입력 답 업데이트 |
| `SubmitAnswer()` | 정답 제출, 채점 처리 |
| `ResetQuiz()` | 상태 초기화 |

---

## QuizState 구조

```dart
class QuizState {
  final String userName;
  final String subTitle;
  final QuizContent? quizContent;       // 전체 퀴즈 데이터
  final int currentQuizIndex;           // 현재 문제 인덱스
  final int correctCount;               // 정답 개수
  final int currentLives;               // 현재 문제 남은 기회 수
  final String userAnswer;              // 사용자 현재 입력
  final bool isFinished;                // 모든 문제 완료 여부
  final bool? isLastAnswerCorrect;      // 마지막 제출 결과 (null = 아직 미제출)
}
```

---

## 화면 진입 → 게임 흐름

```
LobbyView "시작" 버튼
    ↓ context.go('/content/quiz', extra: code)
QuizView 빌드
    ↓ initState()에서 QuizBloc.add(InitQuiz(code))
BLoC: LobbyData.getDummyByCode(code) 조회
    ↓ emit state with quizContent, currentLives = list[0].playLimit
UI: 첫 번째 문제 표시, 입력창 활성화
    ↓ 사용자 답 입력 / 객관식 버튼 선택
QuizBloc.add(SetUserAnswer(text))
    ↓ emit state.copyWith(userAnswer: text)
    ↓ 사용자 제출 버튼 클릭 (userAnswer가 비어있으면 버튼 비활성화)
QuizBloc.add(SubmitAnswer())
    ↓ 정답 확인
    ↓ isLastAnswerCorrect 갱신 → BlocListener에서 O/X 애니메이션 트리거
    ↓ 다음 문제 이동 or 완료
UI(BlocListener): isFinished == true → 결과 화면 이동
```

---

## 채점 로직

정답 비교:
```dart
final bool isCorrect = currentQuiz.answer.any(
  (ans) => ans.toLowerCase() == state.userAnswer.trim().toLowerCase(),
);
```
- 대소문자 무시 (`toLowerCase()`)
- 앞뒤 공백 제거 (`trim()`)
- 복수 정답 지원 (`any(...)`)

라이프 시스템: 오답 시 `currentLives - 1`, 0이 되면 다음 문제로 강제 이동

---

## 정답 제출 피드백 애니메이션

Toast 메시지를 제거하고 화면 중앙에 O/X 오버레이 애니메이션으로 대체한다.

- `_QuizViewState`는 `SingleTickerProviderStateMixin`을 사용한다.
- `AnimationController` (duration: 1000ms)를 통해 두 가지 애니메이션을 합성한다.
  - `_scaleAnimation`: `Interval(0.0, 0.6)` + `Curves.elasticOut` → 중앙에서 크게 튕기듯 등장
  - `_fadeAnimation`: `Interval(0.7, 1.0)` + `Curves.easeOut` → 이후 서서히 사라짐
- 정답: `AppColors.neonBlue` 색상 "O" 텍스트 (PFStardust 폰트, 160px)
- 오답: `Colors.redAccent` 색상 "X" 텍스트 (PFStardust 폰트, 160px)
- `IgnorePointer`로 감싸 애니메이션 재생 중 사용자 입력을 차단하지 않는다.
- 애니메이션 완료 후 `_showAnimation = false`로 자동 정리된다.

```dart
// BlocListener 내부: isLastAnswerCorrect 변경 시 애니메이션 실행
if (state.isLastAnswerCorrect != null) {
  _triggerAnswerAnimation(state.isLastAnswerCorrect!);
}
```

---

## 오답 처리 시 입력 필드 초기화

오답 제출 후 각 문제 유형의 입력 UI가 자동으로 초기 상태로 롤백된다.

- `QuizBloc._onSubmitAnswer`에서 오답 처리 시 `userAnswer: ''`로 상태를 초기화한다.
- `_triggerAnswerAnimation` 내부에서도 `_textController.clear()`를 실행하여 주관식 TextField를 명시적으로 비운다.
- 이를 통해 객관식 선택 버튼, OX 버튼, 주관식 TextField 모두 오답 직후 선택 해제/빈 값 상태로 복귀한다.

---

## 객관식 UI 규칙

- 답안 버튼은 선택 전 `1.`, `2.`, `3.` 형태의 순번을 prefix로 표시한다.
- 선택하면 해당 버튼의 prefix가 `A.`로 변경되고, 체크 아이콘(`Icons.check_circle`)이 좌측에 표시된다.
- 선택된 버튼 배경색: `AppColors.neonPurple`, 미선택 시: 흰색
- 버튼 borderSide: 선택 시 `AppColors.neonPurple`, 미선택 시 `Colors.grey`
- 버튼 크기: 너비 `isMobile ? double.infinity : 400`, 높이 `60px`
- 데스크톱: `Column` 배치 / 모바일·태블릿: `Column` 배치 (스크롤 영역 내)

---

## 정답 제출 버튼 활성화 조건

모든 문제 유형 공통: `state.userAnswer.trim().isNotEmpty`를 만족할 때만 버튼 활성화.
- 객관식: 답안 버튼 선택 시 `SetUserAnswer(opt)` 호출 → 버튼 활성화
- OX: O 또는 X 버튼 선택 시 `SetUserAnswer(value)` 호출 → 버튼 활성화
- 주관식: TextField에 텍스트 입력 시 `SetUserAnswer(v)` 호출 → 버튼 활성화

---

## 이미지 표시

`QuizItem.imageUrl`이 비어있지 않을 경우에만 이미지 위젯을 렌더링한다.

| 구간 | 최대 너비 | 최대 높이 |
|------|-----------|-----------|
| desktop | 600px | 350px |
| tablet | 500px | 280px |
| mobile | infinity | 220px |

- `BoxFit.contain` 적용으로 이미지 비율 보존 (가로/세로 방향 모두 대응)
- URL이 `http`로 시작하면 `Image.network`, 아니면 `Image.asset`으로 분기

---

## 결과 판정

모든 문제 완료 시 (`isFinished: true`) → `/content/result` 이동
- 성공: `correctCount >= successReward.requiredCount`
- 실패: 그 미만

ResultView로 전달하는 데이터:
- 성공/실패에 따른 보상 아이템 이름, 이미지 URL, 사용자 이름

자세한 로직: [business-logic/quiz-logic.md](../business-logic/quiz-logic.md)
