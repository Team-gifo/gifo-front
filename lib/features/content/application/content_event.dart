part of 'content_bloc.dart';

// 콘텐츠 BLoC 이벤트 정의
abstract class ContentEvent {
  const ContentEvent();
}

// 서버 또는 라우터에서 받은 데이터를 상태에 로드
class LoadContentData extends ContentEvent {
  final ContentData data;
  const LoadContentData(this.data);
}

// 콘텐츠 상태 초기화
class ResetContent extends ContentEvent {
  const ResetContent();
}
