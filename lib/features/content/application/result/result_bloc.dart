import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/blocs/download/download_bloc.dart';
import '../../../content/presentation/widgets/gifticon_frame.dart';

part 'result_event.dart';
part 'result_state.dart';

// 결과 화면 다운로드 로직 담당 BLoC
// 스크린샷 캡쳐 후 DownloadBloc에 위임한다
class ResultBloc extends Bloc<ResultEvent, ResultState> {
  ResultBloc() : super(const ResultState()) {
    on<DownloadGifticonEvent>(_onDownloadGifticon);
  }

  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _onDownloadGifticon(
    DownloadGifticonEvent event,
    Emitter<ResultState> emit,
  ) async {
    emit(state.copyWith(downloadStatus: ResultDownloadStatus.loading));

    await Future<void>.delayed(const Duration(milliseconds: 300));

    final String qrUrl = '${Uri.base.origin}/gift/code/${event.inviteCode}';
    final String issueDate = DateTime.now().toString().substring(0, 10);

    try {
      final Uint8List imageBytes = await _screenshotController
          .captureFromWidget(
            GifticonFrame(
              itemName: event.itemName,
              imageUrl: event.imageUrl,
              recipientName: event.userName,
              issueDate: issueDate,
              inviteCode: event.inviteCode,
              qrUrl: qrUrl,
            ),
            delay: const Duration(milliseconds: 800),
          );

      if (event.context.mounted) {
        final String fileName = 'gifticon_${event.itemName}_$issueDate.png';
        event.context.read<DownloadBloc>().add(
          ProcessDownloadEvent(
            filesInfo: <Map<String, dynamic>>[
              <String, dynamic>{'name': fileName, 'bytes': imageBytes},
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('[ResultBloc] 캡쳐 오류: $e');
    } finally {
      emit(state.copyWith(downloadStatus: ResultDownloadStatus.idle));
    }
  }
}
