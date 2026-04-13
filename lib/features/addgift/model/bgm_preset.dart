import 'package:freezed_annotation/freezed_annotation.dart';

part 'bgm_preset.freezed.dart';
part 'bgm_preset.g.dart';

@freezed
abstract class BgmPreset with _$BgmPreset {
  const factory BgmPreset({
    required String id,
    required String name,
    @Default('') String url,
  }) = _BgmPreset;

  factory BgmPreset.fromJson(Map<String, dynamic> json) =>
      _$BgmPresetFromJson(json);
}

/// API 실패 시 사용할 fallback 프리셋 목록 (url 비어있음 → 재생 불가)
const List<BgmPreset> kFallbackBgmPresets = <BgmPreset>[
  BgmPreset(id: 'exciting', name: '신나는'),
  BgmPreset(id: 'calm', name: '잔잔한'),
  BgmPreset(id: 'nostalgic', name: '추억'),
];
