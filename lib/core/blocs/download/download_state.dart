part of 'download_bloc.dart';

enum DownloadStatus { idle, loading, success, failure }

class DownloadState {
  final DownloadStatus status;
  final String? errorMessage;

  const DownloadState({
    required this.status,
    this.errorMessage,
  });

  factory DownloadState.initial() => const DownloadState(status: DownloadStatus.idle);

  DownloadState copyWith({
    DownloadStatus? status,
    String? errorMessage,
  }) {
    return DownloadState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
