part of 'content_audio_bloc.dart';

class ContentAudioState {
  final bool isPlaying;
  final String? currentUrl;
  final bool isMuted;           // 사용자가 수동으로 끈 상태인지
  final bool isAutoplayBlocked; // 브라우저 자동 재생 정책으로 차단된 상태인지

  const ContentAudioState({
    this.isPlaying = false,
    this.currentUrl,
    this.isMuted = false,
    this.isAutoplayBlocked = false,
  });

  ContentAudioState copyWith({
    bool? isPlaying,
    String? currentUrl,
    bool? isMuted,
    bool? isAutoplayBlocked,
  }) {
    return ContentAudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentUrl: currentUrl ?? this.currentUrl,
      isMuted: isMuted ?? this.isMuted,
      isAutoplayBlocked: isAutoplayBlocked ?? this.isAutoplayBlocked,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContentAudioState &&
        other.isPlaying == isPlaying &&
        other.currentUrl == currentUrl &&
        other.isMuted == isMuted &&
        other.isAutoplayBlocked == isAutoplayBlocked;
  }

  @override
  int get hashCode {
    return Object.hash(
      isPlaying,
      currentUrl,
      isMuted,
      isAutoplayBlocked,
    );
  }
}
