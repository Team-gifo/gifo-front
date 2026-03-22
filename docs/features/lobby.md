# 로비 기능 (Lobby)

> 이 문서의 목적: 수신자가 초대 코드로 입장하는 로비 화면, 코드 검증 흐름, 컨텐츠 진입을 이해한다.

## 라우트

| 라우트 | 설명 |
|--------|------|
| `/gift/code/:code` | 공유 URL로 직접 접근 (주요 진입 경로) |
| `/lobby` | 레거시 - 앱 내부에서 extra로 code 전달 |
| `/memory-gallery` | 수신자용 추억 갤러리 별도 화면 |

## 파일 목록

| 파일 | 역할 |
|------|------|
| `lib/features/lobby/presentation/views/lobby_view.dart` | 로비 메인 화면 |
| `lib/features/lobby/presentation/views/memory_gallery_view.dart` | 추억 갤러리 뷰어 |
| `lib/features/lobby/application/lobby_bloc.dart` | 코드 검증 BLoC |
| `lib/features/lobby/model/lobby_data.dart` | 더미 데이터 + 코드 조회 |
| `lib/features/lobby/repository/lobby_repository.dart` | 데이터 레이어 (추후 API 연동) |

## LobbyView

수신자가 보는 선물 정보 화면:
- 발신자가 설정한 받는 분 성함, 부제목, BGM, 메모리 갤러리 미리보기 표시
- "시작" 버튼 클릭 → 컨텐츠 타입에 따라 적절한 화면으로 이동

**컨텐츠 타입별 이동:**

| 컨텐츠 타입 | 이동 경로 |
|------------|-----------|
| gacha | `context.go('/content/gacha', extra: code)` |
| quiz | `context.go('/content/quiz', extra: code)` |
| unboxing | `context.go('/content/unboxing', extra: code)` |

## 코드 검증 흐름

```
사용자가 /gift/code/:code 접근
    ↓
GoRouter.redirect() 실행
    ↓
LobbyData.getDummyByCode(code) 조회
    ↓
null이면 → _shouldShowInvalidCodeToast = true → '/' 리다이렉트
    ↓
유효하면 → LobbyView 렌더링
```

자세한 검증 로직: [business-logic/lobby-validation.md](../business-logic/lobby-validation.md)

## LobbyData (현재 더미 데이터)

**파일:** `lib/features/lobby/model/lobby_data.dart`

현재 세 개의 더미 코드가 하드코딩됨:

| 코드 | 컨텐츠 타입 |
|------|------------|
| `helloworld` | gacha (캡슐 뽑기) |
| `quiz123` | quiz (퀴즈) |
| `open123` | unboxing (바로 오픈) |

추후 실제 서버 API와 연동 시 `LobbyRepository.fetchByCode(code)`를 교체하면 됨.

## MemoryGalleryView

로비에서 메모리 갤러리 전체 보기 버튼 클릭 시 이동 (`/memory-gallery`).
발신자가 등록한 추억 사진/제목/설명을 그리드 형태로 표시.
