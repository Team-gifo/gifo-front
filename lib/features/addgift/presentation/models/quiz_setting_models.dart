import 'package:image_picker/image_picker.dart';

enum QuizType {
  multipleChoice, // 객관식
  subjective, // 주관식
  ox, // OX
}

class QuizItemData {
  String id;
  QuizType type;
  String title;
  String? imageUrl;
  XFile? imageFile;
  String description;
  String hint;
  List<String> options; // 객관식용 선택지
  List<String> answer; // 정답 혹은 주관식 복수정답들
  int playLimit;

  QuizItemData({
    required this.id,
    required this.type,
    this.title = '',
    this.imageUrl,
    this.imageFile,
    this.description = '',
    this.hint = '',
    this.options = const <String>[],
    this.answer = const <String>[],
    this.playLimit = 1,
  });

  /// 퀴즈 타입 한글명 반환
  String get typeName {
    switch (type) {
      case QuizType.multipleChoice:
        return '객관식';
      case QuizType.subjective:
        return '주관식';
      case QuizType.ox:
        return 'OX';
    }
  }
}

class QuizRewardData {
  int? requiredCount;
  String itemName;
  String? imageUrl;
  XFile? imageFile;

  QuizRewardData({
    this.requiredCount,
    this.itemName = '',
    this.imageUrl,
    this.imageFile,
  });
}
