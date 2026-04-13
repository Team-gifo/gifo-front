# 개발 완료 기능

> 이 문서의 목적: 현재 구현 완료된 기능 목록을 파악한다.

## 공통 인프라

- [x] Flutter 프로젝트 기본 구조 (Clean Architecture + BLoC)
- [x] GoRouter 전체 라우팅 설정
- [x] GetIt 서비스 로케이터 설정
- [x] Dio HTTP 클라이언트 설정 (LogInterceptor 포함)
- [x] `.env` 환경변수 로드 시스템
- [x] 커스텀 폰트 (PFStardust, PFStardustS, WantedSans)
- [x] 반응형 브레이크포인트 상수 (`app_breakpoints.dart`)
- [x] 앱 색상 팔레트 (`app_colors.dart`)
- [x] 공통 위젯: 컨페티, 그리드 배경 페인터

## 발신자 기능 (선물 포장)

- [x] Step 1: 받는 분 성함 입력 화면
- [x] Step 2: 추억 공유 여부 선택 화면
- [x] Step 3: 메모리 갤러리 편집 화면
  - [x] 아이템 추가/삭제/전체 초기화
  - [x] 이미지 선택 (image_picker)
  - [x] 제목/설명 편집
  - [x] 드래그 재정렬 (ReorderableGridView)
  - [x] 정렬 기능 (등록순, 한글 가나다, 영문 알파벳)
- [x] Step 4: 컨텐츠 타입 선택 (가챠/퀴즈/바로 오픈)
- [x] Step 5a: 가챠 설정 화면 (아이템 목록, 확률, 뽑기 횟수)
- [x] Step 5b: 퀴즈 설정 화면
  - [x] 각 문제별 '제출 횟수(play_limit)' 설정 기능 추가 (기본값 1)
- [x] Step 5c: 바로 오픈 설정 화면
- [x] Step 6: 포장 완료 화면
  - [x] 닉네임 기반 개인화 완료 메시지 적용
- [x] 선물 데이터 서버 전송 (`POST /api/events`)
- [x] ShellRoute로 GiftPackagingBloc 상태 유지
- [x] 포장 완료 후 addgift 재진입 차단
- [x] UI/UX 고도화 및 버그 수정
  - [x] 페이지 이동 시 BGM 자동 중지 로직 구현
  - [x] 로딩 오버레이 다크 테마 및 Material UI 적용
  - [x] 설정 리스트 내 '추가하기' 점선(Dashed) 버튼 스타일 통일
  - [x] 메모리 갤러리 최대 10개 제한 및 반응형 보텀 바 개선
  - [x] 컨텐츠 선택 화면 태블릿/데스크톱 그리드 반응형 최적화

## 수신자 기능 (선물 개봉)

- [x] 로비 화면 (받는 분 성함, 부제목, BGM, 갤러리 미리보기)
- [x] 추억 갤러리 뷰어 화면
- [x] 가챠(캡슐 뽑기) 게임 화면
  - [x] 코드 기반 데이터 초기화 최적화 (중복 API 호출 제거)
  - [x] 뽑기 실행 및 백그라운드 데이터 동기화 (Silent Refresh)
  - [x] 뽑기 히스토리 (타임스탬프, 클립보드 공유 기능)
  - [x] UI/UX 리디자인 (Stitch 캡슐 뽑기 최종본 기반)
    - [x] 다크 테마 + 그리드 배경 적용
    - [x] 데스크톱 3단 레이아웃 / 태블릿 중앙 정렬 / 모바일 전용 스크롤 레이아웃
    - [x] 뽑기 결과 인라인 모달 처리 (`gacha_result_modal.dart`)
    - [x] 위젯 분리 구조 (`gacha_widgets.dart`)
    - [x] 머신 흔들림 애니메이션 + DRAW NOW 버튼 펄스 애니메이션
    - [x] 캡슐 물리 및 적재 로직 (18개 고정, 68px, 헥스 그리드 방식)
    - [x] 가챠 머신 프리미엄 디자인 (유리 돔, 네온 글로우, 메탈릭 림)
    - [x] 캡슐 디자인 최적화 (ClipOval + 외곽선 잘림 방지)
    - [x] 공용 뱃지(`GachaRemainingBadge`) 분리 및 기기별 최적 위치 배치
    - [x] 경품 목록 빈 상태(Empty State) 디자인 반영
