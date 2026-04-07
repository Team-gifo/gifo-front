import 'package:freezed_annotation/freezed_annotation.dart';

part 'lobby_data.freezed.dart';
part 'lobby_data.g.dart';

@freezed
abstract class LobbyData with _$LobbyData {
  const factory LobbyData({
    required String user,
    required String subTitle,
    required String bgm,
    @Default(<GalleryItem>[]) List<GalleryItem> gallery,
    LobbyContent? content,
  }) = _LobbyData;

  factory LobbyData.fromJson(Map<String, dynamic> json) =>
      _$LobbyDataFromJson(json);
}

@freezed
abstract class GalleryItem with _$GalleryItem {
  const factory GalleryItem({
    required String title,
    required String imageUrl,
    required String description,
  }) = _GalleryItem;

  factory GalleryItem.fromJson(Map<String, dynamic> json) =>
      _$GalleryItemFromJson(json);
}

@freezed
abstract class LobbyContent with _$LobbyContent {
  const factory LobbyContent({
    GachaContent? gacha,
    QuizContent? quiz,
    UnboxingContent? unboxing,
  }) = _LobbyContent;

  factory LobbyContent.fromJson(Map<String, dynamic> json) =>
      _$LobbyContentFromJson(json);
}

// -------------------------------------------------------
// 캡슐 뽑기 (Gacha) 관련 모델
// -------------------------------------------------------

@freezed
abstract class GachaContent with _$GachaContent {
  const factory GachaContent({
    required int playCount,
    @Default(0) int remainingDrawCount,
    @Default(false) bool selected,
    @Default(<GachaItem>[]) List<GachaItem> list,
    @Default(<GachaDrawHistory>[]) List<GachaDrawHistory> drawHistory,
  }) = _GachaContent;

  factory GachaContent.fromJson(Map<String, dynamic> json) =>
      _$GachaContentFromJson(json);
}

@freezed
abstract class GachaItem with _$GachaItem {
  const factory GachaItem({
    required String itemName,
    required String imageUrl,
    required double percent,
    required bool percentOpen,
    int? capsuleId,
    String? description,
  }) = _GachaItem;

  factory GachaItem.fromJson(Map<String, dynamic> json) =>
      _$GachaItemFromJson(json);
}

@freezed
abstract class GachaDrawHistory with _$GachaDrawHistory {
  const factory GachaDrawHistory({
    required int capsuleId,
    required String giftName,
    required String giftImageUrl,
    required String description,
    required bool selected,
  }) = _GachaDrawHistory;

  factory GachaDrawHistory.fromJson(Map<String, dynamic> json) =>
      _$GachaDrawHistoryFromJson(json);
}

// -------------------------------------------------------
// 퀴즈 (Quiz) 관련 모델
// -------------------------------------------------------

@freezed
abstract class QuizContent with _$QuizContent {
  const factory QuizContent({
    @Default(0) int currentQuizIndex,
    @Default(0) int remainingAttempts,
    required RewardItem successReward,
    required RewardItem failReward,
    @Default(<QuizItem>[]) List<QuizItem> list,
    @Default(<QuizAnswerHistory>[]) List<QuizAnswerHistory> answerHistory,
  }) = _QuizContent;

  factory QuizContent.fromJson(Map<String, dynamic> json) =>
      _$QuizContentFromJson(json);
}

@freezed
abstract class RewardItem with _$RewardItem {
  const factory RewardItem({
    int? requiredCount,
    required String itemName,
    required String imageUrl,
  }) = _RewardItem;

  factory RewardItem.fromJson(Map<String, dynamic> json) =>
      _$RewardItemFromJson(json);
}

@freezed
abstract class QuizItem with _$QuizItem {
  const factory QuizItem({
    required int quizId,
    required String type,
    required String title,
    @Default('') String imageUrl,
    @Default('') String description,
    @Default('') String hint,
    @Default(<String>[]) List<String> options,
    // 정답 목록 (채점 시 대소문자 무관 비교)
    @Default(<String>[]) List<String> answer,
    @Default(1) int playLimit,
  }) = _QuizItem;

  factory QuizItem.fromJson(Map<String, dynamic> json) =>
      _$QuizItemFromJson(json);
}

@freezed
abstract class QuizAnswerHistory with _$QuizAnswerHistory {
  const factory QuizAnswerHistory({
    required int quizId,
    required bool correct,
  }) = _QuizAnswerHistory;

  factory QuizAnswerHistory.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerHistoryFromJson(json);
}

// -------------------------------------------------------
// 바로 오픈 (Unboxing) 관련 모델
// -------------------------------------------------------

@freezed
abstract class UnboxingContent with _$UnboxingContent {
  const factory UnboxingContent({
    required UnboxingBefore beforeOpen,
    required UnboxingAfter afterOpen,
  }) = _UnboxingContent;

  factory UnboxingContent.fromJson(Map<String, dynamic> json) =>
      _$UnboxingContentFromJson(json);
}

@freezed
abstract class UnboxingBefore with _$UnboxingBefore {
  const factory UnboxingBefore({
    required String imageUrl,
    required String description,
  }) = _UnboxingBefore;

  factory UnboxingBefore.fromJson(Map<String, dynamic> json) =>
      _$UnboxingBeforeFromJson(json);
}

@freezed
abstract class UnboxingAfter with _$UnboxingAfter {
  const factory UnboxingAfter({
    required String itemName,
    required String imageUrl,
  }) = _UnboxingAfter;

  factory UnboxingAfter.fromJson(Map<String, dynamic> json) =>
      _$UnboxingAfterFromJson(json);
}
