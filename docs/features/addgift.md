# 선물 포장 기능 (AddGift)

> 이 문서의 목적: 발신자가 선물을 포장하는 8단계 플로우, 각 화면의 역할과 BLoC 연동을 이해한다.

## 개요

발신자가 선물을 포장하는 전체 플로우. ShellRoute로 묶여 `GiftPackagingBloc` 상태가 전 단계에 걸쳐 유지된다.

## 라우트 및 화면

| Step | 라우트 | 뷰 파일 | 역할 |
|------|--------|---------|------|
| 1 | `/addgift` | `receiver_name_view.dart` | 받는 분 성함 입력 |
| 2 | `/addgift/memory-decision` | `memory_decision_view.dart` | 추억 공유 여부 결정 |
| 3 | `/addgift/memory-gallery` | `memory_gallery_setting_view.dart` | 메모리 갤러리 편집 |
| 4 | `/addgift/delivery-method` | `gift_delivery_method_view.dart` | 컨텐츠 타입 선택 |
| 5a | `/addgift/gacha-setting` | `gacha_setting_view.dart` | 가챠 설정 |
| 5b | `/addgift/quiz-setting` | `quiz_setting_view.dart` | 퀴즈 설정 |
| 5c | `/addgift/direct-open-setting` | `direct_open_setting_view.dart` | 바로 오픈 설정 |
| 6 | `/addgift/package-complete` | `package_complete_view.dart` | 포장 완료 확인 |

모든 뷰 파일 위치: `lib/features/addgift/presentation/views/`

## BLoC 연동

### ShellRoute - GiftPackagingBloc 공유

```
ShellRoute (GiftPackagingBloc.value 제공)
  └─ 모든 /addgift/* 라우트에서 context.read<GiftPackagingBloc>() 접근 가능
```

### 각 단계별 BLoC 이벤트

| Step | 이벤트 | 상태 변화 |
|------|--------|-----------|
| 1 | `SetReceiverName(name)` | `receiverName` 저장 |
| 2 | (이동 결정만, BLoC 이벤트 없음) | - |
| 3 | `SetGalleryItems(items)` via MemoryGallerySettingBloc | `gallery` 저장 |
| 4 | `SetContentType(type)` | `selectedContentType` 저장 |
| 5a | `SetGachaContent(gacha)` via GachaSettingBloc | `gachaContent` 저장 |
| 5b | `SetQuizContent(quiz)` | `quizContent` 저장 |
| 5c | `SetUnboxingContent(unboxing)` | `unboxingContent` 저장 |
| 6 | `SubmitPackage(...)` | `submitStatus`: loading→success/failure |

## Step 3: 메모리 갤러리 설정

`MemoryGallerySettingBloc`은 `GiftPackagingBloc`을 주입받아 동작:

```dart
BlocProvider(
  create: (context) => MemoryGallerySettingBloc(
    context.read<GiftPackagingBloc>(),  // 부모 BLoC 주입
  ),
  child: MemoryGallerySettingView(),
)
```

기능:
- 아이템 추가/삭제/수정 (제목, 설명, 이미지)
- 드래그 재정렬 (`ReorderableGridView`)
- 정렬 (등록순, 한글 가나다, 영문 알파벳, 수동)
- 변경 시마다 `GiftPackagingBloc`에 자동 동기화

## Step 4: 컨텐츠 타입 선택

세 가지 선택지:

| 타입 | ContentType | 설명 |
|------|-------------|------|
| 캡슐 뽑기 | `ContentType.gacha` | 랜덤 아이템 뽑기 |
| 퀴즈 맞추기 | `ContentType.quiz` | 정답 맞추기 |
| 바로 오픈 | `ContentType.unboxing` | 바로 선물 확인 |

## Step 6: 포장 완료 및 제출

`PackageCompleteView`에서 사용자가 최종 확인:
1. `GiftPackagingBloc.add(SubmitPackage(...))` 호출
2. `submitStatus: loading` → API 전송 중 표시
3. `submitStatus: success` → 완료 UI 표시, `isPackageComplete = true` 설정
4. `submitStatus: failure` → 에러 토스트 표시

`isPackageComplete = true` 이후 `/addgift/*` 재진입 차단 (라우터 redirect).

## 모델 구조

```
GiftRequest
├── user: String
├── sub_title: String
├── bgm: String
├── gallery: List<GalleryItem>
│   └── { title, image_url, description }
└── content: GiftContent
    ├── gacha?: GachaContent
    │   └── { play_count, list: [{ item_name, image_url, percent, percent_open }] }
    ├── quiz?: QuizContent
    │   └── { list: [QuizItem], success_reward, fail_reward }
    └── unboxing?: UnboxingContent
```

자세한 데이터 플로우: [business-logic/gift-packaging-flow.md](../business-logic/gift-packaging-flow.md)