- [x] 퀴즈 게임 화면
  - [x] 서버 API 연동 (`POST /quiz/answer`, `POST /quiz/result`)
  - [x] 서버 상태 동기화 (진행된 문제 인덱스 및 남은 기회 유지)
  - [x] Skeletonizer 기반 이미지 로딩 UX 개선
  - [x] 정답/오답 애니메이션 및 입력 필드 초기화 경쟁 상태 해결
  - [x] 모든 문제 완료 시 결과 API 자동 조회 및 결과창 이동
- [x] 바로 오픈(언박싱) 화면
  - [x] 서버 API 연동 (`ContentRepository.openGift`)
  - [x] `LobbyBloc` 기반 자동 데이터 동기화 (가챠/퀴즈 패턴 적용)
  - [x] `Skeletonizer` 기반 네트워크 이미지 로딩 UX 개선
  - [x] 개봉 버튼 로딩 상태(`isOpening`) 및 중복 클릭 방지 처리
  - [x] 애니메이션 연출 (봉투 낙하 + 폭발 + 타이핑 효과)
  - [x] 이미지 부재 시 레이아웃 최적화 (배경 이미지 비활성화 및 설명 텍스트 중앙 배치)
  - [x] 개봉 완료 시 `ResultView` 인라인 렌더링 전환 로직
- [x] 공용 결과 화면 (`ResultView`)
  - [x] 퀴즈 및 언박싱 뷰에서 인라인 렌더링 방식으로 아키텍처 개선
  - [x] ResultBloc 전환 (코드 기반 스크린샷 캡쳐 로직 구현)
  - [x] 결과 팝업 애니메이션 오픈 효과 적용
  - [x] 텍스트 타이핑 효과 + 시차 폭죽 애니메이션 반영
  - [x] 다운로드 및 공유 기능 재구조화 (inviteCode 활용)
- [x] 메인 로고 클릭 내비게이션 기능 (로비, 퀴즈, 결과 뷰 연동)
- [x] 선물 오픈 플로우 이미지 처리 고도화 (`GiftImageWidget`)
  - [x] 서버 이미지 URL이 공백인 경우 `default_box.png` 대체 이미지 표시
  - [x] 네트워크 에러 발생 시 "이미지를 받아오지 못했습니다" 위젯 표시
  - [x] 적용 범위: ResultView, UnboxingView, GachaResultModal, GachaHistoryPanel, GachaPrizeListPanel

## URL 및 진입 처리

- [x] 공유 가능한 초대 URL (`/gift/code/:code`)
- [x] 초대 코드 유효성 검증 (라우터 redirect)
- [x] 잘못된 코드 진입 시 홈 리다이렉트 + 토스트
- [x] 더미 코드 3개 (`helloworld`, `quiz123`, `open123`)

## 메인 화면

- [x] 홈 랜딩 화면
- [x] 선물 포장하기 시작 모달
- [x] 초대 코드 입력 모달
- [x] 메인 화면 애니메이션 이미지
- [x] 검색 엔진 최적화 (SEO) 시스템 구축
  - [x] `robots.txt` & `sitemap.xml` (Domain: `gifo.co.kr`)
  - [x] HTML Meta Tags (Description, Keywords, OG Tags, Canonical)
  - [x] `SeoText` & `SeoImage` DOM 주입 위젯 구현 및 적용
- [x] 데스크톱 레이아웃 디테일 개선 (Section 여백 조정)
