// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capsule_draw_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CapsuleDrawResponse _$CapsuleDrawResponseFromJson(Map<String, dynamic> json) =>
    _CapsuleDrawResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : CapsuleDrawData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CapsuleDrawResponseToJson(
  _CapsuleDrawResponse instance,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'data': instance.data,
};

_CapsuleDrawData _$CapsuleDrawDataFromJson(Map<String, dynamic> json) =>
    _CapsuleDrawData(
      capsuleId: (json['capsuleId'] as num).toInt(),
      giftName: json['giftName'] as String?,
      giftImageUrl: json['giftImageUrl'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CapsuleDrawDataToJson(_CapsuleDrawData instance) =>
    <String, dynamic>{
      'capsuleId': instance.capsuleId,
      'giftName': instance.giftName,
      'giftImageUrl': instance.giftImageUrl,
      'description': instance.description,
    };
