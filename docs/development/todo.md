# TODO 및 미완성 항목

> 이 문서의 목적: 현재 알려진 미완성 기능, 임시 구현, 추후 개선 필요 항목을 파악한다.

## 서버 연동 (Critical)

### ContentApi 미등록
- **현황:** `lib/features/content/repository/content_api.dart` 파일은 존재하나 GetIt에 미등록
- **영향:** 수신자 컨텐츠 데이터를 현재 더미 데이터로만 조회
- **해결:** `service_locator.dart`에 `ContentApi` 등록 + `LobbyRepository` 실제 API 연동

### LobbyRepository 더미 데이터
- **현황:** `lib/features/lobby/repository/lobby_repository.dart`가 `LobbyData.getDummyByCode()` 반환
- **영향:** 3개의 하드코딩된 코드만 유효 (`helloworld`, `quiz123`, `open123`)
- **해결:** `GET /api/events/{code}` API 호출로 교체
- **참고:** `BLoC`, `View` 레이어 변경 불필요, `LobbyRepository`만 교체

### 초대 코드 URL 검증 미구현
- **현황:** GoRouter의 `redirect`에서 더미 데이터로만 검증
- **영향:** 실제 서버에 존재하는 코드도 `LobbyData.getDummyByCode()`에 없으면 차단
- **해결:** `redirect`를 async로 변경하거나 로비 화면에서 API 검증 후 처리

## 코드 품질

### 임시 테스트 파일
- **파일:** `lib/test_reorder.dart`
- **현황:** 드래그 재정렬 테스트용 임시 파일
- **해결:** 정리 또는 `test/` 폴더로 이동

### 미구현 Core 폴더
다음 폴더들이 placeholder 상태 (파일 없음):
- `lib/core/config/` - 앱 설정 관리
- `lib/core/error/` - 에러 모델/핸들러
- `lib/core/network/` - 네트워크 유틸리티 (인터셉터 등)
- `lib/core/utils/` - 공통 유틸 함수

### GachaBloc 확률 미적용
- **현황:** `GachaItem.percent` 필드가 있으나 추첨 시 균등 랜덤 사용
- **해결:** 가중치 랜덤 알고리즘 구현 (상세: [gacha-logic.md](../business-logic/gacha-logic.md))

## 기능 개선

### 이미지 업로드
- **현황:** 갤러리 아이템 이미지를 `XFile.path`(로컬 파일 경로)로 서버에 전송
- **영향:** 서버에서 이미지 파일을 받을 수 없음 (경로만 전달)
- **해결:** 이미지를 multipart/form-data로 업로드 후 URL을 `image_url`에 설정

### 퀴즈 결과 판정 로직 위치
- **현황:** 성공/실패 판정이 View에서 수행
- **개선:** BLoC에서 처리하고 상태로 노출 (`isSuccess: bool?`)

### flutter_secure_storage 미활용
- **현황:** `pubspec.yaml`에 의존성은 있으나 실제 사용 코드 없음
- **예정:** 사용자 토큰, 세션 저장 시 활용

## 테스트 부재

- `test/` 폴더에 widget_test.dart 기본 파일만 존재
- BLoC 단위 테스트 없음
- 통합 테스트 없음
