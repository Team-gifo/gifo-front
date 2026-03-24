import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/gacha_content.dart';
import '../../model/gallery_item.dart';
import '../../model/gift_content.dart';
import '../gift_packaging_bloc.dart';

part 'gacha_setting_event.dart';
part 'gacha_setting_state.dart';

class GachaSettingBloc extends Bloc<GachaSettingEvent, GachaSettingState> {
  // GiftPackagingBloc을 주입받아 모든 데이터 변경 시 즉시 동기화합니다.
  final GiftPackagingBloc _packagingBloc;

  GachaSettingBloc(this._packagingBloc) : super(const GachaSettingState()) {
    on<InitGachaSetting>(_onInit);
    on<AddGachaItem>(_onAddItem);
    on<RemoveGachaItem>(_onRemoveItem);
    on<RemoveAllGachaItems>(_onRemoveAllItems);
    on<UpdateGachaItemName>(_onUpdateItemName);
    on<UpdateGachaItemPercent>(_onUpdateItemPercent);
    on<UpdateGachaItemPercentOpen>(_onUpdateItemPercentOpen);
    on<UpdateGachaItemImage>(_onUpdateItemImage);
    on<RemoveGachaItemImage>(_onRemoveGachaItemImage);
    on<UpdatePlayCount>(_onUpdatePlayCount);
    on<UpdateBgm>(_onUpdateBgm);
    on<SubmitGachaSetting>(_onSubmitGachaSetting);
  }

  // GiftPackagingBloc의 현재 gachaContent에서 playCount를 유지하면서
  // uiItems를 GachaItem 목록으로 변환하여 GiftPackagingBloc에 저장합니다.
  void _pushToPackagingBloc(List<DefaultGachaItemData> uiItems) {
    final int currentPlayCount = _packagingBloc.state.gachaContent?.playCount ?? 3;

    final List<GachaItem> gachaItems = uiItems.map((DefaultGachaItemData item) {
      return GachaItem(
        itemName: item.itemName,
        imageUrl: item.imageFile?.path ?? '',
        percent: item.percent,
        percentOpen: item.percentOpen,
      );
    }).toList();

    _packagingBloc.add(
      SetGachaContent(
        GachaContent(playCount: currentPlayCount, list: gachaItems),
      ),
    );
  }

  // 화면 진입 초기화: GiftPackagingBloc의 gachaContent를 바탕으로 UI 아이템 목록 구성
  void _onInit(InitGachaSetting event, Emitter<GachaSettingState> emit) {
    emit(
      state.copyWith(
        uiItems: event.initialUiItems,
        nextId: event.initialNextId,
        selectedBgm: event.initialBgm,
      ),
    );
  }

  // 새 캡슐 아이템 추가: 로컬 uiItems에 추가 후 GiftPackagingBloc에 동기화
  void _onAddItem(AddGachaItem event, Emitter<GachaSettingState> emit) {
    final DefaultGachaItemData newItem = DefaultGachaItemData(
      id: state.nextId,
      color: event.color,
      itemName: '',
      percentStr: '0.0',
    );
    final List<DefaultGachaItemData> newUiItems = List<DefaultGachaItemData>.from(state.uiItems)
      ..add(newItem);
    emit(state.copyWith(uiItems: newUiItems, nextId: state.nextId + 1));
    _pushToPackagingBloc(newUiItems);
  }

  // 특정 캡슐 아이템 삭제: 로컬 uiItems에서 제거 후 GiftPackagingBloc에 동기화
  void _onRemoveItem(RemoveGachaItem event, Emitter<GachaSettingState> emit) {
    final List<DefaultGachaItemData> newUiItems = state.uiItems
        .where((DefaultGachaItemData item) => item.id != event.id)
        .toList();
    emit(state.copyWith(uiItems: newUiItems));
    _pushToPackagingBloc(newUiItems);
  }

  // 모든 캡슐 아이템 초기화: 로컬 uiItems 비운 후 GiftPackagingBloc에 동기화
  void _onRemoveAllItems(
    RemoveAllGachaItems event,
    Emitter<GachaSettingState> emit,
  ) {
    emit(state.copyWith(uiItems: <DefaultGachaItemData>[]));
    _pushToPackagingBloc(<DefaultGachaItemData>[]);
  }

