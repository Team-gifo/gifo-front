// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LobbyResponse _$LobbyResponseFromJson(Map<String, dynamic> json) =>
    _LobbyResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : LobbyData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LobbyResponseToJson(_LobbyResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
