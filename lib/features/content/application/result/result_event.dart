part of 'result_bloc.dart';

sealed class ResultEvent {
  const ResultEvent();
}

// 기프티콘 이미지 캡쳐 및 다운로드 요청 이벤트
class DownloadGifticonEvent extends ResultEvent {
  final BuildContext context;
  final String itemName;
  final String imageUrl;
  final String userName;
  final String inviteCode;

  const DownloadGifticonEvent({
    required this.context,
    required this.itemName,
    required this.imageUrl,
    required this.userName,
    required this.inviteCode,
  });
}
