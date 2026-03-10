import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/gallery_item.dart';
import '../gift_packaging_bloc.dart';

part 'memory_gallery_setting_event.dart';
part 'memory_gallery_setting_state.dart';

class MemoryGallerySettingBloc
    extends Bloc<MemoryGallerySettingEvent, MemoryGallerySettingState> {
  // GiftPackagingBloc을 주입받아 데이터 변경 시 즉시 동기화합니다.
  final GiftPackagingBloc _packagingBloc;

  MemoryGallerySettingBloc(this._packagingBloc)
    : super(const MemoryGallerySettingState()) {
    on<InitMemoryGallerySetting>(_onInit);
    on<AddMemoryItem>(_onAddItem);
    on<RemoveMemoryItem>(_onRemoveItem);
    on<RemoveAllMemoryItems>(_onRemoveAllItems);
    on<ReorderMemoryItems>(_onReorderItems);
    on<UpdateMemoryItemTitle>(_onUpdateItemTitle);
    on<UpdateMemoryItemDescription>(_onUpdateItemDescription);
    on<UpdateMemoryItemImage>(_onUpdateItemImage);
    on<RemoveMemoryItemImage>(_onRemoveItemImage);
    on<SelectMemoryItem>(_onSelectItem);
    on<ClearMemoryItemSelection>(_onClearSelection);
  }

  // uiItems를 GalleryItem 목록으로 변환하여 GiftPackagingBloc에 동기화합니다.
  void _pushToPackagingBloc(List<MemoryGalleryItemData> uiItems) {
    final List<GalleryItem> galleryItems = uiItems.map((item) {
      return GalleryItem(
        title: item.title,
        imageUrl: item.imageFile?.path ?? '',
        description: item.description,
      );
    }).toList();

    _packagingBloc.add(SetGalleryItems(galleryItems));
  }

  // 화면 진입 초기화: GiftPackagingBloc의 gallery 데이터를 바탕으로 uiItems 구성
  void _onInit(
    InitMemoryGallerySetting event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    emit(
      state.copyWith(
        uiItems: event.initialUiItems,
        nextId: event.initialNextId,
      ),
    );
  }

  // 새 갤러리 아이템 추가 후 GiftPackagingBloc에 동기화
  void _onAddItem(
    AddMemoryItem event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    final newItem = MemoryGalleryItemData(id: state.nextId);
    final newUiItems = List<MemoryGalleryItemData>.from(state.uiItems)
      ..add(newItem);
    emit(state.copyWith(uiItems: newUiItems, nextId: state.nextId + 1));
    _pushToPackagingBloc(newUiItems);
  }

  // 특정 아이템 삭제 후 GiftPackagingBloc에 동기화
  void _onRemoveItem(
    RemoveMemoryItem event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    final newUiItems = state.uiItems
        .where((item) => item.id != event.id)
        .toList();
    emit(state.copyWith(uiItems: newUiItems));
    _pushToPackagingBloc(newUiItems);
  }

  // 전체 아이템 초기화 후 GiftPackagingBloc에 동기화
  void _onRemoveAllItems(
    RemoveAllMemoryItems event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    emit(state.copyWith(uiItems: [], nextId: 1, selectedItemId: null));
    _pushToPackagingBloc([]);
  }

  // 드래그를 통한 아이템 순서 변경 후 GiftPackagingBloc에 동기화
  void _onReorderItems(
    ReorderMemoryItems event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    final List<MemoryGalleryItemData> newUiItems =
        List<MemoryGalleryItemData>.from(state.uiItems);
    int newIndex = event.newIndex;
    if (event.oldIndex < newIndex) {
      newIndex -= 1;
    }
    final MemoryGalleryItemData item = newUiItems.removeAt(event.oldIndex);
    newUiItems.insert(newIndex, item);
    emit(state.copyWith(uiItems: newUiItems));
    _pushToPackagingBloc(newUiItems);
  }

  // 아이템 제목 변경 후 GiftPackagingBloc에 동기화
  void _onUpdateItemTitle(
    UpdateMemoryItemTitle event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    final newUiItems = state.uiItems.map((item) {
      if (item.id == event.id) return item.copyWith(title: event.title);
      return item;
    }).toList();
    emit(state.copyWith(uiItems: newUiItems));
    _pushToPackagingBloc(newUiItems);
  }

  // 아이템 설명 변경 후 GiftPackagingBloc에 동기화
  void _onUpdateItemDescription(
    UpdateMemoryItemDescription event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    final newUiItems = state.uiItems.map((item) {
      if (item.id == event.id) {
        return item.copyWith(description: event.description);
      }
      return item;
    }).toList();
    emit(state.copyWith(uiItems: newUiItems));
    _pushToPackagingBloc(newUiItems);
  }

  // 아이템 이미지 변경 후 GiftPackagingBloc에 동기화
  void _onUpdateItemImage(
    UpdateMemoryItemImage event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    final newUiItems = state.uiItems.map((item) {
      if (item.id == event.id) return item.copyWith(imageFile: event.image);
      return item;
    }).toList();
    emit(state.copyWith(uiItems: newUiItems));
    _pushToPackagingBloc(newUiItems);
  }

  // 아이템 이미지 제거: imageFile을 null로 처리 후 GiftPackagingBloc에 동기화
  void _onRemoveItemImage(
    RemoveMemoryItemImage event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    final newUiItems = state.uiItems.map((item) {
      if (item.id == event.id) {
        // copyWith는 imageFile을 null로 처리할 수 없으므로 직접 생성
        return MemoryGalleryItemData(
          id: item.id,
          imageFile: null,
          title: item.title,
          description: item.description,
        );
      }
      return item;
    }).toList();
    emit(state.copyWith(uiItems: newUiItems));
    _pushToPackagingBloc(newUiItems);
  }

  // 아이템 선택(편집 모달 열릴 때 강조 표시용)
  void _onSelectItem(
    SelectMemoryItem event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    emit(state.copyWith(selectedItemId: event.id));
  }

  // 아이템 선택 해제(편집 모달 닫힐 때)
  void _onClearSelection(
    ClearMemoryItemSelection event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    emit(state.copyWithNullableSelectedId());
  }
}
