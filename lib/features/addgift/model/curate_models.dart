import 'package:freezed_annotation/freezed_annotation.dart';

import 'gallery_item.dart';
import 'gift_content.dart';

part 'curate_models.freezed.dart';
part 'curate_models.g.dart';

@freezed
abstract class CurateSurveyRequest with _$CurateSurveyRequest {
  const factory CurateSurveyRequest({
    required String relationship,
    required String situation,
    required String tone,
    required String targetAge,
    String? targetName,
  }) = _CurateSurveyRequest;

  factory CurateSurveyRequest.fromJson(Map<String, dynamic> json) =>
      _$CurateSurveyRequestFromJson(json);
}

@freezed
abstract class CurateResponseData with _$CurateResponseData {
  const factory CurateResponseData({
    @Default('') String user,
    @JsonKey(name: 'sub_title') @Default('') String subTitle,
    @Default('') String bgm,
    @Default(<GalleryItem>[]) List<GalleryItem> gallery,
    @Default(GiftContent()) GiftContent content,
  }) = _CurateResponseData;

  factory CurateResponseData.fromJson(Map<String, dynamic> json) =>
      _$CurateResponseDataFromJson(json);
}

/// 백엔드 공통 응답 래퍼(큐레이션 전용): { code, message, data }
@freezed
abstract class CurateApiEnvelope with _$CurateApiEnvelope {
  const factory CurateApiEnvelope({
    @Default('') String code,
    @Default('') String message,
    required CurateResponseData data,
  }) = _CurateApiEnvelope;

  factory CurateApiEnvelope.fromJson(Map<String, dynamic> json) =>
      _$CurateApiEnvelopeFromJson(json);
}

