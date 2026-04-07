part of 'gacha_bloc.dart';

abstract class GachaEvent {
  const GachaEvent();
}

// LobbyBloc에서 수신한 LobbyData와 초대 코드를 직접 전달받아 초기화
class InitGacha extends GachaEvent {
  final LobbyData lobbyData;
  // QR 코드 및 공유 링크 생성에 사용되는 초대 코드
  final String inviteCode;
  const InitGacha(this.lobbyData, {this.inviteCode = ''});
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
