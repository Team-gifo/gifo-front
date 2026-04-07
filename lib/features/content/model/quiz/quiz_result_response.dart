import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_result_response.freezed.dart';
part 'quiz_result_response.g.dart';

@freezed
abstract class QuizResultResponse with _$QuizResultResponse {
  const factory QuizResultResponse({
    required String code,
    required String message,
    QuizResultData? data,
  }) = _QuizResultResponse;

  factory QuizResultResponse.fromJson(Map<String, dynamic> json) =>
      _$QuizResultResponseFromJson(json);
}

@freezed
abstract class QuizResultData with _$QuizResultData {
  const factory QuizResultData({
    required int correctCount,
    required bool success,
  }) = _QuizResultData;

  factory QuizResultData.fromJson(Map<String, dynamic> json) =>
      _$QuizResultDataFromJson(json);
}
