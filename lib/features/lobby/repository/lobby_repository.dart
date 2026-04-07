import 'package:gifo/features/lobby/model/lobby_response.dart';

import '../model/lobby_data.dart';
import 'lobby_api.dart';

// 로비 데이터 요청을 담당하는 repository
// LobbyApi(Retrofit)를 통해 실제 서버에서 이벤트 데이터를 조회한다
class LobbyRepository {
  final LobbyApi _api;

  LobbyRepository(this._api);

  // 초대 코드(eventUrl)에 해당하는 이벤트 데이터를 서버에서 조회
  // 서버가 정상 응답을 반환하면 LobbyData를, 그렇지 않으면 null을 반환
  Future<LobbyData?> fetchByCode(String code) async {
    final LobbyResponse response = await _api.getEvent(code);

    // 서버 응답 코드가 'SUCCESS'이고 data가 존재할 때만 유효 처리
    if (response.data != null) {
      return response.data;
    }
    return null;
  }
}