  // 아이템 이름 변경: 로컬 uiItems 업데이트 후 GiftPackagingBloc에 동기화
  void _onUpdateItemName(
    UpdateGachaItemName event,
    Emitter<GachaSettingState> emit,
  ) {
    final List<DefaultGachaItemData> newUiItems = state.uiItems.map((DefaultGachaItemData item) {
      if (item.id == event.id) return item.copyWith(itemName: event.name);
      return item;
    }).toList();
    emit(state.copyWith(uiItems: newUiItems));
    _pushToPackagingBloc(newUiItems);
  }

  // 아이템 확률 변경: 로컬 uiItems 업데이트 후 GiftPackagingBloc에 동기화
  void _onUpdateItemPercent(
    UpdateGachaItemPercent event,
    Emitter<GachaSettingState> emit,
  ) {
    final List<DefaultGachaItemData> newUiItems = state.uiItems.map((DefaultGachaItemData item) {
      if (item.id == event.id) {
        return item.copyWith(percentStr: event.percentStr);
      }
      return item;
    }).toList();
    emit(state.copyWith(uiItems: newUiItems));
    _pushToPackagingBloc(newUiItems);
  }

  // 아이템 확률 공개여부 변경: 로컬 uiItems 업데이트 후 GiftPackagingBloc에 동기화
  void _onUpdateItemPercentOpen(
    UpdateGachaItemPercentOpen event,
    Emitter<GachaSettingState> emit,
  ) {
    final List<DefaultGachaItemData> newUiItems = state.uiItems.map((DefaultGachaItemData item) {
      if (item.id == event.id) return item.copyWith(percentOpen: event.isOpen);
      return item;
    }).toList();
    emit(state.copyWith(uiItems: newUiItems));
    _pushToPackagingBloc(newUiItems);
  }

  // 아이템 이미지 변경: 로컬 uiItems 업데이트 후 GiftPackagingBloc에 동기화
  void _onUpdateItemImage(
    UpdateGachaItemImage event,
    Emitter<GachaSettingState> emit,
  ) {
    final List<DefaultGachaItemData> newUiItems = state.uiItems.map((DefaultGachaItemData item) {
      if (item.id == event.id) return item.copyWith(imageFile: event.image);
      return item;
    }).toList();
    emit(state.copyWith(uiItems: newUiItems));
    _pushToPackagingBloc(newUiItems);
  }

  // 아이템 이미지 제거: imageFile을 null로 초기화 후 GiftPackagingBloc에 동기화
  void _onRemoveGachaItemImage(
    RemoveGachaItemImage event,
    Emitter<GachaSettingState> emit,
  ) {
    final List<DefaultGachaItemData> newUiItems = state.uiItems.map((DefaultGachaItemData item) {
      if (item.id == event.id) {
        // copyWith는 imageFile을 null로 처리할 수 없으므로 직접 생성
        return DefaultGachaItemData(
          id: item.id,
          color: item.color,
          imageFile: null,
          itemName: item.itemName,
          percentStr: item.percentStr,
          percentOpen: item.percentOpen,
        );
      }
      return item;
    }).toList();
    emit(state.copyWith(uiItems: newUiItems));
    _pushToPackagingBloc(newUiItems);
  }

  // 뽑기 가능 횟수 변경: GiftPackagingBloc의 gachaContent.playCount 직접 업데이트
  void _onUpdatePlayCount(
    UpdatePlayCount event,
    Emitter<GachaSettingState> emit,
  ) {
    final int playCount = int.tryParse(event.countStr) ?? 3;
    final List<GachaItem> currentItems = _packagingBloc.state.gachaContent?.list ?? <GachaItem>[];
    _packagingBloc.add(
      SetGachaContent(GachaContent(playCount: playCount, list: currentItems)),
    );
  }

  // BGM 변경: 로컬 state 업데이트
  void _onUpdateBgm(UpdateBgm event, Emitter<GachaSettingState> emit) {
    emit(state.copyWith(selectedBgm: event.bgm));
  }

  // 포장 완료: GiftPackagingBloc에 SubmitPackage 이벤트 전달 -> API 전송
  void _onSubmitGachaSetting(
    SubmitGachaSetting event,
    Emitter<GachaSettingState> emit,
  ) {
    final GachaContent gachaContent =
        _packagingBloc.state.gachaContent ?? const GachaContent();

    _packagingBloc.add(
      SubmitPackage(
        receiverName: event.receiverName,
        subTitle: event.subTitle,
        bgm: state.selectedBgm,
        gallery: event.gallery,
        content: GiftContent(gacha: gachaContent),
      ),
    );
  }
}
