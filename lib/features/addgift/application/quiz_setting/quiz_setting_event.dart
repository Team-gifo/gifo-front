part of 'quiz_setting_bloc.dart';

sealed class QuizSettingEvent {}

class InitQuizSetting extends QuizSettingEvent {
  final String initialBgm;
  final List<QuizItemData>? uiItems;
  final QuizRewardData? successReward;
  final QuizRewardData? failReward;

  InitQuizSetting({
    this.initialBgm = '',
    this.uiItems,
    this.successReward,
    this.failReward,
  });
}

class UpdateQuizItems extends QuizSettingEvent {
  final List<QuizItemData> items;
  UpdateQuizItems(this.items);
}

class UpdateSuccessReward extends QuizSettingEvent {
  final QuizRewardData reward;
  UpdateSuccessReward(this.reward);
}

class UpdateFailReward extends QuizSettingEvent {
  final QuizRewardData reward;
  UpdateFailReward(this.reward);
}

class UpdateQuizBgm extends QuizSettingEvent {
  final String bgm;
  UpdateQuizBgm(this.bgm);
}

class SubmitQuizSetting extends QuizSettingEvent {
  final String receiverName;
  final String subTitle;
  final List<GalleryItem> gallery;

  SubmitQuizSetting({
    required this.receiverName,
    required this.subTitle,
    required this.gallery,
  });
}
