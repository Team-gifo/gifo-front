part of 'result_bloc.dart';

enum ResultDownloadStatus { idle, loading }

class ResultState {
  final ResultDownloadStatus downloadStatus;

  const ResultState({this.downloadStatus = ResultDownloadStatus.idle});

  ResultState copyWith({ResultDownloadStatus? downloadStatus}) {
    return ResultState(
      downloadStatus: downloadStatus ?? this.downloadStatus,
    );
  }
}
