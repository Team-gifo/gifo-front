import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_answer_response.freezed.dart';
part 'quiz_answer_response.g.dart';

@freezed
abstract class QuizAnswerResponse with _$QuizAnswerResponse {
  const factory QuizAnswerResponse({
    required String code,
    required String message,
    QuizAnswerData? data,
  }) = _QuizAnswerResponse;

  factory QuizAnswerResponse.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerResponseFromJson(json);
}

@freezed
abstract class QuizAnswerData with _$QuizAnswerData {
  const factory QuizAnswerData({
    required int quizId,
    required bool correct,
    required int remainingAttempts,
    required int currentQuizIndex,
  }) = _QuizAnswerData;

  factory QuizAnswerData.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerDataFromJson(json);
}
