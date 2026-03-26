part of 'download_bloc.dart';

abstract class DownloadEvent {
  const DownloadEvent();
}

/// 파일 다운로드 실행 이벤트
class ProcessDownloadEvent extends DownloadEvent {
  final List<Map<String, dynamic>> filesInfo;

  /// 다중 파일 다운로드 시 생성될 ZIP 파일 이름
  final String zipFileName;

  const ProcessDownloadEvent({
    required this.filesInfo,
    this.zipFileName = 'Gifo_Download.zip',
  });
}

/// 로딩 상태로 즉시 전환하는 이벤트 (캡쳐 시작 전 UI 피드백용)
class SetDownloadLoadingEvent extends DownloadEvent {
  const SetDownloadLoadingEvent();
}
