// 캡슐 뽑기 콘텐츠 모델 (content 영역 전용)
class ContentGachaContent {
  final int playCount;
  final List<ContentGachaItem> list;

  ContentGachaContent({required this.playCount, required this.list});
}

class ContentGachaItem {
  final String itemName;
  final String imageUrl;
  final double percent;
  final bool percentOpen;

  ContentGachaItem({
    required this.itemName,
    required this.imageUrl,
    required this.percent,
    required this.percentOpen,
  });
}
