part of 'memory_gallery_setting_bloc.dart';

abstract class MemoryGallerySettingEvent extends Equatable {
  const MemoryGallerySettingEvent();

  @override
  List<Object?> get props => [];
}

// 화면 진입 시 초기화: GiftPackagingBloc의 기존 gallery 데이터를 바탕으로 uiItems를 구성합니다.
class InitMemoryGallerySetting extends MemoryGallerySettingEvent {
  final List<MemoryGalleryItemData> initialUiItems;
  final int initialNextId;

  const InitMemoryGallerySetting(this.initialUiItems, this.initialNextId);
}

// 새 갤러리 아이템 추가
class AddMemoryItem extends MemoryGallerySettingEvent {
  const AddMemoryItem();
}

// 특정 갤러리 아이템 삭제
class RemoveMemoryItem extends MemoryGallerySettingEvent {
  final int id;
  const RemoveMemoryItem(this.id);
}

// 모든 갤러리 아이템 초기화
class RemoveAllMemoryItems extends MemoryGallerySettingEvent {
  const RemoveAllMemoryItems();
}

// 드래그를 통한 아이템 순서 변경
class ReorderMemoryItems extends MemoryGallerySettingEvent {
  final int oldIndex;
  final int newIndex;
  const ReorderMemoryItems(this.oldIndex, this.newIndex);
}

// 특정 아이템 제목 변경
class UpdateMemoryItemTitle extends MemoryGallerySettingEvent {
  final int id;
  final String title;
  const UpdateMemoryItemTitle(this.id, this.title);
}

// 특정 아이템 설명 변경
class UpdateMemoryItemDescription extends MemoryGallerySettingEvent {
  final int id;
  final String description;
  const UpdateMemoryItemDescription(this.id, this.description);
}

// 특정 아이템 이미지 변경
class UpdateMemoryItemImage extends MemoryGallerySettingEvent {
  final int id;
  final XFile image;
  const UpdateMemoryItemImage(this.id, this.image);
}

// 특정 아이템 이미지 제거
class RemoveMemoryItemImage extends MemoryGallerySettingEvent {
  final int id;
  const RemoveMemoryItemImage(this.id);
}

// 아이템 선택(편집 모달 강조 표시용)
class SelectMemoryItem extends MemoryGallerySettingEvent {
  final int id;
  const SelectMemoryItem(this.id);
}

// 아이템 선택 해제
class ClearMemoryItemSelection extends MemoryGallerySettingEvent {
  const ClearMemoryItemSelection();
}
