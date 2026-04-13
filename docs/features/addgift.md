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
- **최대 10개 제한**: 10개 도달 시 추가 버튼 비활성화 및 경고 가이드 표시
- **반응형 하단 바**: 모바일 환경에서는 텍스트 라벨을 숨기고 숫자 카운트만 표시하여 공간 확보
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
## Step 5b: 퀴즈 맞추기 설정

`QuizSettingBloc`을 통해 각 퀴즈 문제와 보상을 설정한다:
- **문제 유형**: 객관식, 주관식, OX 퀴즈 지원
- **항목 설정**: 제목, 이미지(선택), 설명, 힌트, 정답
- **제출 횟수(play_limit)**: 각 문제별로 시도 가능한 횟수 설정 (기본값: 1)
  - 입력하지 않거나 0 이하 입력 시 자동으로 1회로 설정된다.
  - 수신자는 해당 횟수만큼 틀리면 다음 문제로 강제 이동된다.
- **보상 설정**: 성공 기준 정답 수, 성공 시 보상(이름/이미지), 실패 시 보상(이름/이미지)


## Step 6: 포장 완료 및 초대 공유

`PackageCompleteView`에서 사용자가 최종 확인 및 공유를 진행한다:
1. `GiftPackagingBloc.add(SubmitPackage(...))` 호출
2. `submitStatus: loading` → 중앙 배치된 로딩 가이드 표시
3. `submitStatus: success` → 완료 UI 표시
    - **개인화 메시지**: `'{닉네임}' 님의 선물 포장이 완료되었어요!` 문구 표시
    - **초대코드 표시**: `SelectableText`를 통해 드래그 복사 가능
    - **클립보드 복사**: 초대코드 옆 버튼 클릭 시 정해진 공유 템플릿 양식으로 복사
    - **공유하기**: `share_plus`를 사용하여 외부 앱으로 템플릿 메시지 전송
4. `submitStatus: failure` → 에러 토스트 표시

### 공유 템플릿 양식
```text
[Gifo]
'{받는분}'님만을 위한 선물을 준비하였습니다 🎁
아래 사이트에 접속해서 확인해주세요!🎉
초대 코드 : {초대코드}
{공유링크}
```

## UI 표준화 지침

모든 설정 화면(`GachaSetting`, `QuizSetting`, `DirectOpenSetting`)은 다음 요소들을 통일하여 사용한다:
- **AppBar Progress**: 상단 우측에 현재 진행 단계(`3/3` 등)를 동일한 스타일로 표시
- **BGM Widget**: 앱 하단에 배치되는 BGM 선택 UI를 일관된 디자인으로 유지하며, 화면 이동 시 자동 중지 로직 포함
- **Dashed Buttons**: 리스트 최하단의 '추가하기' 버튼은 점선(Dashed) 외곽선과 네온 컬러를 적용하여 시각적 일관성 유지
- **Form Fields**: 각 설정 모달의 입력 필드는 `WantedSans` 폰트와 `AppColors.darkBg` 다크 스타일 테마를 공통 적용 (제출 횟수 등 숫자 입력 필드는 `digitsOnly` 제한 적용)
- **Loading Overlay**: 전송 중 표시되는 오버레이는 `AppColors.darkBg`와 네온 포인트를 사용한 다크 테마 적용
- **Premium Buttons**: `PackageCompleteView` 등 주요 액션 버튼은 그라데이션과 그림자가 포함된 프리미엄 스타일 적용
- **Responsive Layout**: 태블릿/데스크톱에서는 설정 패널을 우측에 배치(`DesktopSettingsRail`)하고, 모바일에서는 하단 바(`MobileBottomBar`) 사용

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
