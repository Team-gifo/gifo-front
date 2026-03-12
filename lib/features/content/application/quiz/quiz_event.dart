part of 'quiz_bloc.dart';

abstract class QuizEvent {
  const QuizEvent();
}

// 코드 기반 퀴즈 데이터 초기화
class InitQuiz extends QuizEvent {
  final String code;
  const InitQuiz(this.code);
}

// 사용자 답변 입력
class SetUserAnswer extends QuizEvent {
  final String answer;
  const SetUserAnswer(this.answer);
}

// 정답 제출
class SubmitAnswer extends QuizEvent {
  const SubmitAnswer();
}

// 상태 초기화
class ResetQuiz extends QuizEvent {
  const ResetQuiz();
}
