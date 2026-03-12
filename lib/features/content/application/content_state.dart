part of 'content_bloc.dart';

// 콘텐츠 BLoC 상태 정의
class ContentState {
  final ContentData? contentData;
  final bool isLoaded;

  const ContentState({this.contentData, this.isLoaded = false});

  ContentState copyWith({ContentData? contentData, bool? isLoaded}) {
    return ContentState(
      contentData: contentData ?? this.contentData,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}
