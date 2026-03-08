// 퀴즈 콘텐츠 모델 (content 영역 전용)
class ContentQuizContent {
  final ContentRewardItem successReward;
  final ContentRewardItem failReward;
  final List<ContentQuizItem> list;

  ContentQuizContent({
    required this.successReward,
    required this.failReward,
    required this.list,
  });
}

class ContentRewardItem {
  final int? requiredCount;
  final String itemName;
  final String imageUrl;

  ContentRewardItem({
    this.requiredCount,
    required this.itemName,
    required this.imageUrl,
  });
}

class ContentQuizItem {
  final int quizId;
  final String type;
  final String title;
  final String imageUrl;
  final String description;
  final String hint;
  final List<String> options;
  final List<String> answer;
  final int playLimit;

  ContentQuizItem({
    required this.quizId,
    required this.type,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.hint,
    required this.options,
    required this.answer,
    required this.playLimit,
  });
}
