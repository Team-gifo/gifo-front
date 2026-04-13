import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

import '../../model/bgm_preset.dart';
import '../../repository/addgift_api.dart';

part 'bgm_preset_event.dart';
part 'bgm_preset_state.dart';

class BgmPresetBloc extends Bloc<BgmPresetEvent, BgmPresetState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  BgmPresetBloc() : super(const BgmPresetState()) {
    on<FetchBgmPresets>(_onFetch);
    on<PlayBgmPreview>(_onPlay);
    on<StopBgmPreview>(_onStop);

    _audioPlayer.playerStateStream.listen((PlayerState playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        add(StopBgmPreview());
      }
    });
  }

  Future<void> _onFetch(
    FetchBgmPresets event,
    Emitter<BgmPresetState> emit,
  ) async {
    try {
      final AddGiftApi api = GetIt.instance<AddGiftApi>();
      final dynamic response = await api.getBgmPresets();
      final Map<String, dynamic>? responseData =
          response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : null;
      final List<dynamic>? dataList =
          responseData?['data'] is List<dynamic>
              ? responseData!['data'] as List<dynamic>
              : null;

      if (dataList != null && dataList.isNotEmpty) {
        final List<BgmPreset> presets = dataList
            .map((dynamic item) =>
                BgmPreset.fromJson(item as Map<String, dynamic>))
            .toList();
        emit(state.copyWith(
          presets: presets,
          isLoaded: true,
          isApiFailed: false,
        ));
      } else {
        emit(state.copyWith(
          presets: kFallbackBgmPresets,
          isLoaded: true,
          isApiFailed: true,
        ));
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[BgmPresetBloc] BGM 프리셋 조회 실패: $e');
        debugPrint('[BgmPresetBloc] $stackTrace');
      }
      emit(state.copyWith(
        presets: kFallbackBgmPresets,
        isLoaded: true,
        isApiFailed: true,
      ));
    }
  }

  Future<void> _onPlay(
    PlayBgmPreview event,
    Emitter<BgmPresetState> emit,
  ) async {
    if (state.isApiFailed) return;

    final BgmPreset? preset = state.presets
        .cast<BgmPreset?>()
        .firstWhere((BgmPreset? p) => p!.id == event.presetId, orElse: () => null);

    if (preset == null || preset.url.isEmpty) return;

    // 같은 곡을 다시 누르면 정지
    if (state.playingPresetId == event.presetId) {
      emit(state.copyWith(clearPlayingPresetId: true));
      await _audioPlayer.stop();
      return;
    }

    try {
      // 오디오를 불러오기 전 상태부터 즉시 반영 (빠른 UI 반응성을 위함)
      emit(state.copyWith(playingPresetId: event.presetId));
      
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(preset.url);
      await _audioPlayer.play();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BgmPresetBloc] BGM 재생 실패: $e');
      }
      emit(state.copyWith(clearPlayingPresetId: true));
    }
  }

  Future<void> _onStop(
    StopBgmPreview event,
    Emitter<BgmPresetState> emit,
  ) async {
    await _audioPlayer.stop();
    emit(state.copyWith(clearPlayingPresetId: true));
  }

  @override
  Future<void> close() async {
    await _audioPlayer.dispose();
    return super.close();
  }
}
