part of 'memory_gallery_setting_bloc.dart';

// MemoryGallerySettingView에서 사용하는 UI 전용 아이템 모델
// 실제 데이터는 GiftPackagingBloc에 저장되지만, View 렌더링(이미지 파일 등)에
// 필요한 일시적인 정보를 별도로 관리합니다.

enum MemorySortType {
  manual,
  createdAt,
  titleKo,
  titleEn,
}

class MemoryGalleryItemData extends Equatable {
  final int id;
  final XFile? imageFile;
  final String title;
  final String description;

  const MemoryGalleryItemData({
    required this.id,
    this.imageFile,
    this.title = '',
    this.description = '',
  });

  MemoryGalleryItemData copyWith({
    XFile? imageFile,
    String? title,
    String? description,
  }) {
    return MemoryGalleryItemData(
      id: id,
      imageFile: imageFile ?? this.imageFile,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, imageFile?.path, title, description];
}

// MemoryGallerySettingBloc의 로컬 상태
// 실제 갤러리 데이터는 GiftPackagingBloc이 보유하며, 이 State는
// View 렌더링에 필요한 UI 전용 정보(이미지 파일, 선택 상태, 다음 ID 등)만 관리합니다.
class MemoryGallerySettingState extends Equatable {
  // View 렌더링용 UI 데이터 (이미지 파일 포함)
  final List<MemoryGalleryItemData> uiItems;
  // 다음 갤러리 아이템 ID 카운터
  final int nextId;
  // 현재 편집 중인 아이템 ID (오렌지 테두리 강조 표시용)
  final int? selectedItemId;
  // 현재 Hover 중인 아이템 ID (삭제 버튼 등 노출용)
  final int? hoveredItemId;
  // 현재 정렬 기준 (생성순, 제목 한글, 제목 영어)
  final MemorySortType sortType;
  // 정렬 방향 (오름차순/내림차순)
  final bool isAscending;

  const MemoryGallerySettingState({
    this.uiItems = const <MemoryGalleryItemData>[],
    this.nextId = 1,
    this.selectedItemId,
    this.hoveredItemId,
    this.sortType = MemorySortType.createdAt,
    this.isAscending = true,
  });

  MemoryGallerySettingState copyWith({
    List<MemoryGalleryItemData>? uiItems,
    int? nextId,
    int? selectedItemId,
    int? hoveredItemId,
    MemorySortType? sortType,
    bool? isAscending,
  }) {
    return MemoryGallerySettingState(
      uiItems: uiItems ?? this.uiItems,
      nextId: nextId ?? this.nextId,
      selectedItemId: selectedItemId ?? this.selectedItemId,
      hoveredItemId: hoveredItemId ?? this.hoveredItemId,
      sortType: sortType ?? this.sortType,
      isAscending: isAscending ?? this.isAscending,
    );
  }

  // selectedItemId를 명시적으로 null로 초기화하기 위한 별도 메서드
  MemoryGallerySettingState copyWithNullableSelectedId() {
    return MemoryGallerySettingState(
      uiItems: uiItems,
      nextId: nextId,
      selectedItemId: null,
      hoveredItemId: hoveredItemId,
      sortType: sortType,
      isAscending: isAscending,
    );
  }

  // hoveredItemId를 명시적으로 null로 초기화
  MemoryGallerySettingState copyWithNullableHoveredId() {
    return MemoryGallerySettingState(
      uiItems: uiItems,
      nextId: nextId,
      selectedItemId: selectedItemId,
      hoveredItemId: null,
      sortType: sortType,
      isAscending: isAscending,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        uiItems,
        nextId,
        selectedItemId,
        hoveredItemId,
        sortType,
        isAscending,
      ];
}
