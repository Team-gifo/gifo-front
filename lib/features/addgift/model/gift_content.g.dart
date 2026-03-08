// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GiftContent _$GiftContentFromJson(Map<String, dynamic> json) => _GiftContent(
  gacha: json['gacha'] == null
      ? null
      : GachaContent.fromJson(json['gacha'] as Map<String, dynamic>),
  quiz: json['quiz'] == null
      ? null
      : QuizContent.fromJson(json['quiz'] as Map<String, dynamic>),
  unboxing: json['unboxing'] == null
      ? null
      : UnboxingContent.fromJson(json['unboxing'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GiftContentToJson(_GiftContent instance) =>
    <String, dynamic>{
      'gacha': instance.gacha,
      'quiz': instance.quiz,
      'unboxing': instance.unboxing,
    };
