part of 'quiz_bloc.dart';

abstract class QuizEvent {
  const QuizEvent();
}

// LobbyBloc에서 수신한 LobbyData와 초대 코드를 직접 전달받아 초기화
class InitQuiz extends QuizEvent {
  final LobbyData lobbyData;
  // 결과 화면 공유 링크에 사용되는 초대 코드
  final String inviteCode;
  const InitQuiz(this.lobbyData, {this.inviteCode = ''});
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
