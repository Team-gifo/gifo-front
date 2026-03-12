part of 'unboxing_bloc.dart';

abstract class UnboxingEvent {
  const UnboxingEvent();
}

// 코드 기반 언박싱 데이터 초기화
class InitUnboxing extends UnboxingEvent {
  final String code;
  const InitUnboxing(this.code);
}

// 선물 받기 실행
class ReceiveGift extends UnboxingEvent {
  const ReceiveGift();
}

// 상태 초기화
class ResetUnboxing extends UnboxingEvent {
  const ResetUnboxing();
}
