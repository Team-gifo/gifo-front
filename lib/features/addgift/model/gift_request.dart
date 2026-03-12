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
    @Default([]) List<GalleryItem> gallery,
    required GiftContent content,
  }) = _GiftRequest;

  factory GiftRequest.fromJson(Map<String, dynamic> json) =>
      _$GiftRequestFromJson(json);
}
