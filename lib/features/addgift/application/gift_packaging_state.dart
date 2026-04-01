part of 'gift_packaging_bloc.dart';

// ---- BLoC 상태 정의 ----

// 서버 전송 단계를 명확히 구분
enum SubmitStatus { idle, loading, success, failure }

class GiftPackagingState {
  final GiftMode mode;
  final String receiverName;
  final String subTitle;
  final String bgm;
  final List<GalleryItem> gallery;
  final ContentType? selectedContentType;
  final GachaContent? gachaContent;
  final QuizContent? quizContent;
  final UnboxingContent? unboxingContent;
  final SubmitStatus submitStatus;
  final String shareCode;
  final String shareUrl;

  // 랜덤한 서브타이틀 명칭 생성 헬퍼
  static String generateRandomSubTitle() {
    final List<String> randomTitles = <String>[
      '두근두근',
      '설레는',
      '호기심 가득',
      '신나는',
      '떨리는',
      '화끈한',
      '행복한',
      '기대되는',
      '깜짝',
      '환상적인',
    ];
    final Random random = Random();
    return randomTitles[random.nextInt(randomTitles.length)];
  }

  factory GiftPackagingState.initial() {
    return GiftPackagingState(subTitle: generateRandomSubTitle());
  }

  const GiftPackagingState({
    this.mode = GiftMode.manual,
    this.receiverName = '',
    this.subTitle = '',
    this.bgm = '',
    this.gallery = const <GalleryItem>[],
    this.selectedContentType,
    this.gachaContent,
    this.quizContent,
    this.unboxingContent,
    this.submitStatus = SubmitStatus.idle,
    this.shareCode = '',
    this.shareUrl = '',
  });

  GiftPackagingState copyWith({
    GiftMode? mode,
    String? receiverName,
    String? subTitle,
    String? bgm,
    List<GalleryItem>? gallery,
    ContentType? selectedContentType,
    GachaContent? gachaContent,
    QuizContent? quizContent,
    UnboxingContent? unboxingContent,
    SubmitStatus? submitStatus,
    String? shareCode,
    String? shareUrl,
  }) {
    return GiftPackagingState(
      mode: mode ?? this.mode,
      receiverName: receiverName ?? this.receiverName,
      subTitle: subTitle ?? this.subTitle,
      bgm: bgm ?? this.bgm,
      gallery: gallery ?? this.gallery,
      selectedContentType: selectedContentType ?? this.selectedContentType,
      gachaContent: gachaContent ?? this.gachaContent,
      quizContent: quizContent ?? this.quizContent,
      unboxingContent: unboxingContent ?? this.unboxingContent,
      submitStatus: submitStatus ?? this.submitStatus,
      shareCode: shareCode ?? this.shareCode,
      shareUrl: shareUrl ?? this.shareUrl,
    );
  }
}
