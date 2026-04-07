// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_answer_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizAnswerRequest _$QuizAnswerRequestFromJson(Map<String, dynamic> json) =>
    _QuizAnswerRequest(
      quizId: (json['quizId'] as num).toInt(),
      selectedAnswer: json['selectedAnswer'] as String,
    );

Map<String, dynamic> _$QuizAnswerRequestToJson(_QuizAnswerRequest instance) =>
    <String, dynamic>{
      'quizId': instance.quizId,
      'selectedAnswer': instance.selectedAnswer,
    };
