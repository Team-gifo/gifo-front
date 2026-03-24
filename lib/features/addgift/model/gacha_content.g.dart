// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gacha_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GachaContent _$GachaContentFromJson(Map<String, dynamic> json) =>
    _GachaContent(
      playCount: (json['play_count'] as num?)?.toInt() ?? 3,
      list:
          (json['list'] as List<dynamic>?)
              ?.map((e) => GachaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GachaItem>[],
    );

Map<String, dynamic> _$GachaContentToJson(_GachaContent instance) =>
    <String, dynamic>{'play_count': instance.playCount, 'list': instance.list};

_GachaItem _$GachaItemFromJson(Map<String, dynamic> json) => _GachaItem(
  itemName: json['item_name'] as String? ?? '',
  imageUrl: json['image_url'] as String? ?? '',
  percent: (json['percent'] as num?)?.toDouble() ?? 0.0,
  percentOpen: json['percent_open'] as bool? ?? false,
);

Map<String, dynamic> _$GachaItemToJson(_GachaItem instance) =>
    <String, dynamic>{
      'item_name': instance.itemName,
      'image_url': instance.imageUrl,
      'percent': instance.percent,
      'percent_open': instance.percentOpen,
    };
