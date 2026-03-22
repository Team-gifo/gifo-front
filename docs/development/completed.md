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
- [x] Step 5c: 바로 오픈 설정 화면
- [x] Step 6: 포장 완료 화면
- [x] 선물 데이터 서버 전송 (`POST /api/events`)
- [x] ShellRoute로 GiftPackagingBloc 상태 유지
- [x] 포장 완료 후 addgift 재진입 차단

## 수신자 기능 (선물 개봉)

- [x] 로비 화면 (받는 분 성함, 부제목, BGM, 갤러리 미리보기)
- [x] 추억 갤러리 뷰어 화면
- [x] 가챠(캡슐 뽑기) 게임 화면
  - [x] 코드 기반 데이터 초기화
  - [x] 뽑기 실행 (랜덤 선택)
  - [x] 뽑기 히스토리 (타임스탬프 포함)
- [x] 퀴즈 게임 화면
  - [x] 코드 기반 데이터 초기화
  - [x] 정답 제출 및 채점
  - [x] 라이프 시스템
  - [x] 성공/실패 판정
- [x] 바로 오픈(언박싱) 화면
- [x] 공용 결과 화면 (`/content/result`)

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
