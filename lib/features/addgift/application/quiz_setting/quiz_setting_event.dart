part of 'quiz_setting_bloc.dart';

sealed class QuizSettingEvent {}

class InitQuizSetting extends QuizSettingEvent {
  final String initialBgm;
  InitQuizSetting({this.initialBgm = '신나는 생일'});
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
