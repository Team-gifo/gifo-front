// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GiftRequest _$GiftRequestFromJson(Map<String, dynamic> json) => _GiftRequest(
  user: json['user'] as String? ?? '',
  subTitle: json['sub_title'] as String? ?? '',
  bgm: json['bgm'] as String? ?? '',
  password: json['password'] as String? ?? '',
  senderName: json['sender_name'] as String? ?? '',
  gallery:
      (json['gallery'] as List<dynamic>?)
          ?.map((e) => GalleryItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <GalleryItem>[],
  uploadedBgmUrls:
      (json['uploaded_bgm_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  expiredAt: json['expired_at'] as String?,
  content: GiftContent.fromJson(json['content'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GiftRequestToJson(_GiftRequest instance) =>
    <String, dynamic>{
      'user': instance.user,
      'sub_title': instance.subTitle,
      'bgm': instance.bgm,
      'password': instance.password,
      'sender_name': instance.senderName,
      'gallery': instance.gallery,
      'uploaded_bgm_urls': instance.uploadedBgmUrls,
      'expired_at': ?instance.expiredAt,
      'content': instance.content,
    };
