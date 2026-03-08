import 'content_gallery_item.dart';
import 'content_wrapper.dart';

// 서버에서 받아온 콘텐츠 데이터 전체를 담는 최상위 모델 (content 영역 전용)
class ContentData {
  final String user;
  final String subTitle;
  final String bgm;
  final List<ContentGalleryItem> gallery;
  final ContentWrapper? content;

  ContentData({
    required this.user,
    required this.subTitle,
    required this.bgm,
    required this.gallery,
    this.content,
  });
}
