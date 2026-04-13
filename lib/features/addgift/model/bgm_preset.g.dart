// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bgm_preset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BgmPreset _$BgmPresetFromJson(Map<String, dynamic> json) => _BgmPreset(
  id: json['id'] as String,
  name: json['name'] as String,
  url: json['url'] as String? ?? '',
);

Map<String, dynamic> _$BgmPresetToJson(_BgmPreset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
    };
