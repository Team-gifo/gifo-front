part of 'gift_packaging_bloc.dart';

// ---- BLoC 상태 정의 ----

class GiftPackagingState {
  final String receiverName;
  final String subTitle;
  final String bgm;
  final List<GalleryItem> gallery;
  final ContentType? selectedContentType;
  final GachaContent? gachaContent;
  final QuizContent? quizContent;
  final UnboxingContent? unboxingContent;

  const GiftPackagingState({
    this.receiverName = '',
    this.subTitle = '',
    this.bgm = '',
    this.gallery = const [],
    this.selectedContentType,
    this.gachaContent,
    this.quizContent,
    this.unboxingContent,
  });

  GiftPackagingState copyWith({
    String? receiverName,
    String? subTitle,
    String? bgm,
    List<GalleryItem>? gallery,
    ContentType? selectedContentType,
    GachaContent? gachaContent,
    QuizContent? quizContent,
    UnboxingContent? unboxingContent,
  }) {
    return GiftPackagingState(
      receiverName: receiverName ?? this.receiverName,
      subTitle: subTitle ?? this.subTitle,
      bgm: bgm ?? this.bgm,
      gallery: gallery ?? this.gallery,
      selectedContentType: selectedContentType ?? this.selectedContentType,
      gachaContent: gachaContent ?? this.gachaContent,
      quizContent: quizContent ?? this.quizContent,
      unboxingContent: unboxingContent ?? this.unboxingContent,
    );
  }
}
