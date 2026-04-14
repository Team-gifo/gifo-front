// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LobbyData _$LobbyDataFromJson(Map<String, dynamic> json) => _LobbyData(
  user: json['user'] as String,
  subTitle: json['subTitle'] as String,
  bgm: json['bgm'] as String,
  gallery:
      (json['gallery'] as List<dynamic>?)
          ?.map((e) => GalleryItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <GalleryItem>[],
  content: json['content'] == null
      ? null
      : LobbyContent.fromJson(json['content'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LobbyDataToJson(_LobbyData instance) =>
    <String, dynamic>{
      'user': instance.user,
      'subTitle': instance.subTitle,
      'bgm': instance.bgm,
      'gallery': instance.gallery,
      'content': instance.content,
    };

_GalleryItem _$GalleryItemFromJson(Map<String, dynamic> json) => _GalleryItem(
  title: json['title'] as String,
  imageUrl: json['imageUrl'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$GalleryItemToJson(_GalleryItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
    };

_LobbyContent _$LobbyContentFromJson(Map<String, dynamic> json) =>
    _LobbyContent(
      gacha: json['gacha'] == null
          ? null
          : GachaContent.fromJson(json['gacha'] as Map<String, dynamic>),
      quiz: json['quiz'] == null
          ? null
          : QuizContent.fromJson(json['quiz'] as Map<String, dynamic>),
      unboxing: json['unboxing'] == null
          ? null
          : UnboxingContent.fromJson(json['unboxing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LobbyContentToJson(_LobbyContent instance) =>
    <String, dynamic>{
      'gacha': instance.gacha,
      'quiz': instance.quiz,
      'unboxing': instance.unboxing,
    };

_GachaContent _$GachaContentFromJson(Map<String, dynamic> json) =>
    _GachaContent(
      playCount: (json['playCount'] as num).toInt(),
      remainingDrawCount: (json['remainingDrawCount'] as num?)?.toInt() ?? 0,
      selected: json['selected'] as bool? ?? false,
      list:
          (json['list'] as List<dynamic>?)
              ?.map((e) => GachaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GachaItem>[],
      drawHistory:
          (json['drawHistory'] as List<dynamic>?)
              ?.map((e) => GachaDrawHistory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GachaDrawHistory>[],
    );

Map<String, dynamic> _$GachaContentToJson(_GachaContent instance) =>
    <String, dynamic>{
      'playCount': instance.playCount,
      'remainingDrawCount': instance.remainingDrawCount,
      'selected': instance.selected,
      'list': instance.list,
      'drawHistory': instance.drawHistory,
    };

_GachaItem _$GachaItemFromJson(Map<String, dynamic> json) => _GachaItem(
  itemName: json['itemName'] as String,
  imageUrl: json['imageUrl'] as String,
  percent: (json['percent'] as num).toDouble(),
  percentOpen: json['percentOpen'] as bool,
  capsuleId: (json['capsuleId'] as num?)?.toInt(),
  description: json['description'] as String?,
);

Map<String, dynamic> _$GachaItemToJson(_GachaItem instance) =>
    <String, dynamic>{
      'itemName': instance.itemName,
      'imageUrl': instance.imageUrl,
      'percent': instance.percent,
      'percentOpen': instance.percentOpen,
      'capsuleId': instance.capsuleId,
      'description': instance.description,
    };

_GachaDrawHistory _$GachaDrawHistoryFromJson(Map<String, dynamic> json) =>
    _GachaDrawHistory(
      capsuleId: (json['capsuleId'] as num).toInt(),
      giftName: json['giftName'] as String?,
      giftImageUrl: json['giftImageUrl'] as String?,
      description: json['description'] as String?,
      selected: json['selected'] as bool? ?? false,
      drawnAt: json['drawnAt'] as String?,
    );

Map<String, dynamic> _$GachaDrawHistoryToJson(_GachaDrawHistory instance) =>
    <String, dynamic>{
      'capsuleId': instance.capsuleId,
      'giftName': instance.giftName,
      'giftImageUrl': instance.giftImageUrl,
      'description': instance.description,
      'selected': instance.selected,
      'drawnAt': instance.drawnAt,
    };

_QuizContent _$QuizContentFromJson(Map<String, dynamic> json) => _QuizContent(
  currentQuizIndex: (json['currentQuizIndex'] as num?)?.toInt() ?? 0,
  remainingAttempts: (json['remainingAttempts'] as num?)?.toInt() ?? 0,
  successReward: RewardItem.fromJson(
    json['successReward'] as Map<String, dynamic>,
  ),
  failReward: RewardItem.fromJson(json['failReward'] as Map<String, dynamic>),
  list:
      (json['list'] as List<dynamic>?)
          ?.map((e) => QuizItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <QuizItem>[],
  answerHistory:
      (json['answerHistory'] as List<dynamic>?)
          ?.map((e) => QuizAnswerHistory.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <QuizAnswerHistory>[],
);

Map<String, dynamic> _$QuizContentToJson(_QuizContent instance) =>
    <String, dynamic>{
      'currentQuizIndex': instance.currentQuizIndex,
      'remainingAttempts': instance.remainingAttempts,
      'successReward': instance.successReward,
      'failReward': instance.failReward,
      'list': instance.list,
      'answerHistory': instance.answerHistory,
    };

_RewardItem _$RewardItemFromJson(Map<String, dynamic> json) => _RewardItem(
  requiredCount: (json['requiredCount'] as num?)?.toInt(),
  itemName: json['itemName'] as String,
  imageUrl: json['imageUrl'] as String,
);

Map<String, dynamic> _$RewardItemToJson(_RewardItem instance) =>
    <String, dynamic>{
      'requiredCount': instance.requiredCount,
      'itemName': instance.itemName,
      'imageUrl': instance.imageUrl,
    };

_QuizItem _$QuizItemFromJson(Map<String, dynamic> json) => _QuizItem(
  quizId: (json['quizId'] as num).toInt(),
  type: json['type'] as String,
  title: json['title'] as String,
  imageUrl: json['imageUrl'] as String? ?? '',
  description: json['description'] as String? ?? '',
  hint: json['hint'] as String? ?? '',
  options:
      (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  answer:
      (json['answer'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  playLimit: (json['playLimit'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$QuizItemToJson(_QuizItem instance) => <String, dynamic>{
  'quizId': instance.quizId,
  'type': instance.type,
  'title': instance.title,
  'imageUrl': instance.imageUrl,
  'description': instance.description,
  'hint': instance.hint,
  'options': instance.options,
  'answer': instance.answer,
  'playLimit': instance.playLimit,
};

_QuizAnswerHistory _$QuizAnswerHistoryFromJson(Map<String, dynamic> json) =>
    _QuizAnswerHistory(
      quizId: (json['quizId'] as num).toInt(),
      correct: json['correct'] as bool,
    );

Map<String, dynamic> _$QuizAnswerHistoryToJson(_QuizAnswerHistory instance) =>
    <String, dynamic>{'quizId': instance.quizId, 'correct': instance.correct};

_UnboxingContent _$UnboxingContentFromJson(Map<String, dynamic> json) =>
    _UnboxingContent(
      beforeOpen: UnboxingBefore.fromJson(
        json['beforeOpen'] as Map<String, dynamic>,
      ),
      afterOpen: UnboxingAfter.fromJson(
        json['afterOpen'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$UnboxingContentToJson(_UnboxingContent instance) =>
    <String, dynamic>{
      'beforeOpen': instance.beforeOpen,
      'afterOpen': instance.afterOpen,
    };

_UnboxingBefore _$UnboxingBeforeFromJson(Map<String, dynamic> json) =>
    _UnboxingBefore(
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$UnboxingBeforeToJson(_UnboxingBefore instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'description': instance.description,
    };

_UnboxingAfter _$UnboxingAfterFromJson(Map<String, dynamic> json) =>
    _UnboxingAfter(
      itemName: json['itemName'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$UnboxingAfterToJson(_UnboxingAfter instance) =>
    <String, dynamic>{
      'itemName': instance.itemName,
      'imageUrl': instance.imageUrl,
    };
