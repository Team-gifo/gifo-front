// 바로 오픈(언박싱) 콘텐츠 모델 (content 영역 전용)
class ContentUnboxingContent {
  final ContentBeforeOpen beforeOpen;
  final ContentAfterOpen afterOpen;

  ContentUnboxingContent({required this.beforeOpen, required this.afterOpen});
}

class ContentBeforeOpen {
  final String imageUrl;
  final String description;

  ContentBeforeOpen({required this.imageUrl, required this.description});
}

class ContentAfterOpen {
  final String itemName;
  final String imageUrl;

  ContentAfterOpen({required this.itemName, required this.imageUrl});
}
