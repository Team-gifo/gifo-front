// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizContent _$QuizContentFromJson(Map<String, dynamic> json) => _QuizContent(
  successReward: QuizSuccessReward.fromJson(
    json['success_reward'] as Map<String, dynamic>,
  ),
  failReward: QuizFailReward.fromJson(
    json['fail_reward'] as Map<String, dynamic>,
  ),
  list:
      (json['list'] as List<dynamic>?)
          ?.map((e) => QuizItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <QuizItemModel>[],
);

Map<String, dynamic> _$QuizContentToJson(_QuizContent instance) =>
    <String, dynamic>{
      'success_reward': instance.successReward,
      'fail_reward': instance.failReward,
      'list': instance.list,
    };

_QuizSuccessReward _$QuizSuccessRewardFromJson(Map<String, dynamic> json) =>
    _QuizSuccessReward(
      requiredCount: (json['required_count'] as num?)?.toInt() ?? 1,
      itemName: json['item_name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
    );

Map<String, dynamic> _$QuizSuccessRewardToJson(_QuizSuccessReward instance) =>
    <String, dynamic>{
      'required_count': instance.requiredCount,
      'item_name': instance.itemName,
      'image_url': instance.imageUrl,
    };

_QuizFailReward _$QuizFailRewardFromJson(Map<String, dynamic> json) =>
    _QuizFailReward(
      itemName: json['item_name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
    );

Map<String, dynamic> _$QuizFailRewardToJson(_QuizFailReward instance) =>
    <String, dynamic>{
      'item_name': instance.itemName,
      'image_url': instance.imageUrl,
    };

_QuizItemModel _$QuizItemModelFromJson(
  Map<String, dynamic> json,
) => _QuizItemModel(
  quizId: (json['quiz_id'] as num?)?.toInt() ?? 0,
  type: json['type'] as String? ?? 'multiple_choice',
  title: json['title'] as String? ?? '',
  imageUrl: json['image_url'] as String?,
  description: json['description'] as String?,
  hint: json['hint'] as String?,
  options:
      (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  answer:
      (json['answer'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  playLimit: (json['play_limit'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$QuizItemModelToJson(_QuizItemModel instance) =>
    <String, dynamic>{
      'quiz_id': instance.quizId,
      'type': instance.type,
      'title': instance.title,
      'image_url': instance.imageUrl,
      'description': instance.description,
      'hint': instance.hint,
      'options': instance.options,
      'answer': instance.answer,
      'play_limit': instance.playLimit,
    };
