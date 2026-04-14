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
    on<PreloadContentAudio>(_onPreload);
    on<InitContentAudio>(_onInit);
    on<StopContentAudio>(_onStop);
    on<ToggleContentAudio>(_onToggle);

    // 오디오 상태 리스너 등록
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((
      PlayerState playerState,
    ) {
      // 단순히 playing 플래그뿐만 아니라, 실제로 재생될 준비가 된 상태(ready)이거나 재생 중일 때만 true로 취급
      final bool isPlaying = playerState.playing &&
          (playerState.processingState == ProcessingState.ready ||
              playerState.processingState == ProcessingState.completed);

      // 상태 업데이트 (UI 반영용)
      // 사용자가 수동으로 OFF 시킨 상태(isMuted == true)라면, 예상치 못한 오디오 스트림의 재생 이벤트를 무시하여 엄격하게 OFF를 유지
      if (!state.isMuted && state.isPlaying != isPlaying) {
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

  // BGM URL을 플레이어에 미리 로드만 한다 (재생 시작 X).
  // 사용자 제스처 이전에 호출되어 브라우저 자동 재생 정책을 위반하지 않는다.
  Future<void> _onPreload(
    PreloadContentAudio event,
    Emitter<ContentAudioState> emit,
  ) async {
    if (event.url.isEmpty) return;
    // 이미 같은 URL이 등록되어 있으면 무시
    if (state.currentUrl == event.url) return;

    try {
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.setUrl(event.url);
      // URL 등록 완료: 재생 대기 상태로 표시
      emit(state.copyWith(currentUrl: event.url, isAutoplayBlocked: false));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ContentAudioBloc] BGM 사전 로드 실패: $e');
      }
    }
  }

  Future<void> _onInit(
    InitContentAudio event,
    Emitter<ContentAudioState> emit,
  ) async {
    if (event.url.isEmpty) return;

    try {
      // 이미 Preload로 같은 URL이 등록된 경우: 재생만 즉시 시작
      if (state.currentUrl == event.url) {
        // 사용자가 수동으로 BGM을 끈 상태라면 강제 재생하지 않음
        if (state.isMuted) return;

        await _audioPlayer.play();
        emit(
          state.copyWith(
            isPlaying: true,
            isMuted: false,
            isAutoplayBlocked: false,
          ),
        );
        return;
      }

      // 사용자가 수동으로 끈 상태라면 URL만 등록하고 재생은 하지 않음
      if (state.isMuted) {
        emit(state.copyWith(currentUrl: event.url));
        await _audioPlayer.setLoopMode(LoopMode.one);
        await _audioPlayer.setUrl(event.url);
        return;
      }

      // 새로운 URL인 경우: 로드 후 재생
      emit(
        state.copyWith(
          currentUrl: event.url,
          isMuted: false,
          isAutoplayBlocked: false,
        ),
      );
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.setUrl(event.url);

      await _audioPlayer.play();
      emit(state.copyWith(isPlaying: true, isAutoplayBlocked: false));
    } on PlayerException catch (e) {
      if (kDebugMode) {
        debugPrint('[ContentAudioBloc] 자동 재생 차단 또는 재생 오류: $e');
      }
      emit(state.copyWith(isPlaying: false, isAutoplayBlocked: true));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ContentAudioBloc] BGM 로드/재생 실패: $e');
      }
      emit(state.copyWith(isPlaying: false, isAutoplayBlocked: true));
    }
  }

  Future<void> _onStop(
    StopContentAudio event,
    Emitter<ContentAudioState> emit,
  ) async {
    await _audioPlayer.stop();
    emit(state.copyWith(isPlaying: false, currentUrl: null));
  }

  Future<void> _onToggle(
    ToggleContentAudio event,
    Emitter<ContentAudioState> emit,
  ) async {
    if (state.isPlaying) {
      // 1. 상태를 먼저 즉각적으로 UI에 반영 (빠른 응답성)
      emit(state.copyWith(isPlaying: false, isMuted: true));
      // 2. 이후 실제 오디오 정지 수행
      await _audioPlayer.pause();
    } else {
      // URL이 있는 경우에만 재생 시도
      if (state.currentUrl != null && state.currentUrl!.isNotEmpty) {
        try {
          // 1. 상태를 즉각 반영
          emit(state.copyWith(isPlaying: true, isMuted: false, isAutoplayBlocked: false));
          // 2. 재생 시작
          await _audioPlayer.play();
        } catch (e) {
          if (kDebugMode) {
            debugPrint('[ContentAudioBloc] 수동 재생 실패: $e');
          }
          // 실패 시 원상 복귀
          emit(state.copyWith(isPlaying: false, isMuted: true));
        }
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
