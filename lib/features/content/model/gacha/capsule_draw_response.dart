import 'package:freezed_annotation/freezed_annotation.dart';

part 'capsule_draw_response.freezed.dart';
part 'capsule_draw_response.g.dart';

@freezed
abstract class CapsuleDrawResponse with _$CapsuleDrawResponse {
  const factory CapsuleDrawResponse({
    required String code,
    required String message,
    CapsuleDrawData? data,
  }) = _CapsuleDrawResponse;

  factory CapsuleDrawResponse.fromJson(Map<String, dynamic> json) =>
      _$CapsuleDrawResponseFromJson(json);
}

@freezed
abstract class CapsuleDrawData with _$CapsuleDrawData {
  const factory CapsuleDrawData({
    required int capsuleId,
    String? giftName,
    String? giftImageUrl,
    String? description,
  }) = _CapsuleDrawData;

  factory CapsuleDrawData.fromJson(Map<String, dynamic> json) =>
      _$CapsuleDrawDataFromJson(json);
}
