part of 'gacha_setting_bloc.dart';

abstract class GachaSettingEvent extends Equatable {
  const GachaSettingEvent();

  @override
  List<Object?> get props => [];
}

class InitGachaSetting extends GachaSettingEvent {
  final List<DefaultGachaItemData> initialItems;
  final int initialNextId;
  final String initialPlayCount;
  final String initialBgm;

  const InitGachaSetting(
    this.initialItems,
    this.initialNextId,
    this.initialPlayCount,
    this.initialBgm,
  );
}

class AddGachaItem extends GachaSettingEvent {
  final Color color;
  final String? name;
  final String? percent;
  const AddGachaItem({required this.color, this.name, this.percent});
}

class RemoveGachaItem extends GachaSettingEvent {
  final int id;
  const RemoveGachaItem(this.id);
}

class RemoveAllGachaItems extends GachaSettingEvent {}

class UpdateGachaItemName extends GachaSettingEvent {
  final int id;
  final String name;
  const UpdateGachaItemName(this.id, this.name);
}

class UpdateGachaItemPercent extends GachaSettingEvent {
  final int id;
  final String percentStr;
  const UpdateGachaItemPercent(this.id, this.percentStr);
}

class UpdateGachaItemPercentOpen extends GachaSettingEvent {
  final int id;
  final bool isOpen;
  const UpdateGachaItemPercentOpen(this.id, this.isOpen);
}

class UpdateGachaItemImage extends GachaSettingEvent {
  final int id;
  final XFile image;
  const UpdateGachaItemImage(this.id, this.image);
}

class RemoveGachaItemImage extends GachaSettingEvent {
  final int id;
  const RemoveGachaItemImage(this.id);
}

class UpdatePlayCount extends GachaSettingEvent {
  final String countStr;
  const UpdatePlayCount(this.countStr);
}

class UpdateBgm extends GachaSettingEvent {
  final String bgm;
  const UpdateBgm(this.bgm);
}

// 포장 완료: 뷰에서만 알 수 있는 수신자 이름, 서브 타이틀, 갤러리 정보를 담아 BLoC으로 전달합니다.
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
