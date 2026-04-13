# 선물 포장 전체 데이터 플로우

> 이 문서의 목적: 발신자가 선물을 포장하고 서버에 전송하기까지 전체 데이터 흐름을 단계별로 이해한다.

## 전체 흐름 다이어그램

```
[Step 1] ReceiverNameView
  UI: TextField (받는 분 성함)
  이벤트: GiftPackagingBloc.add(SetReceiverName(name))
  상태: state.receiverName = name

[Step 2] MemoryDecisionView
  UI: 추억 공유 여부 선택 (예/아니오)
  → "예" → /addgift/memory-gallery
  → "아니오" → /addgift/delivery-method

[Step 3] MemoryGallerySettingView
  BLoC: MemoryGallerySettingBloc(packagingBloc)
  UI: 이미지/제목/설명 추가, 드래그 재정렬
  이벤트: AddMemoryItem → image 선택 → UpdateMemoryItemImage
  동기화: _pushToPackagingBloc() → GiftPackagingBloc.add(SetGalleryItems(items))
  상태: state.gallery = [GalleryItem, ...]

[Step 4] GiftDeliveryMethodView
  UI: 가챠 / 퀴즈 / 바로 오픈 선택
  이벤트: GiftPackagingBloc.add(SetContentType(ContentType.gacha))
  상태: state.selectedContentType = ContentType.gacha

[Step 5a] GachaSettingView
  BLoC: GachaSettingBloc(packagingBloc)
  UI: 아이템 추가/삭제, 이미지/이름/확률 설정, 뽑기 횟수 설정
  동기화: _pushToPackagingBloc() → GiftPackagingBloc.add(SetGachaContent(gacha))
  상태: state.gachaContent = GachaContent(...)

[Step 5b] QuizSettingView
  UI: 퀴즈 문제/정답 추가, 성공/실패 보상 설정
  이벤트: GiftPackagingBloc.add(SetQuizContent(quiz))
  상태: state.quizContent = QuizContent(...)

[Step 5c] DirectOpenSettingView
  UI: 선물 아이템 이름/이미지 설정
  이벤트: GiftPackagingBloc.add(SetUnboxingContent(unboxing))
  상태: state.unboxingContent = UnboxingContent(...)

[Step 6] PackageCompleteView
  UI: "완성!" 버튼
  → GiftPackagingBloc.add(SubmitPackage(
       receiverName: state.receiverName,
       subTitle: state.subTitle,
       bgm: state.bgm,
       gallery: state.gallery,
       content: GiftContent(gacha: state.gachaContent),
     ))

  BLoC._onSubmitPackage():
    1. emit(state.copyWith(submitStatus: SubmitStatus.loading))
    2. GiftRequest 조립
    3. GiftRequest.toJson() → Map<String, dynamic>
    - api.createGift(jsonMap)  // POST /api/events
    - 응답 데이터에서 `eventUrl` 및 `eventCode` 파싱
    - 성공: `emit(state.copyWith(submitStatus: SubmitStatus.success, shareUrl: url, shareCode: code))`
    - 실패: `emit(state.copyWith(submitStatus: SubmitStatus.failure))`

  View(BlocListener):
    - success → 완료 UI 표시 (초대코드 및 공유 버튼 활성화)
    - failure → 에러 토스트
```

## GiftPackagingState 전체 필드

```dart
class GiftPackagingState {
  String receiverName;         // 기본값: ''
  String subTitle;             // 기본값: 랜덤 선택 (10개 중 1개)
  String bgm;                  // 기본값: ''
  List<GalleryItem> gallery;   // 기본값: []
  ContentType? selectedContentType;  // null / gacha / quiz / unboxing
  GachaContent? gachaContent;  // null (미선택 또는 가챠 미설정)
  QuizContent? quizContent;    // null (미선택 또는 퀴즈 미설정)
  UnboxingContent? unboxingContent;  // null (미선택 또는 언박싱 미설정)
  SubmitStatus submitStatus;   // idle → loading → success/failure
  String shareCode;            // 생성된 초대 코드
  String shareUrl;             // 생성된 공유 링크
}
```

초기값: `GiftPackagingState.initial()` - subTitle만 랜덤 생성:
```dart
static String generateRandomSubTitle() {
  final randomTitles = ['두근두근', '설레는', '호기심 가득', '신나는', ...]; // 10개
  return randomTitles[Random().nextInt(randomTitles.length)];
}
```

## GiftRequest JSON 직렬화 구조

```json
{
  "user": "홍길동",
  "sub_title": "두근두근",
  "bgm": "bgm_1",
  "gallery": [
    {
      "title": "우리 첫 만남",
      "image_url": "/data/user/.../file.jpg",
      "description": "처음 만났던 날"
    }
  ],
  "content": {
    "gacha": {
      "play_count": 3,
      "list": [
        {
          "item_name": "닌텐도",
          "image_url": "assets/images/item/nitendo.jpg",
          "percent": 30,
          "percent_open": true
        }
      ]
    },
    "quiz": null,
    "unboxing": null
  }
}
```

`@JsonKey(name: 'play_count')` 등 어노테이션으로 snake_case 필드명 매핑.

## 부모-자식 BLoC 동기화 타이밍

`MemoryGallerySettingBloc`과 `GachaSettingBloc`은 UI 변경이 발생할 때마다 즉시 동기화:
- 아이템 추가 → `_pushToPackagingBloc()` 호출
- 아이템 삭제 → `_pushToPackagingBloc()` 호출
- 이미지 변경 → `_pushToPackagingBloc()` 호출
- 재정렬 → `_pushToPackagingBloc()` 호출

따라서 PackageCompleteView에서 SubmitPackage 이벤트 발생 시 항상 최신 상태가 반영됨.

## 확장 방법: 새 컨텐츠 타입 추가

1. `ContentType` enum에 새 타입 추가 (`lib/features/addgift/model/gift_content.dart`)
2. 새 컨텐츠 모델 Freezed 클래스 생성 (`lib/features/addgift/model/`)
3. `GiftPackagingState`에 새 컨텐츠 필드 추가
4. `GiftPackagingBloc`에 `Set{NewContent}` 이벤트/핸들러 추가
5. 새 설정 뷰 생성 + ShellRoute에 라우트 추가
6. `GiftDeliveryMethodView`에 선택 옵션 추가
