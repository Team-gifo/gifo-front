class LobbyData {
  final String user;
  final String subTitle;
  final String bgm;
  final List<GalleryItem> gallery;
  final LobbyContent? content;

  LobbyData({
    required this.user,
    required this.subTitle,
    required this.bgm,
    required this.gallery,
    this.content,
  });

  /// 임시 테스트용 더미 데이터를 반환하는 팩토리 메서드
  factory LobbyData.dummy() {
    return LobbyData(
      user: '박준영',
      subTitle: '우리의 특별한 기록',
      bgm: 'track_sweet_01',
      gallery: <GalleryItem>[], // 추억 갤러리 정보는 일단 없는 것으로 처리
      content: LobbyContent.dummy(),
    );
  }
}

class GalleryItem {
  final String title;
  final String imageUrl;
  final String description;

  GalleryItem({
    required this.title,
    required this.imageUrl,
    required this.description,
  });
}

class LobbyContent {
  final GachaContent? gacha;
  final QuizContent? quiz;
  final UnboxingContent? unboxing;

  LobbyContent({this.gacha, this.quiz, this.unboxing});

  factory LobbyContent.dummy() {
    return LobbyContent(
      gacha: GachaContent(
        playCount: 3,
        list: <GachaItem>[
          GachaItem(
            itemName: '닌텐도 스위치2',
            imageUrl: 'https://example.com/images/switch.png',
            percent: 0.001,
            percentOpen: false,
          ),
        ],
      ),
      quiz: QuizContent(
        successReward: RewardItem(
          requiredCount: 3,
          itemName: '특급 한우 세트',
          imageUrl: 'https://example.com/images/beef.png',
        ),
        failReward: RewardItem(
          itemName: '비타500',
          imageUrl: 'https://example.com/images/vita500.png',
        ),
        list: <QuizItem>[
          QuizItem(
            quizId: 1,
            type: 'multiple_choice',
            title: '내가 제일 좋아하는 음식은?',
            imageUrl: 'https://example.com/images/food.png',
            description: '힌트: 매콤한 소스가 특징입니다.',
            hint: '어제 저녁에도 먹었어요!',
            options: <String>['치킨', '마라탕', '초밥', '삼겹살', '파스타'],
            answer: <String>['마라탕'],
            playLimit: 2,
          ),
          QuizItem(
            quizId: 2,
            type: 'subjective',
            title: '우리가 처음 만난 장소는?',
            imageUrl: 'https://example.com/images/first_meet.png',
            description: '기억나시나요? 그날 비가 왔었죠.',
            hint: '강남역 근처의 유명한 카페 브랜드입니다.',
            options: <String>[],
            answer: <String>['스타벅스', 'Starbucks', '스벅'],
            playLimit: 3,
          ),
          QuizItem(
            quizId: 3,
            type: 'ox',
            title: '나는 아침형 인간이다.',
            imageUrl: 'https://example.com/images/morning.png',
            description: '진실 혹은 거짓!',
            hint: '새벽까지 게임하는 걸 좋아해요.',
            options: <String>[],
            answer: <String>['X'],
            playLimit: 1,
          ),
        ],
      ),
      unboxing: UnboxingContent(
        beforeOpen: UnboxingBefore(
          imageUrl: 'https://example.com/images/gift_box.png',
          description: '상자 안에 무엇이 들어있을까요? 클릭해서 확인해보세요!',
        ),
        afterOpen: UnboxingAfter(
          itemName: '아이패드 프로 M4',
          imageUrl: 'https://example.com/images/ipad.png',
        ),
      ),
    );
  }
}

class GachaContent {
  final int playCount;
  final List<GachaItem> list;

  GachaContent({required this.playCount, required this.list});
}

class GachaItem {
  final String itemName;
  final String imageUrl;
  final double percent;
  final bool percentOpen;

  GachaItem({
    required this.itemName,
    required this.imageUrl,
    required this.percent,
    required this.percentOpen,
  });
}

class QuizContent {
  final RewardItem successReward;
  final RewardItem failReward;
  final List<QuizItem> list;

  QuizContent({
    required this.successReward,
    required this.failReward,
    required this.list,
  });
}

class RewardItem {
  final int? requiredCount;
  final String itemName;
  final String imageUrl;

  RewardItem({
    this.requiredCount,
    required this.itemName,
    required this.imageUrl,
  });
}

class QuizItem {
  final int quizId;
  final String type;
  final String title;
  final String imageUrl;
  final String description;
  final String hint;
  final List<String> options;
  final List<String> answer;
  final int playLimit;

  QuizItem({
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

class UnboxingContent {
  final UnboxingBefore beforeOpen;
  final UnboxingAfter afterOpen;

  UnboxingContent({required this.beforeOpen, required this.afterOpen});
}

class UnboxingBefore {
  final String imageUrl;
  final String description;

  UnboxingBefore({required this.imageUrl, required this.description});
}

class UnboxingAfter {
  final String itemName;
  final String imageUrl;

  UnboxingAfter({required this.itemName, required this.imageUrl});
}
