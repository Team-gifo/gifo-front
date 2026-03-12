import 'gacha/gacha_content_model.dart';
import 'quiz/quiz_content_model.dart';
import 'unboxing/unboxing_content_model.dart';

// 3가지 콘텐츠 타입을 감싸는 래퍼 클래스 (content 영역 전용)
class ContentWrapper {
  final ContentGachaContent? gacha;
  final ContentQuizContent? quiz;
  final ContentUnboxingContent? unboxing;

  ContentWrapper({this.gacha, this.quiz, this.unboxing});
}
