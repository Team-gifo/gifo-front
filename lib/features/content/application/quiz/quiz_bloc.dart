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
    final int serverIndex = quiz.currentQuizIndex;
    
    // 이미 완료된 퀴즈인지 체크 (인덱스가 전체 길이를 넘어가면 종료 상태로 시작)
    final bool isAlreadyFinished = serverIndex >= quiz.list.length;
    
    // 정답 횟수 계산 (서버에서 받은 history 기반)
    final int initialCorrectCount = quiz.answerHistory.where((h) => h.correct).length;

    emit(
      state.copyWith(
        userName: lobbyData.user,
        subTitle: lobbyData.subTitle,
        inviteCode: event.inviteCode,
        quizContent: quiz,
        currentQuizIndex: serverIndex,
        correctCount: initialCorrectCount,
        // 현재 인덱스의 남은 시도 횟수 설정 (문제가 없으면 0)
        currentLives: isAlreadyFinished 
            ? 0 
            : (quiz.remainingAttempts > 0 ? quiz.remainingAttempts : quiz.list[serverIndex].playLimit),
        userAnswer: '',
        isFinished: isAlreadyFinished,
        isLastAnswerCorrect: null,
      ),
    );
  }

  void _onSetUserAnswer(SetUserAnswer event, Emitter<QuizState> emit) {
    emit(state.copyWith(userAnswer: event.answer));
  }

  // 정답 제출 처리
  Future<void> _onSubmitAnswer(
    SubmitAnswer event,
    Emitter<QuizState> emit,
  ) async {
    if (state.quizContent == null || state.userAnswer.trim().isEmpty) return;
    if (state.isSubmitting) return;

    // 제출 시작 시점에 이전 정답 여부 초기화 및 로딩 상태 진입
    emit(state.copyWith(isSubmitting: true, isLastAnswerCorrect: null));

    final QuizItem currentQuiz =
        state.quizContent!.list[state.currentQuizIndex];

    final QuizAnswerRequest request = QuizAnswerRequest(
      quizId: currentQuiz.quizId,
      selectedAnswer: state.userAnswer.trim(),
    );

    try {
      final QuizAnswerResponse? response = await repository.submitQuizAnswer(
        state.inviteCode,
        request,
      );

      if (response == null) {
        // 통신 실패 처리: 로딩 해제 및 상태 유지
        emit(state.copyWith(isSubmitting: false));
        return;
      }

      if (response.code == 'QUIZ_ALREADY_ANSWERED') {
        // 이미 답변한 퀴즈 예외 처리
        emit(state.copyWith(isSubmitting: false, userAnswer: ''));
        return;
      }

      if (response.code == 'SUCCESS' && response.data != null) {
        final QuizAnswerData answerData = response.data!;
        final bool isCorrect = answerData.correct;
        final int newIndex = answerData.currentQuizIndex;
        final int newLives = answerData.remainingAttempts;

        final int newCorrectCount = isCorrect
            ? state.correctCount + 1
            : state.correctCount;

        // 결과 반영 - isLastAnswerCorrect를 통해 UI 애니메이션 트리거
        if (newIndex >= state.quizContent!.list.length) {
          // 마지막 문제 통과 후 종료 처리
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
          // 다음 문제로 이동 또는 현재 문제 상태 유지 (틀렸을 때 등)
          emit(
            state.copyWith(
              correctCount: newCorrectCount,
              currentQuizIndex: newIndex,
              currentLives: newLives > 0
                  ? newLives
                  : state.quizContent!.list[newIndex].playLimit,
              isLastAnswerCorrect: isCorrect,
              userAnswer: '',
              isSubmitting: false,
            ),
          );
        }
      } else {
        // 정의되지 않은 응답 상태 코드 처리
        emit(state.copyWith(isSubmitting: false));
      }
    } catch (e) {
      // 예상치 못한 런타임 에러 발생 시 처리
      emit(state.copyWith(isSubmitting: false));
    }
  }

  void _onResetQuiz(ResetQuiz event, Emitter<QuizState> emit) {
    emit(const QuizState());
  }
}
