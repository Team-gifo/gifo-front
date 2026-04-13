part of 'bgm_preset_bloc.dart';

class BgmPresetState {
  final List<BgmPreset> presets;
  final bool isLoaded;
  final bool isApiFailed;
  final String? playingPresetId;

  const BgmPresetState({
    this.presets = const <BgmPreset>[],
    this.isLoaded = false,
    this.isApiFailed = false,
    this.playingPresetId,
  });

  BgmPresetState copyWith({
    List<BgmPreset>? presets,
    bool? isLoaded,
    bool? isApiFailed,
    String? playingPresetId,
    bool clearPlayingPresetId = false,
  }) {
    return BgmPresetState(
      presets: presets ?? this.presets,
      isLoaded: isLoaded ?? this.isLoaded,
      isApiFailed: isApiFailed ?? this.isApiFailed,
      playingPresetId: clearPlayingPresetId
          ? null
          : (playingPresetId ?? this.playingPresetId),
    );
  }
}
