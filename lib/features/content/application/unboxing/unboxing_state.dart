part of 'unboxing_bloc.dart';

class UnboxingState {
  final String userName;
  final String subTitle;
  final UnboxingContent? unboxingContent;
  final bool isReceived;

  const UnboxingState({
    this.userName = '',
    this.subTitle = '',
    this.unboxingContent,
    this.isReceived = false,
  });

  UnboxingState copyWith({
    String? userName,
    String? subTitle,
    UnboxingContent? unboxingContent,
    bool? isReceived,
  }) {
    return UnboxingState(
      userName: userName ?? this.userName,
      subTitle: subTitle ?? this.subTitle,
      unboxingContent: unboxingContent ?? this.unboxingContent,
      isReceived: isReceived ?? this.isReceived,
    );
  }
}
