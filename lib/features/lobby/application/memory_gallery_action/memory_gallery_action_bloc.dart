import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/file_download_helper.dart';

part 'memory_gallery_action_event.dart';
part 'memory_gallery_action_state.dart';

class MemoryGalleryActionBloc
    extends Bloc<MemoryGalleryActionEvent, MemoryGalleryActionState> {
  MemoryGalleryActionBloc() : super(MemoryGalleryActionState.initial()) {
    on<ProcessDownloadEvent>(_onProcessDownload);
    on<SetLoadingEvent>((SetLoadingEvent event, Emitter<MemoryGalleryActionState> emit) {
      emit(state.copyWith(status: ActionStatus.loading, errorMessage: null));
    });
  }

  Future<void> _onProcessDownload(
    ProcessDownloadEvent event,
    Emitter<MemoryGalleryActionState> emit,
  ) async {
    final List<Map<String, dynamic>> filesInfo = event.filesInfo;
    if (filesInfo.isEmpty) return;

    emit(state.copyWith(status: ActionStatus.loading, errorMessage: null));

    try {
      if (filesInfo.length == 1) {
        // 단일 파일의 경우 개별 다운로드
        final Map<String, dynamic> singleFile = filesInfo.first;
        final String name = singleFile['name'] as String;
        final Uint8List bytes = singleFile['bytes'] as Uint8List;

        FileDownloadHelper.downloadBytesOnWeb(
          bytes: bytes,
          filename: name,
        );
      } else {
        // 다중 파일의 경우 .zip 압축 처리
        final Archive archive = Archive();

        for (final Map<String, dynamic> info in filesInfo) {
          final String name = info['name'] as String;
          final Uint8List bytes = info['bytes'] as Uint8List;
          archive.addFile(ArchiveFile(name, bytes.length, bytes));
        }

        final List<int>? zipData = ZipEncoder().encode(archive);
        if (zipData == null) {
          throw Exception('ZIP 압축 실패');
        }

        FileDownloadHelper.downloadBytesOnWeb(
          bytes: Uint8List.fromList(zipData),
          filename: 'Gifo_Memory.zip',
          mimeType: 'application/zip',
        );
      }

      emit(state.copyWith(status: ActionStatus.success));
    } catch (e) {
      debugPrint('[MemoryGalleryActionBloc] 처리 에러: $e');
      emit(state.copyWith(
        status: ActionStatus.failure,
        errorMessage: e.toString(),
      ));
    } finally {
      // 짧은 지연 후 idle 상태로 복귀하여 연속 실행 방지/가능하도록 처리
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(status: ActionStatus.idle));
    }
  }
}
