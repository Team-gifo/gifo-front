import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/quiz/quiz_answer_response.dart';

import '../../../lobby/model/lobby_data.dart';
import '../../model/quiz/quiz_answer_request.dart';
import '../../repository/content_repository.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

// 퀴즈 콘텐츠 상태 관리 BLoC
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final ContentRepository repository;

  QuizBloc({required this.repository}) : super(const QuizState()) {
    on<InitQuiz>(_onInitQuiz);
    on<SetUserAnswer>(_onSetUserAnswer);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<ResetQuiz>(_onResetQuiz);
  }

  // LobbyBloc에서 전달받은 LobbyData로 퀴즈 상태 초기화
  void _onInitQuiz(InitQuiz event, Emitter<QuizState> emit) {
    final LobbyData lobbyData = event.lobbyData;
    if (lobbyData.content?.quiz == null) return;

    final QuizContent quiz = lobbyData.content!.quiz!;
    emit(
      state.copyWith(
        userName: lobbyData.user,
        subTitle: lobbyData.subTitle,
        inviteCode: event.inviteCode,
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
  Future<void> _onSubmitAnswer(
      SubmitAnswer event, Emitter<QuizState> emit) async {
    if (state.quizContent == null || state.userAnswer.trim().isEmpty) return;
    if (state.isSubmitting) return;

    emit(state.copyWith(isSubmitting: true));

    final QuizItem currentQuiz =
        state.quizContent!.list[state.currentQuizIndex];

    final QuizAnswerRequest request = QuizAnswerRequest(
      quizId: currentQuiz.quizId,
      selectedAnswer: state.userAnswer.trim(),
    );

    final QuizAnswerResponse? response = await repository.submitQuizAnswer(state.inviteCode, request);

    if (response == null) {
      // 통신 실패 처리
      emit(state.copyWith(isSubmitting: false));
      return;
    }

    if (response.code == 'QUIZ_ALREADY_ANSWERED') {
      // 이미 답변한 퀴즈 예외 처리 (UI측 스낵바 등 반영)
      emit(state.copyWith(
        isSubmitting: false,
        userAnswer: '',
      ));
      return;
    }

    if (response.code == 'SUCCESS' && response.data != null) {
      final QuizAnswerData answerData = response.data!;
      final bool isCorrect = answerData.correct;
      final int newIndex = answerData.currentQuizIndex;
      final int newLives = answerData.remainingAttempts;
      
      final int newCorrectCount = isCorrect ? state.correctCount + 1 : state.correctCount;

      // 마지막 퀴즈 여부 체크 로직 보정 (만약 newIndex가 전체 개수 이상이거나, 성공인데 더이상 문제가 없다면)
      // 문제 하나를 푼 직후 맞거나/틀리면 서버에서 다음 index를 반환(틀려도 스킵이라면 index가 바뀜)
      // currentQuizIndex 가 list.length 이상이면 마지막으로 간주
      if (newIndex >= state.quizContent!.list.length) {
        emit(
          state.copyWith(
            correctCount: newCorrectCount,
            currentQuizIndex: newIndex,
            currentLives: newLives,
            isFinished: true,
            isLastAnswerCorrect: isCorrect,
            userAnswer: '',
            isSubmitting: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            correctCount: newCorrectCount,
            currentQuizIndex: newIndex,
            currentLives: newLives > 0 ? newLives : state.quizContent!.list[newIndex].playLimit,
            isLastAnswerCorrect: isCorrect,
            userAnswer: '',
            isSubmitting: false,
          ),
        );
      }
    } else {
      // 기타 응답 예외
      emit(state.copyWith(isSubmitting: false));
    }
  }

  void _onResetQuiz(ResetQuiz event, Emitter<QuizState> emit) {
    emit(const QuizState());
  }
}
