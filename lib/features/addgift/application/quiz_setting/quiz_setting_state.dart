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
    this.selectedBgm = '신나는 생일',
  })  : uiItems = uiItems ?? <QuizItemData>[],
        successReward = successReward ?? QuizRewardData(requiredCount: 1),
        failReward = failReward ?? QuizRewardData();

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
