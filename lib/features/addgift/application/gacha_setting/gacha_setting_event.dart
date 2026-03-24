part of 'gacha_setting_bloc.dart';

abstract class GachaSettingEvent extends Equatable {
  const GachaSettingEvent();

  @override
  List<Object?> get props => <Object?>[];
}

// 화면 진입 시 초기화: GiftPackagingBloc의 기존 gachaContent를 바탕으로 UI 아이템 목록을 구성합니다.
class InitGachaSetting extends GachaSettingEvent {
  final List<DefaultGachaItemData> initialUiItems;
  final int initialNextId;
  final String initialBgm;

  const InitGachaSetting(
    this.initialUiItems,
    this.initialNextId,
    this.initialBgm,
  );
}

// 새 캡슐 아이템 추가 (색상은 즉시 결정, 실제 데이터는 GiftPackagingBloc에 저장)
class AddGachaItem extends GachaSettingEvent {
  final Color color;
  const AddGachaItem({required this.color});
}

// 특정 캡슐 아이템 삭제
class RemoveGachaItem extends GachaSettingEvent {
  final int id;
  const RemoveGachaItem(this.id);
}

// 모든 캡슐 아이템 초기화
class RemoveAllGachaItems extends GachaSettingEvent {}

// 특정 캡슐 아이템 이름 변경
class UpdateGachaItemName extends GachaSettingEvent {
  final int id;
  final String name;
  const UpdateGachaItemName(this.id, this.name);
}

// 특정 캡슐 아이템 확률 변경
class UpdateGachaItemPercent extends GachaSettingEvent {
  final int id;
  final String percentStr;
  const UpdateGachaItemPercent(this.id, this.percentStr);
}

// 특정 캡슐 아이템 확률 공개여부 변경
class UpdateGachaItemPercentOpen extends GachaSettingEvent {
  final int id;
  final bool isOpen;
  const UpdateGachaItemPercentOpen(this.id, this.isOpen);
}

// 특정 캡슐 아이템 이미지 변경
class UpdateGachaItemImage extends GachaSettingEvent {
  final int id;
  final XFile image;
  const UpdateGachaItemImage(this.id, this.image);
}

// 특정 캡슐 아이템 이미지 제거
class RemoveGachaItemImage extends GachaSettingEvent {
  final int id;
  const RemoveGachaItemImage(this.id);
}

// 뽑기 가능 횟수 변경 (GiftPackagingBloc의 gachaContent.playCount 업데이트)
class UpdatePlayCount extends GachaSettingEvent {
  final String countStr;
  const UpdatePlayCount(this.countStr);
}

// BGM 변경 (GachaSettingBloc의 로컬 상태 + GiftPackagingBloc의 bgm 필드 업데이트)
class UpdateBgm extends GachaSettingEvent {
  final String bgm;
  const UpdateBgm(this.bgm);
}

// 포장 완료: GiftPackagingBloc에 SubmitPackage 이벤트를 dispatch합니다.
class SubmitGachaSetting extends GachaSettingEvent {
  final String receiverName;
  final String subTitle;
  final List<GalleryItem> gallery;

  const SubmitGachaSetting({
    required this.receiverName,
    required this.subTitle,
    required this.gallery,
  });
}
