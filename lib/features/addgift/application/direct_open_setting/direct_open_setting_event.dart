part of 'direct_open_setting_bloc.dart';

sealed class DirectOpenSettingEvent {}

class InitDirectOpenSetting extends DirectOpenSettingEvent {
  final String initialBgm;
  final XFile? beforeImageFile;
  final String? beforeDescription;
  final XFile? afterImageFile;
  final String? afterItemName;

  InitDirectOpenSetting({
    this.initialBgm = '',
    this.beforeImageFile,
    this.beforeDescription,
    this.afterImageFile,
    this.afterItemName,
  });
}

class UpdateBeforeImage extends DirectOpenSettingEvent {
  final XFile image;
  UpdateBeforeImage(this.image);
}

class UpdateBeforeDescription extends DirectOpenSettingEvent {
  final String description;
  UpdateBeforeDescription(this.description);
}

class UpdateAfterImage extends DirectOpenSettingEvent {
  final XFile image;
  UpdateAfterImage(this.image);
}

class UpdateAfterItemName extends DirectOpenSettingEvent {
  final String itemName;
  UpdateAfterItemName(this.itemName);
}

class UpdateDirectOpenBgm extends DirectOpenSettingEvent {
  final String bgm;
  UpdateDirectOpenBgm(this.bgm);
}

class SubmitDirectOpenSetting extends DirectOpenSettingEvent {
  final String receiverName;
  final String subTitle;
  final List<GalleryItem> gallery;

  SubmitDirectOpenSetting({
    required this.receiverName,
    required this.subTitle,
    required this.gallery,
  });
}
