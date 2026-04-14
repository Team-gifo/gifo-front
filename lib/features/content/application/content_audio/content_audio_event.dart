part of 'content_audio_bloc.dart';

abstract class ContentAudioEvent {
  const ContentAudioEvent();
}

/// BGM URL을 플레이어에 등록만 하고 재생은 시작하지 않음
/// (브라우저 자동 재생 정책 대응: 사용자 제스처 이전 단계에서 호출)
class PreloadContentAudio extends ContentAudioEvent {
  final String url;
  const PreloadContentAudio(this.url);
}

/// 사용자 제스처(버튼 클릭) 이후 BGM 재생을 시작
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
