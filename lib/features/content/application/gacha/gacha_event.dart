part of 'gacha_bloc.dart';

abstract class GachaEvent {
  const GachaEvent();
}

// 코드 기반 가차 데이터 초기화
class InitGacha extends GachaEvent {
  final String code;
  const InitGacha(this.code);
}

// 캡슐 뽑기 실행
class DrawGacha extends GachaEvent {
  const DrawGacha();
}

// 상태 초기화
class ResetGacha extends GachaEvent {
  const ResetGacha();
}

// 결과 모달 닫기 후 마지막 당첨 아이템 초기화
class ClearLastDrawnItem extends GachaEvent {
  const ClearLastDrawnItem();
}
