import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/quiz/quiz_answer_request.dart';
import '../model/quiz/quiz_answer_response.dart';

part 'content_api.g.dart';

// Content 영역 API 인터페이스
@RestApi()
abstract class ContentApi {
  factory ContentApi(Dio dio, {String baseUrl}) = _ContentApi;

  // 퀴즈 답안 제출
  @POST('/api/events/{eventUrl}/quiz/answer')
  Future<QuizAnswerResponse> submitQuizAnswer(
    @Path('eventUrl') String eventUrl,
    @Body() QuizAnswerRequest request,
  );
}
