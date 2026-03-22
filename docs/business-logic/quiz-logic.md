# 퀴즈 비즈니스 로직

> 이 문서의 목적: 퀴즈 채점 방식, 라이프 시스템, 성공/실패 판정, 상태 전이를 상세히 이해한다.

## 관련 파일

- `lib/features/content/application/quiz/quiz_bloc.dart`
- `lib/features/content/application/quiz/quiz_state.dart`
- `lib/features/lobby/model/lobby_data.dart`

## 초기화 로직 (InitQuiz)

```dart
void _onInitQuiz(InitQuiz event, Emitter<QuizState> emit) {
  final lobbyData = LobbyData.getDummyByCode(event.code);
  if (lobbyData == null || lobbyData.content?.quiz == null) return;

  final quiz = lobbyData.content!.quiz!;
  emit(state.copyWith(
    userName: lobbyData.user,
    quizContent: quiz,
    currentQuizIndex: 0,
    correctCount: 0,
    currentLives: quiz.list.isNotEmpty ? quiz.list[0].playLimit : 0,
    userAnswer: '',
    isFinished: false,
    isLastAnswerCorrect: null,
  ));
}
```

**주의:** 초기 `currentLives`는 첫 번째 문제(`list[0]`)의 `playLimit` 값.
각 문제마다 고유한 `playLimit`을 가질 수 있다.

## 정답 제출 로직 (SubmitAnswer)

```
SubmitAnswer 이벤트 수신
    ↓
Guard: quizContent == null이면 무시
Guard: userAnswer.trim().isEmpty이면 무시
    ↓
현재 문제 가져오기: quizContent.list[currentQuizIndex]
    ↓
정답 비교:
  isCorrect = currentQuiz.answer.any(
    (ans) => ans.toLowerCase() == userAnswer.trim().toLowerCase()
  )
    ↓
isCorrect == true:
  correctCount += 1
  nextIndex = currentQuizIndex + 1
  nextIndex >= list.length → isFinished: true (마지막 문제)
  nextIndex < list.length → 다음 문제로, currentLives = list[nextIndex].playLimit
    ↓
isCorrect == false:
  newLives = currentLives - 1
  newLives <= 0 → 기회 소진, 다음 문제로 강제 이동
    nextIndex >= list.length → isFinished: true
    nextIndex < list.length → currentLives = list[nextIndex].playLimit
  newLives > 0 → 같은 문제 유지, currentLives 감소
```

## 정답 비교 상세

```dart
final bool isCorrect = currentQuiz.answer.any(
  (String ans) =>
      ans.toLowerCase() == state.userAnswer.trim().toLowerCase(),
);
```

- **복수 정답 지원:** `answer`는 `List<String>`, `any()`로 하나라도 맞으면 정답
- **대소문자 무시:** `toLowerCase()` 적용
- **앞뒤 공백 제거:** `trim()` 적용

예시: `answer: ['O', '예', 'yes']` → 세 가지 중 하나 입력하면 정답

## 상태 전이 다이어그램

```
초기 상태 (isFinished: false)
    ↓ SetUserAnswer
답 입력 중 (userAnswer 업데이트)
    ↓ SubmitAnswer
정답 → (다음 문제) → 답 입력 중
        OR → (마지막 문제) → isFinished: true
오답 + 기회 있음 → 답 입력 중 (currentLives 감소)
오답 + 기회 소진 → (다음 문제) → 답 입력 중
                    OR → (마지막 문제) → isFinished: true
```

## 성공/실패 판정

`isFinished: true`가 되면 View에서 결과 판정:

```dart
final isSuccess = state.correctCount >= state.quizContent!.successReward.requiredCount;
```

- **성공:** `correctCount >= successReward.requiredCount` → 성공 보상 아이템으로 결과 화면 이동
- **실패:** 미만 → 실패 보상 아이템으로 결과 화면 이동

결과 화면 이동 시 전달:
```dart
context.go('/content/result', extra: {
  'itemName': isSuccess ? successReward.itemName : failReward.itemName,
  'imageUrl': isSuccess ? successReward.imageUrl : failReward.imageUrl,
  'userName': state.userName ?? '',
});
```

## QuizContent 모델 구조

```dart
@freezed
class QuizContent with _$QuizContent {
  const factory QuizContent({
    required List<QuizItemModel> list,
    @JsonKey(name: 'success_reward') required QuizSuccessReward successReward,
    @JsonKey(name: 'fail_reward') required QuizFailReward failReward,
  }) = _QuizContent;
}

class QuizItemModel {
  final String question;
  final List<String> answer;   // 복수 정답 가능
  final int playLimit;         // 이 문제의 최대 시도 횟수
}

class QuizSuccessReward {
  final int requiredCount;     // 성공 기준 정답 수
  final String itemName;
  final String imageUrl;
}
```
