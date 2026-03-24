// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GiftRequest _$GiftRequestFromJson(Map<String, dynamic> json) => _GiftRequest(
  user: json['user'] as String? ?? '',
  subTitle: json['sub_title'] as String? ?? '',
  bgm: json['bgm'] as String? ?? '',
  gallery:
      (json['gallery'] as List<dynamic>?)
          ?.map((e) => GalleryItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <GalleryItem>[],
  content: GiftContent.fromJson(json['content'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GiftRequestToJson(_GiftRequest instance) =>
    <String, dynamic>{
      'user': instance.user,
      'sub_title': instance.subTitle,
      'bgm': instance.bgm,
      'gallery': instance.gallery,
      'content': instance.content,
    };
