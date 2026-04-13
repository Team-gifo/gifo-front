part of 'content_audio_bloc.dart';

class ContentAudioState {
  final bool isPlaying;
  final String? currentUrl;
  final bool isMuted; // 사용자가 수동으로 끈 상태인지

  const ContentAudioState({
    this.isPlaying = false,
    this.currentUrl,
    this.isMuted = false,
  });

  ContentAudioState copyWith({
    bool? isPlaying,
    String? currentUrl,
    bool? isMuted,
  }) {
    return ContentAudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentUrl: currentUrl ?? this.currentUrl,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}
