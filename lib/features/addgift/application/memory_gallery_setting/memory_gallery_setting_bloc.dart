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
    on<HoverMemoryItem>(_onHoverItem);
    on<ClearHoverMemoryItem>(_onClearHoverItem);
    on<SortMemoryItems>(_onSortMemoryItems);
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
    emit(state.copyWith(
      uiItems: newUiItems,
      sortType: MemorySortType.manual,
    ));
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

  // 아이템 Hover 상태 설정
  void _onHoverItem(
    HoverMemoryItem event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    emit(state.copyWith(hoveredItemId: event.id));
  }

  // 아이템 Hover 상태 해제
  void _onClearHoverItem(
    ClearHoverMemoryItem event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    emit(state.copyWithNullableHoveredId());
  }

  // 언어 우선순위 판별 (첫 글자 기준)
  // return: 0 (가장 높음) ~ 3 (가장 낮음)
  int _getLanguagePriority(String text, bool isKoreanPriority) {
    if (text.trim().isEmpty) return 3;

    final int codeUnit = text.trim().codeUnitAt(0);
    // 한글: 0xAC00 ~ 0xD7A3 (가-힣) / 0x3131 ~ 0x318E (ㄱ-ㅎ, ㅏ-ㅣ)
    final bool isKorean = (codeUnit >= 0xAC00 && codeUnit <= 0xD7A3) ||
        (codeUnit >= 0x3131 && codeUnit <= 0x318E);
    // 영문: a-z, A-Z -> 0x41 ~ 0x5A, 0x61 ~ 0x7A
    final bool isEnglish = (codeUnit >= 0x41 && codeUnit <= 0x5A) ||
        (codeUnit >= 0x61 && codeUnit <= 0x7A);

    if (isKoreanPriority) {
      if (isKorean) return 0;
      if (isEnglish) return 1;
      return 2;
    } else {
      if (isEnglish) return 0;
      if (isKorean) return 1;
      return 2;
    }
  }

  // 한글 제목 정렬 로직 (한글 우선)
  int _compareKoreanPriority(String a, String b) {
    final int priorityA = _getLanguagePriority(a, true);
    final int priorityB = _getLanguagePriority(b, true);

    if (priorityA != priorityB) {
      return priorityA.compareTo(priorityB);
    }
    return a.compareTo(b);
  }

  // 영문 제목 정렬 로직 (영문 우선)
  int _compareEnglishPriority(String a, String b) {
    final int priorityA = _getLanguagePriority(a, false);
    final int priorityB = _getLanguagePriority(b, false);

    if (priorityA != priorityB) {
      return priorityA.compareTo(priorityB);
    }
    return a.toLowerCase().compareTo(b.toLowerCase());
  }

  // 아이템 정렬 처리
  void _onSortMemoryItems(
    SortMemoryItems event,
    Emitter<MemoryGallerySettingState> emit,
  ) {
    if (event.sortType == MemorySortType.manual) return;

    bool newIsAscending = true;
    if (state.sortType == event.sortType) {
      newIsAscending = !state.isAscending;
    }

    final List<MemoryGalleryItemData> sortedItems =
        List<MemoryGalleryItemData>.from(state.uiItems);

    sortedItems.sort((a, b) {
      int comparison = 0;
      switch (event.sortType) {
        case MemorySortType.createdAt:
          comparison = a.id.compareTo(b.id);
          break;
        case MemorySortType.titleKo:
          comparison = _compareKoreanPriority(a.title, b.title);
          break;
        case MemorySortType.titleEn:
          comparison = _compareEnglishPriority(a.title, b.title);
          break;
        case MemorySortType.manual:
          break;
      }
      return newIsAscending ? comparison : -comparison;
    });

    emit(state.copyWith(
      uiItems: sortedItems,
      sortType: event.sortType,
      isAscending: newIsAscending,
    ));

    _pushToPackagingBloc(sortedItems);
  }
}
