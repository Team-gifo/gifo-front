# 메모리 갤러리 비즈니스 로직

> 이 문서의 목적: 발신자가 추억 갤러리를 편집할 때의 정렬/재정렬 로직, 부모 BLoC 동기화 패턴을 이해한다.

## 관련 파일

- `lib/features/addgift/application/memory_gallery_setting/memory_gallery_setting_bloc.dart`
- `lib/features/addgift/application/memory_gallery_setting/memory_gallery_setting_state.dart`
- `lib/features/addgift/application/memory_gallery_setting/memory_gallery_setting_event.dart`

## 이벤트 목록

| 이벤트 | 설명 |
|--------|------|
| `InitMemoryGallerySetting` | 초기 데이터 설정 |
| `AddMemoryItem` | 새 갤러리 아이템 추가 |
| `RemoveMemoryItem(id)` | 특정 아이템 삭제 |
| `RemoveAllMemoryItems` | 전체 아이템 초기화 |
| `ReorderMemoryItems(oldIndex, newIndex)` | 드래그 재정렬 |
| `UpdateMemoryItemTitle(id, title)` | 아이템 제목 변경 |
| `UpdateMemoryItemDescription(id, description)` | 아이템 설명 변경 |
| `UpdateMemoryItemImage(id, image)` | 아이템 이미지 변경 |
| `RemoveMemoryItemImage(id)` | 아이템 이미지 제거 |
| `SelectMemoryItem(id)` | 편집 모달 열기 (강조 표시용) |
| `ClearMemoryItemSelection` | 편집 모달 닫기 |
| `HoverMemoryItem(id)` | 호버 상태 설정 (웹/데스크탑) |
| `ClearHoverMemoryItem` | 호버 상태 해제 |
| `SortMemoryItems(sortType)` | 정렬 유형 변경 |

## 부모 BLoC 동기화

모든 아이템 변경 이벤트 처리 후 `_pushToPackagingBloc()` 호출:

```dart
void _pushToPackagingBloc(List<MemoryGalleryItemData> uiItems) {
  final List<GalleryItem> galleryItems = uiItems.map((item) {
    return GalleryItem(
      title: item.title,
      imageUrl: item.imageFile?.path ?? '',  // XFile 경로 → String
      description: item.description,
    );
  }).toList();

  _packagingBloc.add(SetGalleryItems(galleryItems));
}
```

**MemoryGalleryItemData → GalleryItem 변환:**
- `imageFile`은 `XFile?` (image_picker에서 선택한 파일)
- 서버 전송 시 `imageFile.path`를 `image_url`로 사용

## 드래그 재정렬 로직 (ReorderMemoryItems)

`ReorderableGridView` 위젯에서 드래그 완료 시 이벤트 발생:

```dart
void _onReorderItems(
  ReorderMemoryItems event,
  Emitter<MemoryGallerySettingState> emit,
) {
  final List<MemoryGalleryItemData> newUiItems =
      List<MemoryGalleryItemData>.from(state.uiItems);

  int newIndex = event.newIndex;
  // ReorderableGridView는 삭제 전 인덱스를 기준으로 하므로 보정 필요
  if (event.oldIndex < newIndex) {
    newIndex -= 1;
  }

  final item = newUiItems.removeAt(event.oldIndex);
  newUiItems.insert(newIndex, item);

  emit(state.copyWith(
    uiItems: newUiItems,
    sortType: MemorySortType.manual,  // 수동 재정렬로 상태 전환
  ));
  _pushToPackagingBloc(newUiItems);
}
```

**인덱스 보정:** Flutter의 `ReorderableListView`/`ReorderableGridView`는 아이템을 먼저 제거한 후의 인덱스를 `newIndex`로 전달하므로, `oldIndex < newIndex`일 때 `newIndex - 1` 보정이 필요.

## 정렬 로직 (SortMemoryItems)

4가지 정렬 타입:

| MemorySortType | 설명 | 정렬 기준 |
|----------------|------|----------|
| `createdAt` | 등록순 | `item.id` (자동 증가 int) |
| `titleKo` | 한글 제목순 | 한글 우선 → 영문 → 기타 |
| `titleEn` | 영문 제목순 | 영문 우선 → 한글 → 기타 |
| `manual` | 수동 | 드래그 재정렬 상태, 추가 정렬 없음 |

동일 정렬 타입 재클릭 시 `isAscending` 토글 (오름차순 ↔ 내림차순).

### 언어 우선순위 판별 (Unicode 기반)

```dart
int _getLanguagePriority(String text, bool isKoreanPriority) {
  if (text.trim().isEmpty) return 3;  // 빈 문자열은 최하위

  final int codeUnit = text.trim().codeUnitAt(0);  // 첫 글자 코드포인트

  // 한글 판별: 가-힣 (0xAC00~0xD7A3) + ㄱ-ㅣ (0x3131~0x318E)
  final bool isKorean = (codeUnit >= 0xAC00 && codeUnit <= 0xD7A3) ||
      (codeUnit >= 0x3131 && codeUnit <= 0x318E);

  // 영문 판별: A-Z (0x41~0x5A), a-z (0x61~0x7A)
  final bool isEnglish = (codeUnit >= 0x41 && codeUnit <= 0x5A) ||
      (codeUnit >= 0x61 && codeUnit <= 0x7A);

  if (isKoreanPriority) {
    if (isKorean) return 0;   // 최우선
    if (isEnglish) return 1;
    return 2;                  // 숫자/특수문자 등
  } else {
    if (isEnglish) return 0;  // 최우선
    if (isKorean) return 1;
    return 2;
  }
}
```

**우선순위가 같을 때:** `a.compareTo(b)` (Dart 기본 문자열 비교)

## MemoryGalleryItemData 구조

```dart
class MemoryGalleryItemData {
  final int id;           // 자동 증가 고유 ID (정렬 기준으로 사용)
  final XFile? imageFile; // image_picker에서 선택한 이미지 파일
  final String title;     // 제목 (기본값: '')
  final String description; // 설명 (기본값: '')
}
```

**imageFile null 처리:** `copyWith`로 null 설정 불가 → 직접 생성:
```dart
// _onRemoveItemImage에서 특이 처리
return MemoryGalleryItemData(
  id: item.id,
  imageFile: null,  // copyWith로는 null 설정 불가
  title: item.title,
  description: item.description,
);
```
