// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unboxing_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UnboxingContent _$UnboxingContentFromJson(Map<String, dynamic> json) =>
    _UnboxingContent(
      beforeOpen: BeforeOpen.fromJson(
        json['before_open'] as Map<String, dynamic>,
      ),
      afterOpen: AfterOpen.fromJson(json['after_open'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UnboxingContentToJson(_UnboxingContent instance) =>
    <String, dynamic>{
      'before_open': instance.beforeOpen,
      'after_open': instance.afterOpen,
    };

_BeforeOpen _$BeforeOpenFromJson(Map<String, dynamic> json) => _BeforeOpen(
  imageUrl: json['image_url'] as String? ?? '',
  description: json['description'] as String? ?? '',
);

Map<String, dynamic> _$BeforeOpenToJson(_BeforeOpen instance) =>
    <String, dynamic>{
      'image_url': instance.imageUrl,
      'description': instance.description,
    };

_AfterOpen _$AfterOpenFromJson(Map<String, dynamic> json) => _AfterOpen(
  itemName: json['item_name'] as String? ?? '',
  imageUrl: json['image_url'] as String? ?? '',
);

Map<String, dynamic> _$AfterOpenToJson(_AfterOpen instance) =>
    <String, dynamic>{
      'item_name': instance.itemName,
      'image_url': instance.imageUrl,
    };
