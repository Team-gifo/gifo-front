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
  // 포장 완료 시 SubmitPackage 이벤트를 직접 전달하기 위해 GiftPackagingBloc 참조를 주입받습니다.
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

  // BLoC 초기화: 기존 저장된 캡슐 아이템, 다음 ID, 뽑기 횟수, BGM 등을 초기 상태로 설정합니다.
  void _onInit(InitGachaSetting event, Emitter<GachaSettingState> emit) {
    emit(
      state.copyWith(
        items: event.initialItems,
        nextId: event.initialNextId,
        playCountStr: event.initialPlayCount,
        selectedBgm: event.initialBgm,
      ),
    );
  }

  // 새로운 캡슐 아이템을 목록에 추가하고, 다음 아이템을 위한 ID를 1 증가시킵니다.
  void _onAddItem(AddGachaItem event, Emitter<GachaSettingState> emit) {
    final newItem = DefaultGachaItemData(
      id: state.nextId,
      color: event.color,
      itemName: event.name ?? '',
      percentStr: event.percent ?? '0.0',
    );
    final newItems = List<DefaultGachaItemData>.from(state.items)..add(newItem);
    emit(state.copyWith(items: newItems, nextId: state.nextId + 1));
  }

  // 특정 ID를 가진 캡슐 아이템을 목록에서 제거합니다.
  void _onRemoveItem(RemoveGachaItem event, Emitter<GachaSettingState> emit) {
    final newItems = state.items.where((item) => item.id != event.id).toList();
    emit(state.copyWith(items: newItems));
  }

  // 목록에 있는 모든 캡슐 아이템을 일괄 삭제하여 초기화합니다.
  void _onRemoveAllItems(
    RemoveAllGachaItems event,
    Emitter<GachaSettingState> emit,
  ) {
    emit(state.copyWith(items: []));
  }

  // 특정 ID의 캡슐 아이템의 상품명(이름)을 업데이트합니다.
  void _onUpdateItemName(
    UpdateGachaItemName event,
    Emitter<GachaSettingState> emit,
  ) {
    final newItems = state.items.map((item) {
      if (item.id == event.id) {
        return item.copyWith(itemName: event.name);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: newItems));
  }

  // 특정 ID의 캡슐 아이템의 당첨 확률(텍스트)을 업데이트합니다.
  void _onUpdateItemPercent(
    UpdateGachaItemPercent event,
    Emitter<GachaSettingState> emit,
  ) {
    final newItems = state.items.map((item) {
      if (item.id == event.id) {
        return item.copyWith(percentStr: event.percentStr);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: newItems));
  }

  // 특정 ID의 캡슐 아이템의 확률 공개 여부(체크박스 상태)를 업데이트합니다.
  void _onUpdateItemPercentOpen(
    UpdateGachaItemPercentOpen event,
    Emitter<GachaSettingState> emit,
  ) {
    final newItems = state.items.map((item) {
      if (item.id == event.id) {
        return item.copyWith(percentOpen: event.isOpen);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: newItems));
  }

  // 특정 ID의 캡슐 아이템에 선택된 이미지를 업데이트합니다.
  void _onUpdateItemImage(
    UpdateGachaItemImage event,
    Emitter<GachaSettingState> emit,
  ) {
    final newItems = state.items.map((item) {
      if (item.id == event.id) {
        return item.copyWith(imageFile: event.image);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: newItems));
  }

  void _onRemoveGachaItemImage(
    RemoveGachaItemImage event,
    Emitter<GachaSettingState> emit,
  ) {
    final newItems = state.items.map((item) {
      if (item.id == event.id) {
        // 기존 상태 기반 복사본을 직접 생성하여 imageFile을 null로 초기화합니다.
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
    emit(state.copyWith(items: newItems));
  }

  // 사용자가 설정한 총 뽑기 가능 횟수를 업데이트합니다.
  void _onUpdatePlayCount(
    UpdatePlayCount event,
    Emitter<GachaSettingState> emit,
  ) {
    emit(state.copyWith(playCountStr: event.countStr));
  }

  // 캡슐 뽑기 화면에서 재생될 BGM을 업데이트합니다.
  void _onUpdateBgm(UpdateBgm event, Emitter<GachaSettingState> emit) {
    emit(state.copyWith(selectedBgm: event.bgm));
  }

  // 캡슐 세팅 완료: BLoC state와 뷰에서 전달받은 데이터를 조합하여 GiftPackagingBloc으로 SubmitPackage를 dispatch합니다.
  void _onSubmitGachaSetting(
    SubmitGachaSetting event,
    Emitter<GachaSettingState> emit,
  ) {
    // BLoC state의 캡슐 아이템 목록을 GachaItem 모델로 변환
    final List<GachaItem> gachaItems = state.items
        .map(
          (item) => GachaItem(
            itemName: item.itemName,
            imageUrl: item.imageFile?.path ?? '',
            percent: item.percent,
            percentOpen: item.percentOpen,
          ),
        )
        .toList();

    final int playCount = int.tryParse(state.playCountStr) ?? 3;
    final GachaContent gachaContent = GachaContent(
      playCount: playCount,
      list: gachaItems,
    );

    // GiftPackagingBloc에 SubmitPackage 이벤트 dispatch -> _onSubmitPackage 실행 -> API 전송
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
