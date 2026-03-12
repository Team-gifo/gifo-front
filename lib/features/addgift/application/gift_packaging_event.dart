part of 'gift_packaging_bloc.dart';

// 선물 포장에 사용될 콘텐츠 타입
enum ContentType { gacha, quiz, unboxing }

// ---- BLoC 이벤트 정의 ----

sealed class GiftPackagingEvent {}

// 1단계: 수신자 이름 설정
class SetReceiverName extends GiftPackagingEvent {
  final String name;
  SetReceiverName(this.name);
}

// 2단계: 추억 갤러리 설정
class SetGalleryItems extends GiftPackagingEvent {
  final List<GalleryItem> items;
  SetGalleryItems(this.items);
}

// 3단계: 서브 타이틀 설정
class SetSubTitle extends GiftPackagingEvent {
  final String subTitle;
  SetSubTitle(this.subTitle);
}

// 3단계: BGM 설정
class SetBgm extends GiftPackagingEvent {
  final String bgm;
  SetBgm(this.bgm);
}

// 3단계: 콘텐츠 타입 선택
class SetContentType extends GiftPackagingEvent {
  final ContentType type;
  SetContentType(this.type);
}

// 캡슐 뽑기 콘텐츠 데이터 설정
class SetGachaContent extends GiftPackagingEvent {
  final GachaContent gacha;
  SetGachaContent(this.gacha);
}

// 퀴즈 맞추기 콘텐츠 데이터 설정
class SetQuizContent extends GiftPackagingEvent {
  final QuizContent quiz;
  SetQuizContent(this.quiz);
}

// 바로 오픈 콘텐츠 데이터 설정
class SetUnboxingContent extends GiftPackagingEvent {
  final UnboxingContent unboxing;
  SetUnboxingContent(this.unboxing);
}

// 포장 완료: 뷰에서 조립한 최종 데이터를 이벤트에 직접 담아 전달 (BLoC state 의존 제거)
class SubmitPackage extends GiftPackagingEvent {
  final String receiverName;
  final String subTitle;
  final String bgm;
  final List<GalleryItem> gallery;
  final GiftContent content;

  SubmitPackage({
    required this.receiverName,
    required this.subTitle,
    required this.bgm,
    required this.gallery,
    required this.content,
  });
}

// 전체 상태 초기화
class ResetPackaging extends GiftPackagingEvent {}
