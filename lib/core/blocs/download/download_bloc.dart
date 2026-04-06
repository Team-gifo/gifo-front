import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/file_download_helper.dart';

part 'download_event.dart';
part 'download_state.dart';

/// 여러 피처에서 공용으로 사용하는 파일 다운로드 BLoC
///
/// 단일 파일은 직접 다운로드, 다중 파일은 ZIP으로 압축하여 다운로드한다.
/// 현재 사용처: lobby/memory_gallery_view, content/gacha_view (기프티콘 생성)
class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc() : super(DownloadState.initial()) {
    on<ProcessDownloadEvent>(_onProcessDownload);
    on<SetDownloadLoadingEvent>((SetDownloadLoadingEvent event, Emitter<DownloadState> emit) {
      emit(state.copyWith(status: DownloadStatus.loading, errorMessage: null));
    });
  }

  Future<void> _onProcessDownload(
    ProcessDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    final List<Map<String, dynamic>> filesInfo = event.filesInfo;
    if (filesInfo.isEmpty) return;

    emit(state.copyWith(status: DownloadStatus.loading, errorMessage: null));

    try {
      if (filesInfo.length == 1) {
        // 단일 파일 직접 다운로드
        final Map<String, dynamic> singleFile = filesInfo.first;
        final String name = singleFile['name'] as String;
        final Uint8List bytes = singleFile['bytes'] as Uint8List;

        FileDownloadHelper.downloadBytesOnWeb(
          bytes: bytes,
          filename: name,
        );
      } else {
        // 다중 파일 ZIP 압축 후 다운로드
        final Archive archive = Archive();

        for (final Map<String, dynamic> info in filesInfo) {
          final String name = info['name'] as String;
          final Uint8List bytes = info['bytes'] as Uint8List;
          archive.addFile(ArchiveFile(name, bytes.length, bytes));
        }

        final List<int> zipData = ZipEncoder().encode(archive);

        FileDownloadHelper.downloadBytesOnWeb(
          bytes: Uint8List.fromList(zipData),
          filename: event.zipFileName,
          mimeType: 'application/zip',
        );
      }

      emit(state.copyWith(status: DownloadStatus.success));
    } catch (e) {
      debugPrint('[DownloadBloc] 처리 에러: $e');
      emit(state.copyWith(
        status: DownloadStatus.failure,
        errorMessage: e.toString(),
      ));
    } finally {
      // 짧은 지연 후 idle 복귀하여 동일 이벤트 재실행 가능하도록 처리
      await Future<void>.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(status: DownloadStatus.idle));
    }
  }
}
