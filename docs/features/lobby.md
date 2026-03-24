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

로비에서 메모리 갤러리 전체 보기 버튼 클릭 시 이동 (`/memory-gallery`).
발신자가 등록한 추억 사진/제목/설명을 그리드 형태로 표시.

### 1. 주요 UI 디자인
- **반응형 컨텐츠**: 데스크톱은 좌측 이미지/우측 피드(6:5), 모바일은 세로 피드 스타일로 구성.
- **인스타그램 감성**: 프로필 헤더, 좋아요 수, 피드 텍스트 등을 배치하여 소셜 미디어와 유사한 친숙한 디자인.
- **가독성 최적화**: 본문 텍스트에는 'WantedSans' 폰트를 사용하여 장문의 메시지도 읽기 편하도록 구현.

### 2. 이미지 다운로드 기능 (Download Modal)
사용자가 소장하고 싶은 추억을 캡처하거나 원본으로 내려받을 수 있는 기능.

**다운로드 옵션:**
- **원본 이미지**: 업로드 당시의 원본 파일 그대로 다운로드.
- **데스크톱 Ver. 캡처**: 1920x1080 해상도의 브라우저 프레임이 입혀진 상태로 캡처 (스크린샷).
- **모바일 Ver. 캡처**: 아이폰 15 Pro 해상도(393x852)에 맞춘 모바일 최적화 프레임으로 캡처.

**일괄 다운로드:**
- '전체 페이지 일괄 다운로드' 선택 시, 위의 옵션들에 해당하는 모든 이미지를 생성하여 **.zip 파일**로 압축하여 한 번에 제공.

**UI/UX 가독성 개선:**
- **모바일**: 하단에서 위로 올라오는 바텀 시트(Bottom Sheet) 형태 (화면의 85% 높이).
- **데스크톱**: 중앙 다이얼로그(Dialog) 형태 (가로 550px).
- **폰트**: 가독성을 위해 옵션 선택 및 버튼 텍스트에 'WantedSans' 적용.

### 3. 기술적 구현 특징
- **BLoC 활용**: `MemoryGalleryActionBloc`을 통해 캡처 대기, 이미지 변환, ZIP 압축 및 다운로드를 비동기로 처리.
- **Screenshot 패키지**: `ScreenshotController`를 사용하여 특정 위젯(Frame)을 지정된 고해상도(Size/PixelRatio)로 렌더링 후 이미지화.
- **FileDownloadHelper**: 웹 환경에서 `HTMLAnchorElement`를 활용한 Base64 기반 브라우저 다운로드 트리거.
