import 'package:freezed_annotation/freezed_annotation.dart';

part 'gallery_item.freezed.dart';
part 'gallery_item.g.dart';

@freezed
abstract class GalleryItem with _$GalleryItem {
  const factory GalleryItem({
    @Default('') String title,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @Default('') String description,
  }) = _GalleryItem;

  factory GalleryItem.fromJson(Map<String, dynamic> json) =>
      _$GalleryItemFromJson(json);
}
