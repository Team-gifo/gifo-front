import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_answer_request.freezed.dart';
part 'quiz_answer_request.g.dart';

@freezed
abstract class QuizAnswerRequest with _$QuizAnswerRequest {
  const factory QuizAnswerRequest({
    required int quizId,
    required String selectedAnswer,
  }) = _QuizAnswerRequest;

  factory QuizAnswerRequest.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerRequestFromJson(json);
}
