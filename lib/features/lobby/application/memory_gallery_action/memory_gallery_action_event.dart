part of 'memory_gallery_action_bloc.dart';

abstract class MemoryGalleryActionEvent {}

class ProcessDownloadEvent extends MemoryGalleryActionEvent {
  final List<Map<String, dynamic>> filesInfo;

  ProcessDownloadEvent({required this.filesInfo});
}

class SetLoadingEvent extends MemoryGalleryActionEvent {}
