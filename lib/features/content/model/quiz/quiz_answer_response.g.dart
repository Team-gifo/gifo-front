// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_answer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizAnswerResponse _$QuizAnswerResponseFromJson(Map<String, dynamic> json) =>
    _QuizAnswerResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : QuizAnswerData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuizAnswerResponseToJson(_QuizAnswerResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };

_QuizAnswerData _$QuizAnswerDataFromJson(Map<String, dynamic> json) =>
    _QuizAnswerData(
      quizId: (json['quizId'] as num).toInt(),
      correct: json['correct'] as bool,
      remainingAttempts: (json['remainingAttempts'] as num).toInt(),
      currentQuizIndex: (json['currentQuizIndex'] as num).toInt(),
    );

Map<String, dynamic> _$QuizAnswerDataToJson(_QuizAnswerData instance) =>
    <String, dynamic>{
      'quizId': instance.quizId,
      'correct': instance.correct,
      'remainingAttempts': instance.remainingAttempts,
      'currentQuizIndex': instance.currentQuizIndex,
    };
