part of 'quiz_setting_bloc.dart';

class QuizSettingState {
  final List<QuizItemData> uiItems;
  final QuizRewardData successReward;
  final QuizRewardData failReward;
  final String selectedBgm;

  QuizSettingState({
    List<QuizItemData>? uiItems,
    QuizRewardData? successReward,
    QuizRewardData? failReward,
    this.selectedBgm = '',
  })  : uiItems = uiItems ?? <QuizItemData>[],
        successReward = successReward ?? QuizRewardData(requiredCount: 1),
        failReward = failReward ?? QuizRewardData();

  // 현재 등록된 이미지 수 (질문 이미지 + 성공/실패 보상 이미지)
  int get imageCount {
    final int itemImages =
        uiItems.where((QuizItemData item) => item.imageFile != null).length;
    final int successImage = successReward.imageFile != null ? 1 : 0;
    final int failImage = failReward.imageFile != null ? 1 : 0;
    return itemImages + successImage + failImage;
  }

  QuizSettingState copyWith({
    List<QuizItemData>? uiItems,
    QuizRewardData? successReward,
    QuizRewardData? failReward,
    String? selectedBgm,
  }) {
    return QuizSettingState(
      uiItems: uiItems ?? this.uiItems,
      successReward: successReward ?? this.successReward,
      failReward: failReward ?? this.failReward,
      selectedBgm: selectedBgm ?? this.selectedBgm,
    );
  }
}
