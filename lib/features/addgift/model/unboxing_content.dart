import 'package:freezed_annotation/freezed_annotation.dart';

part 'unboxing_content.freezed.dart';
part 'unboxing_content.g.dart';

// ---- 바로 오픈 콘텐츠 ----

@freezed
abstract class UnboxingContent with _$UnboxingContent {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory UnboxingContent({
    @JsonKey(name: 'before_open') required BeforeOpen beforeOpen,
    @JsonKey(name: 'after_open') required AfterOpen afterOpen,
  }) = _UnboxingContent;

  factory UnboxingContent.fromJson(Map<String, dynamic> json) =>
      _$UnboxingContentFromJson(json);
}

// 개봉 전 화면 데이터
@freezed
abstract class BeforeOpen with _$BeforeOpen {
  const factory BeforeOpen({
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @Default('') String description,
  }) = _BeforeOpen;

  factory BeforeOpen.fromJson(Map<String, dynamic> json) =>
      _$BeforeOpenFromJson(json);
}

// 개봉 후 화면 데이터
@freezed
abstract class AfterOpen with _$AfterOpen {
  const factory AfterOpen({
    @JsonKey(name: 'item_name') @Default('') String itemName,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
  }) = _AfterOpen;

  factory AfterOpen.fromJson(Map<String, dynamic> json) =>
      _$AfterOpenFromJson(json);
}
