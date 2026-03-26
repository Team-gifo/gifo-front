/// [Deprecated] 이 파일은 하위 호환을 위해 유지됩니다.
/// 공용 다운로드 BLoC은 'core/blocs/download/download_bloc.dart'를 사용하세요.
library;

import 'package:gifo/core/blocs/download/download_bloc.dart';

export '../../../../core/blocs/download/download_bloc.dart'
    show
        DownloadBloc,
        ProcessDownloadEvent,
        SetDownloadLoadingEvent,
        DownloadStatus,
        DownloadState;

// 기존 코드와의 호환성을 위한 타입 별칭
typedef MemoryGalleryActionBloc = DownloadBloc;
typedef MemoryGalleryActionState = DownloadState;
typedef ActionStatus = DownloadStatus;
