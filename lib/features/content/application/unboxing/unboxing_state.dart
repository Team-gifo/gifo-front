part of 'unboxing_bloc.dart';

class UnboxingState {
  final String userName;
  final String subTitle;
  // 공유 링크 및 결과 화면에 사용되는 초대 코드
  final String inviteCode;
  final UnboxingContent? unboxingContent;
  final bool isReceived;

  const UnboxingState({
    this.userName = '',
    this.subTitle = '',
    this.inviteCode = '',
    this.unboxingContent,
    this.isReceived = false,
  });

  UnboxingState copyWith({
    String? userName,
    String? subTitle,
    String? inviteCode,
    UnboxingContent? unboxingContent,
    bool? isReceived,
  }) {
    return UnboxingState(
      userName: userName ?? this.userName,
      subTitle: subTitle ?? this.subTitle,
      inviteCode: inviteCode ?? this.inviteCode,
      unboxingContent: unboxingContent ?? this.unboxingContent,
      isReceived: isReceived ?? this.isReceived,
    );
  }
}
