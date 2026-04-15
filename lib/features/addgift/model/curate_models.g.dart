// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curate_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CurateSurveyRequest _$CurateSurveyRequestFromJson(Map<String, dynamic> json) =>
    _CurateSurveyRequest(
      relationship: json['relationship'] as String,
      situation: json['situation'] as String,
      tone: json['tone'] as String,
      targetAge: json['targetAge'] as String,
      targetName: json['targetName'] as String?,
    );

Map<String, dynamic> _$CurateSurveyRequestToJson(
  _CurateSurveyRequest instance,
) => <String, dynamic>{
  'relationship': instance.relationship,
  'situation': instance.situation,
  'tone': instance.tone,
  'targetAge': instance.targetAge,
  'targetName': instance.targetName,
};

_CurateResponseData _$CurateResponseDataFromJson(Map<String, dynamic> json) =>
    _CurateResponseData(
      user: json['user'] as String? ?? '',
      subTitle: json['sub_title'] as String? ?? '',
      bgm: json['bgm'] as String? ?? '',
      gallery:
          (json['gallery'] as List<dynamic>?)
              ?.map((e) => GalleryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GalleryItem>[],
      content: json['content'] == null
          ? const GiftContent()
          : GiftContent.fromJson(json['content'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurateResponseDataToJson(_CurateResponseData instance) =>
    <String, dynamic>{
      'user': instance.user,
      'sub_title': instance.subTitle,
      'bgm': instance.bgm,
      'gallery': instance.gallery,
      'content': instance.content,
    };

_CurateApiEnvelope _$CurateApiEnvelopeFromJson(Map<String, dynamic> json) =>
    _CurateApiEnvelope(
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: CurateResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurateApiEnvelopeToJson(_CurateApiEnvelope instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
