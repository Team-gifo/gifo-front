import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../lobby/model/lobby_data.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

// 퀴즈 콘텐츠 상태 관리 BLoC
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(const QuizState()) {
    on<InitQuiz>(_onInitQuiz);
    on<SetUserAnswer>(_onSetUserAnswer);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<ResetQuiz>(_onResetQuiz);
  }

  void _onInitQuiz(InitQuiz event, Emitter<QuizState> emit) {
    final LobbyData? lobbyData = LobbyData.getDummyByCode(event.code);
    if (lobbyData == null || lobbyData.content?.quiz == null) return;

    final QuizContent quiz = lobbyData.content!.quiz!;
    emit(
      state.copyWith(
        userName: lobbyData.user,
        subTitle: lobbyData.subTitle,
        quizContent: quiz,
        currentQuizIndex: 0,
        correctCount: 0,
        currentLives: quiz.list.isNotEmpty ? quiz.list[0].playLimit : 0,
        userAnswer: '',
        isFinished: false,
        isLastAnswerCorrect: null,
      ),
    );
  }

  void _onSetUserAnswer(SetUserAnswer event, Emitter<QuizState> emit) {
    emit(state.copyWith(userAnswer: event.answer));
  }

  // 정답 제출 처리
  void _onSubmitAnswer(SubmitAnswer event, Emitter<QuizState> emit) {
    if (state.quizContent == null) return;
    if (state.userAnswer.trim().isEmpty) return;

    final QuizItem currentQuiz = state.quizContent!.list[state.currentQuizIndex];
    final bool isCorrect = currentQuiz.answer.any(
      (String ans) =>
          ans.toLowerCase() == state.userAnswer.trim().toLowerCase(),
    );

    if (isCorrect) {
      final int newCorrectCount = state.correctCount + 1;
      final int nextIndex = state.currentQuizIndex + 1;

      // 마지막 문제 여부 체크
      if (nextIndex >= state.quizContent!.list.length) {
        emit(
          state.copyWith(
            correctCount: newCorrectCount,
            currentQuizIndex: nextIndex,
            isFinished: true,
            isLastAnswerCorrect: true,
            userAnswer: '',
          ),
        );
      } else {
        emit(
          state.copyWith(
            correctCount: newCorrectCount,
            currentQuizIndex: nextIndex,
            currentLives: state.quizContent!.list[nextIndex].playLimit,
            isLastAnswerCorrect: true,
            userAnswer: '',
          ),
        );
      }
    } else {
      final int newLives = state.currentLives - 1;

      if (newLives <= 0) {
        // 기회 소진 시 다음 문제로 이동
        final int nextIndex = state.currentQuizIndex + 1;
        if (nextIndex >= state.quizContent!.list.length) {
          emit(
            state.copyWith(
              currentQuizIndex: nextIndex,
              isFinished: true,
              isLastAnswerCorrect: false,
              userAnswer: '',
            ),
          );
        } else {
          emit(
            state.copyWith(
              currentQuizIndex: nextIndex,
              currentLives: state.quizContent!.list[nextIndex].playLimit,
              isLastAnswerCorrect: false,
              userAnswer: '',
            ),
          );
        }
      } else {
        emit(
          state.copyWith(currentLives: newLives, isLastAnswerCorrect: false),
        );
      }
    }
  }

  void _onResetQuiz(ResetQuiz event, Emitter<QuizState> emit) {
    emit(const QuizState());
  }
}
