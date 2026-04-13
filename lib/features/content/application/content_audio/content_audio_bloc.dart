import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

part 'content_audio_event.dart';
part 'content_audio_state.dart';

class ContentAudioBloc extends Bloc<ContentAudioEvent, ContentAudioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<PlayerState>? _playerStateSubscription;

  ContentAudioBloc() : super(const ContentAudioState()) {
    on<InitContentAudio>(_onInit);
    on<StopContentAudio>(_onStop);
    on<ToggleContentAudio>(_onToggle);

    // 오디오 상태 리스너 등록
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((PlayerState playerState) {
      final bool isPlaying = playerState.playing;
      // 상태 업데이트 (UI 반영용)
      if (state.isPlaying != isPlaying) {
        add(_UpdatePlayingStatus(isPlaying));
      }

      // 무한 루프 설정 (선물 오픈 경험 유지)
      if (playerState.processingState == ProcessingState.completed) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.play();
      }
    });

    // 내부 전용 업데이트 이벤트를 위한 핸들러 (Stream 리스너에서 호출)
    on<_UpdatePlayingStatus>((event, emit) {
      emit(state.copyWith(isPlaying: event.isPlaying));
    });
  }

  Future<void> _onInit(InitContentAudio event, Emitter<ContentAudioState> emit) async {
    if (event.url.isEmpty) return;
    
    // 이미 같은 URL이 설정되어 있으면 무시 (중복 로드 방지)
    if (state.currentUrl == event.url) return;

    try {
      emit(state.copyWith(currentUrl: event.url, isMuted: false));
      
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.setUrl(event.url);
      await _audioPlayer.play();
      
      emit(state.copyWith(isPlaying: true));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ContentAudioBloc] BGM 로드/재생 실패: $e');
      }
    }
  }

  Future<void> _onStop(StopContentAudio event, Emitter<ContentAudioState> emit) async {
    await _audioPlayer.stop();
    emit(state.copyWith(isPlaying: false, currentUrl: null));
  }

  Future<void> _onToggle(ToggleContentAudio event, Emitter<ContentAudioState> emit) async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
      emit(state.copyWith(isPlaying: false, isMuted: true));
    } else {
      // URL이 있는 경우에만 재생 시도
      if (state.currentUrl != null && state.currentUrl!.isNotEmpty) {
        await _audioPlayer.play();
        emit(state.copyWith(isPlaying: true, isMuted: false));
      }
    }
  }

  @override
  Future<void> close() async {
    await _playerStateSubscription?.cancel();
    await _audioPlayer.dispose();
    return super.close();
  }
}

/// 내부 전용: AudioPlayer 상태 변경을 Bloc 상태에 반영하기 위한 이벤트
class _UpdatePlayingStatus extends ContentAudioEvent {
  final bool isPlaying;
  _UpdatePlayingStatus(this.isPlaying);
}
