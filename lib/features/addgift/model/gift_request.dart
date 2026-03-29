import 'package:freezed_annotation/freezed_annotation.dart';

import 'gallery_item.dart';
import 'gift_content.dart';

part 'gift_request.freezed.dart';
part 'gift_request.g.dart';

// 서버에 전송할 최상위 요청 모델
@freezed
abstract class GiftRequest with _$GiftRequest {
  const factory GiftRequest({
    @Default('') String user,
    @JsonKey(name: 'sub_title') @Default('') String subTitle,
    @Default('') String bgm,
    @Default('') String password,
    @JsonKey(name: 'sender_name') @Default('') String senderName,
    @Default(<GalleryItem>[]) List<GalleryItem> gallery,
    @JsonKey(name: 'uploaded_bgm_urls') @Default(<String>[]) List<String> uploadedBgmUrls,
    @JsonKey(name: 'expired_at', includeIfNull: false) String? expiredAt,
    required GiftContent content,
  }) = _GiftRequest;

  factory GiftRequest.fromJson(Map<String, dynamic> json) =>
      _$GiftRequestFromJson(json);
}
