part of 'memory_gallery_action_bloc.dart';

enum ActionStatus { idle, loading, success, failure }

class MemoryGalleryActionState {
  final ActionStatus status;
  final String? errorMessage;

  const MemoryGalleryActionState({
    this.status = ActionStatus.idle,
    this.errorMessage,
  });

  factory MemoryGalleryActionState.initial() =>
      const MemoryGalleryActionState();

  MemoryGalleryActionState copyWith({
    ActionStatus? status,
    String? errorMessage,
  }) {
    return MemoryGalleryActionState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
