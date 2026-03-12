import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/content_data.dart';

part 'content_event.dart';
part 'content_state.dart';

// 콘텐츠 영역 상태 관리 BLoC
class ContentBloc extends Bloc<ContentEvent, ContentState> {
  ContentBloc() : super(const ContentState()) {
    on<LoadContentData>(_onLoadContentData);
    on<ResetContent>(_onResetContent);
  }

  // 서버 혹은 라우터를 통해 전달받은 콘텐츠 데이터를 상태에 반영
  void _onLoadContentData(LoadContentData event, Emitter<ContentState> emit) {
    emit(state.copyWith(contentData: event.data, isLoaded: true));
  }

  void _onResetContent(ResetContent event, Emitter<ContentState> emit) {
    emit(const ContentState());
  }
}
