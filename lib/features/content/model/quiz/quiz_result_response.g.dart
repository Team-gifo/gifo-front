// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_result_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizResultResponse _$QuizResultResponseFromJson(Map<String, dynamic> json) =>
    _QuizResultResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : QuizResultData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuizResultResponseToJson(_QuizResultResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };

_QuizResultData _$QuizResultDataFromJson(Map<String, dynamic> json) =>
    _QuizResultData(
      correctCount: (json['correctCount'] as num).toInt(),
      success: json['success'] as bool,
    );

Map<String, dynamic> _$QuizResultDataToJson(_QuizResultData instance) =>
    <String, dynamic>{
      'correctCount': instance.correctCount,
      'success': instance.success,
    };
