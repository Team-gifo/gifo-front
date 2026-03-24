import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:universal_web/web.dart' as web;

class FileDownloadHelper {
  /// 웹에서 Base64 기반 앵커를 생성해 파일 속성으로 브라우저 다운로드 실행
  static void downloadBytesOnWeb({
    required Uint8List bytes,
    required String filename,
    String mimeType = 'application/octet-stream',
  }) {
    if (!kIsWeb) return;

    final String base64String = base64Encode(bytes);
    final web.HTMLAnchorElement anchor =
        web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = 'data:$mimeType;base64,$base64String';
    anchor.download = filename;

    // Body에 추가 후 클릭 트리거, 그 후 바로 제거
    web.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }
}
