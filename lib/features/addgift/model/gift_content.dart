import 'package:freezed_annotation/freezed_annotation.dart';

import 'gacha_content.dart';
import 'quiz_content.dart';
import 'unboxing_content.dart';

part 'gift_content.freezed.dart';
part 'gift_content.g.dart';

// 3가지 콘텐츠(캡슐 뽑기, 퀴즈, 바로 오픈)를 통합하는 모델
// 실제 전송 시 선택된 콘텐츠만 non-null
@freezed
abstract class GiftContent with _$GiftContent {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory GiftContent({
    GachaContent? gacha,
    QuizContent? quiz,
    UnboxingContent? unboxing,
  }) = _GiftContent;

  factory GiftContent.fromJson(Map<String, dynamic> json) =>
      _$GiftContentFromJson(json);
}
