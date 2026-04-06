import '../model/quiz/quiz_answer_request.dart';
import '../model/quiz/quiz_answer_response.dart';
import 'content_api.dart';

// 콘텐츠와 관련된 데이터 요청을 담당하는 repository
class ContentRepository {
  final ContentApi _api;

  ContentRepository(this._api);

  // 퀴즈 답안 제출
  Future<QuizAnswerResponse?> submitQuizAnswer(
      String eventUrl, QuizAnswerRequest request) async {
    try {
      final QuizAnswerResponse response =
          await _api.submitQuizAnswer(eventUrl, request);
      return response;
    } catch (e) {
      // 오류 발생 시 null 반환 또는 로깅
      return null;
    }
  }
}
