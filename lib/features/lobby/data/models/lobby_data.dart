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

  /// 전달받은 코드를 기준으로 3가지 콘텐츠 유형의 더미 데이터를 반환합니다
  static LobbyData? getDummyByCode(String code) {
    if (code == 'helloworld') {
      return LobbyData(
        user: '박준영', // 캡슐 뽑기 테스트 유저
        subTitle: '우리의 특별한 기록 (캡슐 뽑기)',
        bgm: 'track_sweet_01',
        gallery: <GalleryItem>[
          GalleryItem(
            title: '우리의 첫 만남',
            imageUrl: 'assets/images/gallery_1.jpeg',
            description: '벌써 시간이 이렇게 흘렀네. 함께했던 즐거운 시간들!',
          ),
          GalleryItem(
            title: '잊지 못할 추억',
            imageUrl: 'assets/images/gallery_2.jpeg',
            description: '앞으로도 더 많은 추억을 함께 만들어가자. 항상 고마워.',
          ),
        ],
        content: LobbyContent(gacha: _getDummyGacha()),
      );
    } else if (code == 'quiz123') {
      return LobbyData(
        user: '김철수', // 퀴즈 맞추기 테스트 유저
        subTitle: '문제를 풀고 선물을 확인해봐!',
        bgm: 'track_sweet_02',
        gallery: <GalleryItem>[],
        content: LobbyContent(quiz: _getDummyQuiz()),
      );
    } else if (code == 'open123') {
      return LobbyData(
        user: '이영희', // 바로 오픈 테스트 유저
        subTitle: '너를 위해 준비한 선물이야',
        bgm: 'track_sweet_03',
        gallery: <GalleryItem>[],
        content: LobbyContent(unboxing: _getDummyUnboxing()),
      );
    }
    return null; // 없는 코드일 경우
  }

  // 1. 캡슐 뽑기 더미 데이터
  static GachaContent _getDummyGacha() {
    return GachaContent(
      playCount: 3,
      list: <GachaItem>[
        GachaItem(
          itemName: '닌텐도 스위치2',
          imageUrl: 'assets/images/item/nitendo.jpg',
          percent: 0.001,
          percentOpen: false,
        ),
      ],
    );
  }

  // 2. 문제 맞추기 더미 데이터
  static QuizContent _getDummyQuiz() {
    return QuizContent(
      successReward: RewardItem(
        requiredCount: 3,
        itemName: '특급 한우 세트',
        imageUrl: 'assets/images/item/cow.jpg',
      ),
      failReward: RewardItem(
        itemName: '비타500',
        imageUrl: 'assets/images/item/500.jpg',
      ),
      list: <QuizItem>[
        QuizItem(
          quizId: 1,
          type: 'multiple_choice',
          title: '내가 제일 좋아하는 음식은?',
          imageUrl: 'assets/images/item/sample.png',
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
          imageUrl: 'assets/images/item/sample.png',
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
          imageUrl: 'assets/images/item/sample.png',
          description: '진실 혹은 거짓!',
          hint: '새벽까지 게임하는 걸 좋아해요.',
          options: <String>[],
          answer: <String>['X'],
          playLimit: 1,
        ),
      ],
    );
  }

  // 3. 바로 오픈 더미 데이터
  static UnboxingContent _getDummyUnboxing() {
    return UnboxingContent(
      beforeOpen: UnboxingBefore(
        imageUrl: 'assets/images/item/open_before.png',
        description: '상자 안에 무엇이 들어있을까요? 클릭해서 확인해보세요!',
      ),
      afterOpen: UnboxingAfter(
        itemName: '아이패드 프로 M4',
        imageUrl: 'assets/images/item/ipad.avif',
      ),
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

  // Deprecated dummy factory removed. Data is provided through getDummyByCode.
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
