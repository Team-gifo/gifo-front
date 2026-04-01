import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/gallery_item.dart';
import '../../model/gift_content.dart';
import '../../model/quiz_content.dart';
import '../../model/quiz_setting_models.dart';
import '../gift_packaging_bloc.dart';

part 'quiz_setting_event.dart';
part 'quiz_setting_state.dart';

class QuizSettingBloc extends Bloc<QuizSettingEvent, QuizSettingState> {
  final GiftPackagingBloc _packagingBloc;

  QuizSettingBloc(this._packagingBloc) : super(QuizSettingState()) {
    on<InitQuizSetting>(_onInit);
    on<UpdateQuizItems>(_onUpdateItems);
    on<UpdateSuccessReward>(_onUpdateSuccessReward);
    on<UpdateFailReward>(_onUpdateFailReward);
    on<UpdateQuizBgm>(_onUpdateBgm);
    on<SubmitQuizSetting>(_onSubmit);
  }

  // uiItems -> QuizContent 변환 후 GiftPackagingBloc에 동기화
  void _pushToPackagingBloc(QuizSettingState s) {
    final QuizContent content = _buildQuizContent(s);
    _packagingBloc.add(SetQuizContent(content));
  }

  QuizContent _buildQuizContent(QuizSettingState s) {
    final List<QuizItemModel> quizItems = s.uiItems
        .asMap()
        .entries
        .map((MapEntry<int, QuizItemData> e) {
          final QuizItemData item = e.value;
          String typeStr;
          switch (item.type) {
            case QuizType.multipleChoice:
              typeStr = 'multiple_choice';
            case QuizType.ox:
              typeStr = 'ox';
            case QuizType.subjective:
              typeStr = 'subjective';
          }
          List<String> answerTexts = item.answer;
          if (item.type == QuizType.multipleChoice) {
            answerTexts = item.answer.map((String idxStr) {
              final int? idx = int.tryParse(idxStr);
              if (idx != null && idx < item.options.length) {
                return item.options[idx];
              }
              return idxStr;
            }).toList();
          }
          return QuizItemModel(
            quizId: e.key + 1,
            type: typeStr,
            title: item.title,
            imageUrl: item.imageFile?.path,
            description: item.description.isEmpty ? null : item.description,
            hint: item.hint.isEmpty ? null : item.hint,
            options: item.options,
            answer: answerTexts,
            playLimit: item.playLimit,
          );
        })
        .toList();

    return QuizContent(
      successReward: QuizSuccessReward(
        requiredCount: s.successReward.requiredCount ?? 1,
        itemName: s.successReward.itemName,
        imageUrl: s.successReward.imageFile?.path ?? '',
      ),
      failReward: QuizFailReward(
        itemName: s.failReward.itemName,
        imageUrl: s.failReward.imageFile?.path ?? '',
      ),
      list: quizItems,
    );
  }

  void _onInit(InitQuizSetting event, Emitter<QuizSettingState> emit) {
    emit(state.copyWith(selectedBgm: event.initialBgm));
  }

  void _onUpdateItems(UpdateQuizItems event, Emitter<QuizSettingState> emit) {
    emit(state.copyWith(uiItems: event.items));
    _pushToPackagingBloc(state.copyWith(uiItems: event.items));
  }

  void _onUpdateSuccessReward(
    UpdateSuccessReward event,
    Emitter<QuizSettingState> emit,
  ) {
    emit(state.copyWith(successReward: event.reward));
    _pushToPackagingBloc(state.copyWith(successReward: event.reward));
  }

  void _onUpdateFailReward(
    UpdateFailReward event,
    Emitter<QuizSettingState> emit,
  ) {
    emit(state.copyWith(failReward: event.reward));
    _pushToPackagingBloc(state.copyWith(failReward: event.reward));
  }

  void _onUpdateBgm(UpdateQuizBgm event, Emitter<QuizSettingState> emit) {
    emit(state.copyWith(selectedBgm: event.bgm));
  }

  void _onSubmit(SubmitQuizSetting event, Emitter<QuizSettingState> emit) {
    final QuizContent quizContent = _buildQuizContent(state);
    _packagingBloc.add(SetQuizContent(quizContent));
    _packagingBloc.add(
      SubmitPackage(
        receiverName: event.receiverName,
        subTitle: event.subTitle,
        bgm: state.selectedBgm,
        gallery: event.gallery,
        content: GiftContent(quiz: quizContent),
      ),
    );
  }
}
