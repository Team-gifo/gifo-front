// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GalleryItem _$GalleryItemFromJson(Map<String, dynamic> json) => _GalleryItem(
  title: json['title'] as String? ?? '',
  imageUrl: json['image_url'] as String? ?? '',
  description: json['description'] as String? ?? '',
);

Map<String, dynamic> _$GalleryItemToJson(_GalleryItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'image_url': instance.imageUrl,
      'description': instance.description,
    };
