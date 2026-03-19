import '../model/lobby_data.dart';

// 로비 데이터 요청을 담당하는 repository
// 현재는 더미 데이터를 반환하며, 추후 API 연동 시 이 레이어만 교체하면 됨
class LobbyRepository {
  // 초대 코드에 해당하는 로비 데이터를 반환
  // API 연동 후 : 서버에 code를 보내고 LobbyData를 응답받는 로직으로 교체
  Future<LobbyData?> fetchByCode(String code) async {
    // 더미: 코드 유효성 검증 시뮬레이션
    return LobbyData.getDummyByCode(code);
  }
}
