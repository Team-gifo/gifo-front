import 'package:freezed_annotation/freezed_annotation.dart';

part 'gacha_content.freezed.dart';
part 'gacha_content.g.dart';

// ---- 캡슐 뽑기 콘텐츠 ----

@freezed
abstract class GachaContent with _$GachaContent {
  const factory GachaContent({
    @JsonKey(name: 'play_count') @Default(3) int playCount,
    @Default([]) List<GachaItem> list,
  }) = _GachaContent;

  factory GachaContent.fromJson(Map<String, dynamic> json) =>
      _$GachaContentFromJson(json);
}

@freezed
abstract class GachaItem with _$GachaItem {
  const factory GachaItem({
    @JsonKey(name: 'item_name') @Default('') String itemName,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @Default(0.0) double percent,
    @JsonKey(name: 'percent_open') @Default(false) bool percentOpen,
  }) = _GachaItem;

  factory GachaItem.fromJson(Map<String, dynamic> json) =>
      _$GachaItemFromJson(json);
}
