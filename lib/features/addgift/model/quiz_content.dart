import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_content.freezed.dart';
part 'quiz_content.g.dart';

// ---- 퀴즈 맞추기 콘텐츠 ----

@freezed
abstract class QuizContent with _$QuizContent {
  const factory QuizContent({
    @JsonKey(name: 'success_reward') required QuizSuccessReward successReward,
    @JsonKey(name: 'fail_reward') required QuizFailReward failReward,
    @Default(<dynamic>[]) List<QuizItemModel> list,
  }) = _QuizContent;

  factory QuizContent.fromJson(Map<String, dynamic> json) =>
      _$QuizContentFromJson(json);
}

// 성공 보상: 정답 수 기준 충족 시 제공
@freezed
abstract class QuizSuccessReward with _$QuizSuccessReward {
  const factory QuizSuccessReward({
    @JsonKey(name: 'required_count') @Default(1) int requiredCount,
    @JsonKey(name: 'item_name') @Default('') String itemName,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
  }) = _QuizSuccessReward;

  factory QuizSuccessReward.fromJson(Map<String, dynamic> json) =>
      _$QuizSuccessRewardFromJson(json);
}

// 실패 보상
@freezed
abstract class QuizFailReward with _$QuizFailReward {
  const factory QuizFailReward({
    @JsonKey(name: 'item_name') @Default('') String itemName,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
  }) = _QuizFailReward;

  factory QuizFailReward.fromJson(Map<String, dynamic> json) =>
      _$QuizFailRewardFromJson(json);
}

// 개별 퀴즈 문제
@freezed
abstract class QuizItemModel with _$QuizItemModel {
  const factory QuizItemModel({
    @JsonKey(name: 'quiz_id') @Default(0) int quizId,
    @Default('multiple_choice') String type,
    @Default('') String title,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? description,
    String? hint,
    @Default(<dynamic>[]) List<String> options,
    @Default(<dynamic>[]) List<String> answer,
    @JsonKey(name: 'play_limit') @Default(1) int playLimit,
  }) = _QuizItemModel;

  factory QuizItemModel.fromJson(Map<String, dynamic> json) =>
      _$QuizItemModelFromJson(json);
}
