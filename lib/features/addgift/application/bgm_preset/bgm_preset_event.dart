part of 'bgm_preset_bloc.dart';

sealed class BgmPresetEvent {}

class FetchBgmPresets extends BgmPresetEvent {}

class PlayBgmPreview extends BgmPresetEvent {
  final String presetId;
  PlayBgmPreview(this.presetId);
}

class StopBgmPreview extends BgmPresetEvent {}
