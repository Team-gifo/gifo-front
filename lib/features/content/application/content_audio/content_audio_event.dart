part of 'content_audio_bloc.dart';

abstract class ContentAudioEvent {
  const ContentAudioEvent();
}

/// BGM 초기화 및 자동 재생 시작
class InitContentAudio extends ContentAudioEvent {
  final String url;
  const InitContentAudio(this.url);
}

/// BGM 정지 (Dispose 시 등)
class StopContentAudio extends ContentAudioEvent {
  const StopContentAudio();
}

/// BGM 재생/일시정지 토글
class ToggleContentAudio extends ContentAudioEvent {
  const ToggleContentAudio();
}
