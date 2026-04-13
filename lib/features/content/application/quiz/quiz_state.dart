part of 'quiz_bloc.dart';

class QuizState {
  final String userName;
  final String subTitle;
  // 공유 링크 및 결과 화면에 사용되는 초대 코드
  final String inviteCode;
  final QuizContent? quizContent;
  final int currentQuizIndex;
  final int currentLives;
  final int correctCount;
  final String userAnswer;
  final bool isFinished;
  // 마지막 제출의 정답 여부 (null이면 아직 제출 전)
  final bool? isLastAnswerCorrect;
  final bool isSubmitting;

  const QuizState({
    this.userName = '',
    this.subTitle = '',
    this.inviteCode = '',
    this.quizContent,
    this.currentQuizIndex = 0,
    this.currentLives = 0,
    this.correctCount = 0,
    this.userAnswer = '',
    this.isFinished = false,
    this.isLastAnswerCorrect,
    this.isSubmitting = false,
  });

  // 성공 기준 충족 여부 판별
  bool get isSuccess {
    if (quizContent == null) return false;
    final int requiredCount = quizContent!.successReward.requiredCount ?? 0;
    return correctCount >= requiredCount;
  }

  QuizState copyWith({
    String? userName,
    String? subTitle,
    String? inviteCode,
    QuizContent? quizContent,
    int? currentQuizIndex,
    int? currentLives,
    int? correctCount,
    String? userAnswer,
    bool? isFinished,
    bool? isLastAnswerCorrect,
    bool? isSubmitting,
  }) {
    return QuizState(
      userName: userName ?? this.userName,
      subTitle: subTitle ?? this.subTitle,
      inviteCode: inviteCode ?? this.inviteCode,
      quizContent: quizContent ?? this.quizContent,
      currentQuizIndex: currentQuizIndex ?? this.currentQuizIndex,
      currentLives: currentLives ?? this.currentLives,
      correctCount: correctCount ?? this.correctCount,
      userAnswer: userAnswer ?? this.userAnswer,
      isFinished: isFinished ?? this.isFinished,
      isLastAnswerCorrect: isLastAnswerCorrect, // nullable 특성 상 그대로 전달
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
