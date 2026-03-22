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

## QuizBloc 이벤트

| 이벤트 | 설명 |
|--------|------|
| `InitQuiz(code)` | 코드로 더미 데이터 조회, 첫 번째 퀴즈 초기화 |
| `SetUserAnswer(answer)` | 사용자 입력 답 업데이트 |
| `SubmitAnswer()` | 정답 제출, 채점 처리 |
| `ResetQuiz()` | 상태 초기화 |

## QuizState 구조

```dart
class QuizState {
  final String? userName;
  final QuizContent? quizContent;       // 전체 퀴즈 데이터
  final int currentQuizIndex;           // 현재 문제 인덱스
  final int correctCount;               // 정답 개수
  final int currentLives;               // 현재 문제 남은 기회 수
  final String userAnswer;              // 사용자 현재 입력
  final bool isFinished;                // 모든 문제 완료 여부
  final bool? isLastAnswerCorrect;      // 마지막 제출 결과 (애니메이션 트리거)
}
```

## 화면 진입 → 게임 흐름

```
LobbyView "시작" 버튼
    ↓ context.go('/content/quiz', extra: code)
QuizView 빌드
    ↓ initState()에서 QuizBloc.add(InitQuiz(code))
BLoC: LobbyData.getDummyByCode(code) 조회
    ↓ emit state with quizContent, currentLives = list[0].playLimit
UI: 첫 번째 문제 표시, 입력창 활성화
    ↓ 사용자 답 입력
QuizBloc.add(SetUserAnswer(text))
    ↓ emit state.copyWith(userAnswer: text)
    ↓ 사용자 제출 버튼 클릭
QuizBloc.add(SubmitAnswer())
    ↓ 정답 확인 + 다음 문제 이동 or 완료
UI(BlocListener): isFinished == true → 결과 화면 이동
```

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

## 결과 판정

모든 문제 완료 시 (`isFinished: true`) → `/content/result` 이동
- 성공: `correctCount >= successReward.requiredCount`
- 실패: 그 미만

ResultView로 전달하는 데이터:
- 성공/실패에 따른 보상 아이템 이름, 이미지 URL, 사용자 이름

자세한 로직: [business-logic/quiz-logic.md](../business-logic/quiz-logic.md)
