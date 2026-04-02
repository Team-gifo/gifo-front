import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../../core/blocs/download/download_bloc.dart';
import '../../model/lobby_data.dart';

class MemoryGalleryView extends StatefulWidget {
  final String code;

  const MemoryGalleryView({super.key, required this.code});

  @override
  State<MemoryGalleryView> createState() => _MemoryGalleryViewState();
}

class _MemoryGalleryViewState extends State<MemoryGalleryView> {
  final PageController _pageController = PageController();
  final ScreenshotController _screenshotController = ScreenshotController();
  int _currentPage = 0;
  bool _isLastPageReached = false;

  bool _dlOriginal = true;
  bool _dlDesktop = false;
  bool _dlMobile = false;
  bool _dlAllPages = false; // 모든 페이지 일괄 다운로드 여부

  late LobbyData lobbyData;
  late List<GalleryItem> _galleryItems;
  late List<int> _likeCounts;

  @override
  void initState() {
    super.initState();
    // 로비 데이터를 불러와 갤러리 리스트 초기화
    lobbyData = LobbyData.getDummyByCode(widget.code)!;
    _galleryItems = lobbyData.gallery;

    // 만약 갤러리 아이템이 1개 이하라면 처음부터 마지막 페이지로 간주
    if (_galleryItems.length <= 1) {
      _isLastPageReached = true;
    }

    final math.Random random = math.Random();
    // 1 ~ 99999 사이 랜덤 숫자 생성
    _likeCounts = List.generate(
      _galleryItems.length,
      (_) => random.nextInt(99999) + 1,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onEnterPressed() {
    if (lobbyData.content != null) {
      if (lobbyData.content!.gacha != null) {
        context.push('/content/gacha', extra: widget.code);
      } else if (lobbyData.content!.quiz != null) {
        context.push('/content/quiz', extra: widget.code);
      } else if (lobbyData.content!.unboxing != null) {
        // context.push('/content/unboxing', extra: widget.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;

    // 모바일 환경으로 간주할 최대 넓이를 태블릿 기준(768px 미만)까지 상향 (가로 폭이 좁은 모든 환경 대응)
    final bool isMobileOrSmall = screenWidth < AppBreakpoints.tablet;
    final bool isTablet =
        screenWidth >= AppBreakpoints.tablet &&
        screenWidth < AppBreakpoints.desktop; // 768px ~ 1024px 미만을 태블릿으로 간주
    final bool isDesktop =
        screenWidth >= AppBreakpoints.desktop; // 1024px 이상부터 데스크톱 가로 배율 적용

    // 모바일/세로형 구조는 상하(Column), 데스크톱과 태블릿은 좌우(Row) 배치 적용
    final bool isColumnLayout = isMobileOrSmall;

    final double titleFontSize = isDesktop ? 42 : (isTablet ? 36 : 28);
    final double descFontSize = isDesktop ? 22 : (isTablet ? 20 : 18);
    final double paddingHorizontal = isDesktop
        ? 80.0 // 데스크톱 여백 소폭 상향
        : (isTablet ? 48.0 : 16.0); // 모바일은 여백을 줄여 피드 이미지 확보

    return Title(
      title: 'Happy Birthday, ${lobbyData.user} | Gifo',
      color: Colors.black,
      child: Scaffold(
        backgroundColor: AppColors.darkBg,
        // 기존 AppBar를 제거하고 본문에 직관적으로 배치
        body: SafeArea(
          child: BlocListener<DownloadBloc, DownloadState>(
            listener: (context, state) {
              if (state.status == DownloadStatus.success) {
                toastification.show(
                  context: context,
                  title: const Text('다운로드 완료!'),
                  type: ToastificationType.success,
                  autoCloseDuration: const Duration(seconds: 3),
                  alignment: Alignment.topCenter,
                );
              } else if (state.status == DownloadStatus.failure) {
                toastification.show(
                  context: context,
                  title: const Text('다운로드 중 오류가 발생했습니다.'),
                  description: Text(state.errorMessage ?? ''),
                  type: ToastificationType.error,
                  autoCloseDuration: const Duration(seconds: 3),
                  alignment: Alignment.topCenter,
                );
              }
            },
            child: Stack(
              children: <Widget>[
                // 1. 배경 그리드 패턴 추가
                Positioned.fill(
                  child: CustomPaint(painter: GridBackgroundPainter()),
                ),
                // 2. 상단 타이틀 로고 및 다운로드 버튼 배치
                Positioned(
                  top: isMobileOrSmall ? 8 : 12,
                  left: paddingHorizontal,
                  right: paddingHorizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            final Uri homeUri = Uri.base.resolve('/');
                            if (await canLaunchUrl(homeUri)) {
                              await launchUrl(
                                homeUri,
                                webOnlyWindowName: '_blank',
                              );
                            } else {
                              if (context.mounted) context.go('/');
                            }
                          },
                          child: Image.asset(
                            'assets/images/title_logo.png',
                            height: isMobileOrSmall ? 48 : 80,
                            color: Colors.white, // 통일감 있는 색상 유지
                          ),
                        ),
                      ),
                      // 상단 배포를 위한 다운로드 버튼 (데스크톱: 텍스트+아이콘, 모바일: 아이콘)
                      if (isMobileOrSmall)
                        IconButton(
                          onPressed: _showDownloadModal,
                          icon: const Icon(
                            Icons.file_download_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                        )
                      else
                        TextButton.icon(
                          onPressed: _showDownloadModal,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.neonPurple,
                            backgroundColor: AppColors.neonPurple,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.download,
                            size: 20,
                            color: Colors.white,
                          ),
                          label: const Text(
                            '추억 이미지 저장하기',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'PFStardust',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // 3. 메인 콘텐츠 (이미지부 / 텍스트·버튼부 분리 배치)
                Positioned.fill(
                  top: isMobileOrSmall ? 64 : 100, // 패딩(상단 로고 높이 + 여백 확보)
                  bottom: 0, // 하단은 padding으로만 조절하도록 변경. 하단까지 스크롤 자연스럽게 가기 위함.
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      paddingHorizontal,
                      24.0,
                      paddingHorizontal,
                      isMobileOrSmall ? 0 : 24.0, // 데스크톱은 하단 여백 부여
                    ),
                    child: isColumnLayout
                        ? _buildColumnLayout(
                            titleFontSize,
                            descFontSize,
                            true,
                            false, // isCapture: false
                          )
                        : _buildRowLayout(
                            titleFontSize,
                            descFontSize,
                            false,
                            false, // isCapture: false
                          ),
                  ),
                ),

                // 4. 처리 중일 경우 오버레이 (다이얼로그 외의 전체 컴포넌트 커버)
                Positioned.fill(
                  child: BlocBuilder<DownloadBloc, DownloadState>(
                    builder: (context, state) {
                      if (state.status == DownloadStatus.loading) {
                        return Container(
                          color: Colors.black.withValues(alpha: 0.5),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  color: AppColors.neonPurple,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '다운로드 중..',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'PFStardust',
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 위젯 분리: 이미지 슬라이드 영역 ---
  Widget _buildImageSection(bool isDesktop) {
    return Stack(
      clipBehavior: Clip.none, // 이미지 영역 밖으로 화살표 버튼이 배치될 수 있도록 허용
      children: <Widget>[
        PageView.builder(
          controller: _pageController,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: <PointerDeviceKind>{
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.trackpad,
            },
          ),
          onPageChanged: (int index) {
            setState(() {
              _currentPage = index;
              // 마지막 슬라이드 도달 시 버튼 활성화
              if (index == _galleryItems.length - 1) {
                _isLastPageReached = true;
              }
            });
          },
          itemCount: _galleryItems.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildImageContent(index, isDesktop);
          },
        ),
        // 좌측 이동 버튼
        if (isDesktop && _currentPage > 0)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        // 우측 이동 버튼
        if (isDesktop && _currentPage < _galleryItems.length - 1)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageContent(int index, bool isDesktop) {
    final GalleryItem item = _galleryItems[index];
    return Padding(
      // 데스크톱 환경에서는 좌우 화살표 공간 확보를 위해 패딩 추가
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64.0 : 0.0),
      child: CustomPaint(
        painter: PixelShadowPainter(
          offset: const Offset(8, 8),
          color: Colors.black.withOpacity(0.8),
          pixelSize: 4.0,
        ),
        child: ClipPath(
          clipper: PixelCornerClipper(pixelSize: 4.0),
          child: Container(
            color: Colors.white, // 흰색 픽셀 테두리
            padding: const EdgeInsets.all(4.0), // 테두리 두께
            child: ClipPath(
              clipper: PixelCornerClipper(
                pixelSize: 4.0,
              ), // 안쪽 테두리에 맞춰 동일한 픽셀 곡선
              child: Container(
                color: Colors.black, // 이미지와 픽셀 사이 여백 공간 색상
                padding: const EdgeInsets.all(16.0), // 요청하신 '약간의 여백' 공간
                child: Image.asset(
                  item.imageUrl,
                  fit: BoxFit.cover, // 빈틈 없이 조절
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- 인스타그램 헤더 영역 ---
  Widget _buildInstagramHeader(double titleFontSize, {int? overrideIndex}) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(2), // 테두리와 이미지 사이의 간격 추가
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.neonPurple, width: 2),
          ),
          child: Container(
            width: 40, // 32 -> 40 사이즈 상향
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/icons/app_icon.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Text(
          lobbyData.user,
          style: TextStyle(
            fontFamily: 'PFStardust',
            fontSize: titleFontSize * 0.75, // 가독성 향상
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        const Icon(Icons.more_horiz, color: Colors.white),
      ],
    );
  }

  // --- 인스타그램 액션 버튼 아이콘 ---
  Widget _buildActionRow() {
    return Row(
      children: <Widget>[
        const Icon(Icons.favorite, color: Colors.red, size: 28),
        const SizedBox(width: 16),
        const Icon(Icons.mode_comment_outlined, color: Colors.white, size: 28),
        const SizedBox(width: 16),
        const Icon(Icons.send_outlined, color: Colors.white, size: 28),
        const Spacer(),
        const Icon(Icons.bookmark_border, color: Colors.white, size: 28),
      ],
    );
  }

  void _showDownloadModal() {
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent, // 배경을 투명하게 설정
        isScrollControlled: true, // 모달이 전체 화면을 차지할 수 있도록
        builder: (BuildContext ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85, // 높이 상향
                ),
                padding: const EdgeInsets.all(28.0),
                decoration: const BoxDecoration(
                  color: AppColors.darkBg,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 32),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download_for_offline,
                            color: AppColors.neonPurple,
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            '이미지 다운로드',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'PFStardust',
                              fontSize: 24, // 20 -> 24 상향
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildModalContent(setModalState),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                '취소',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 16,
                                  fontFamily: 'WantedSans',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.neonPurple,
                                disabledBackgroundColor: Colors.white12,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              onPressed:
                                  (!_dlOriginal && !_dlDesktop && !_dlMobile)
                                  ? null
                                  : () {
                                      Navigator.pop(ctx);
                                      _executeDownload();
                                    },
                              child: const Text(
                                '다운로드 시작',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'WantedSans',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return AlertDialog(
                backgroundColor: AppColors.darkBg,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                titlePadding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
                title: const Row(
                  children: [
                    Icon(
                      Icons.download_outlined,
                      color: AppColors.neonPurple,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      '다운로드 옵션',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PFStardust',
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                content: SizedBox(
                  width: 550, // 450 -> 550 상향
                  child: SingleChildScrollView(
                    child: _buildModalContent(setModalState),
                  ),
                ),
                actionsPadding: const EdgeInsets.fromLTRB(0, 0, 32, 32),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'WantedSans',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: (!_dlOriginal && !_dlDesktop && !_dlMobile)
                        ? null
                        : () {
                            Navigator.pop(ctx);
                            _executeDownload();
                          },
                    child: const Text(
                      '다운로드',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'WantedSans',
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  Widget _buildModalContent(StateSetter setModalState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 그룹 1: 다운로드 대상
        _buildOptionGroup(
          title: '다운로드 범위',
          icon: Icons.filter_center_focus_outlined,
          children: [
            RadioListTile<bool>(
              title: const Text(
                '현재 페이지만',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'WantedSans',
                ),
              ),
              value: false,
              groupValue: _dlAllPages,
              onChanged: (bool? val) => setModalState(() => _dlAllPages = val!),
              activeColor: AppColors.neonPurple,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              dense: false,
            ),
            const Divider(
              color: Colors.white10,
              height: 1,
              indent: 12,
              endIndent: 12,
            ),
            RadioListTile<bool>(
              title: Text(
                '전체 페이지 (${_galleryItems.length}개 일괄 다운로드)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'WantedSans',
                ),
              ),
              value: true,
              groupValue: _dlAllPages,
              onChanged: (bool? val) => setModalState(() => _dlAllPages = val!),
              activeColor: AppColors.neonPurple,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              dense: false,
            ),
          ],
        ),
        const SizedBox(height: 24),
        // 그룹 2: 포함할 포맷
        _buildOptionGroup(
          title: '이미지 포맷 선택',
          icon: Icons.collections_outlined,
          children: [
            CheckboxListTile(
              title: const Text(
                '원본 이미지',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'WantedSans',
                ),
              ),
              subtitle: const Text(
                '업로드된 원본 해상도 그대로 저장',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontFamily: 'WantedSans',
                ),
              ),
              value: _dlOriginal,
              onChanged: (bool? val) =>
                  setModalState(() => _dlOriginal = val ?? false),
              activeColor: AppColors.neonPurple,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            const Divider(
              color: Colors.white10,
              height: 1,
              indent: 12,
              endIndent: 12,
            ),
            CheckboxListTile(
              title: const Text(
                '데스크톱 Ver. 프레임 캡처 (1920x1080)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'WantedSans',
                ),
              ),
              subtitle: const Text(
                '데스크톱 웹 가로 배율 프레임 적용',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontFamily: 'WantedSans',
                ),
              ),
              value: _dlDesktop,
              onChanged: (bool? val) =>
                  setModalState(() => _dlDesktop = val ?? false),
              activeColor: AppColors.neonPurple,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            const Divider(
              color: Colors.white10,
              height: 1,
              indent: 12,
              endIndent: 12,
            ),
            CheckboxListTile(
              title: const Text(
                '모바일 Ver. 프레임 캡처',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'WantedSans',
                ),
              ),
              subtitle: const Text(
                '모바일 웹 해상도 프레임 적용',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontFamily: 'WantedSans',
                ),
              ),
              value: _dlMobile,
              onChanged: (bool? val) =>
                  setModalState(() => _dlMobile = val ?? false),
              activeColor: AppColors.neonPurple,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ],
        ),
        if ([_dlOriginal, _dlDesktop, _dlMobile].where((bool e) => e).length >=
                2 ||
            _dlAllPages)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.neonPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.neonPurple.withValues(alpha: 0.2),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.neonPurple,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '이미지가 2개 이상 선택되어 .zip 파일로 압축되어 제공됩니다.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'WantedSans',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // --- 옵션 그룹화를 위한 헬퍼 위젯 ---
  Widget _buildOptionGroup({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.white54, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontFamily: 'WantedSans',
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Future<void> _executeDownload() async {
    final DownloadBloc bloc = context.read<DownloadBloc>();
    final List<Map<String, dynamic>> filesInfo = [];

    if (!_dlOriginal && !_dlDesktop && !_dlMobile) {
      toastification.show(
        context: context,
        title: const Text('선택된 항목이 없습니다.'),
        type: ToastificationType.warning,
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topCenter,
      );
      return;
    }

    // 로딩 시작
    bloc.add(const SetDownloadLoadingEvent());

    // UI 비동기 갱신을 위한 대기
    await Future.delayed(const Duration(milliseconds: 300));
    if (!context.mounted) return;

    final List<int> targetIndices = _dlAllPages
        ? List.generate(_galleryItems.length, (int i) => i)
        : [_currentPage];

    for (final int index in targetIndices) {
      final GalleryItem item = _galleryItems[index];
      final String safeTitle = item.title.replaceAll(
        RegExp(r'[\\/:*?"<>|]'),
        '_',
      );

      // 1. 원본 이미지
      if (_dlOriginal) {
        try {
          final ByteData data = await rootBundle.load(item.imageUrl);
          filesInfo.add({
            'name': 'Original_${index + 1}_$safeTitle.png',
            'bytes': data.buffer.asUint8List(),
          });
        } catch (e) {
          debugPrint('Original image load error at $index: $e');
        }
      }

      // 2. 데스크톱 캡처 (1920x1080 고정 해상도)
      if (_dlDesktop) {
        try {
          final Uint8List? desktopBytes = await _screenshotController
              .captureFromWidget(
                _buildCaptureFrame(isDesktop: true, pageIndex: index),
                // delay: const Duration(milliseconds: 500), // Removed delay
                context: context,
                targetSize: const Size(1920, 1080),
              );
          if (desktopBytes != null) {
            filesInfo.add({
              'name': 'Desktop_Frame_${index + 1}_$safeTitle.png',
              'bytes': desktopBytes,
            });
          }
        } catch (e) {
          debugPrint('Desktop capture error at index $index: $e');
        }
      }

      // 3. 모바일 캡처 (아이폰 15 프로 기준 393x852 layout)
      if (_dlMobile) {
        try {
          final Uint8List? mobileBytes = await _screenshotController
              .captureFromWidget(
                _buildCaptureFrame(isDesktop: false, pageIndex: index),
                // delay: const Duration(milliseconds: 500), // Removed delay
                context: context,
                targetSize: const Size(393, 852),
                pixelRatio: 3.0, // 고해상도 출력
              );
          if (mobileBytes != null) {
            filesInfo.add({
              'name': 'Mobile_Frame_${index + 1}_$safeTitle.png',
              'bytes': mobileBytes,
            });
          }
        } catch (e) {
          debugPrint('Mobile capture error at index $index: $e');
        }
      }
    }

    if (filesInfo.isNotEmpty) {
      bloc.add(ProcessDownloadEvent(filesInfo: filesInfo));
    } else {
      bloc.add(const SetDownloadLoadingEvent()); // 로딩 상태 해제 (캡쳐 실패 시)
    }
  }

  Widget _buildCaptureFrame({required bool isDesktop, required int pageIndex}) {
    final double titleFontSize = isDesktop ? 36 : 26;
    final double descFontSize = isDesktop ? 20 : 16;
    final double width = isDesktop ? 1920 : 393;
    final double height = isDesktop ? 1080 : 852; // 고정된 디바이스 높이 유지

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, height)),
        child: Scaffold(
          backgroundColor: AppColors.darkBg,
          body: SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: GridBackgroundPainter()),
                ),
                if (isDesktop)
                  Positioned(
                    top: 12,
                    left: 64.0,
                    right: null,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/title_logo.png',
                        height: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                Positioned.fill(
                  top: isDesktop ? 100 : 16,
                  bottom: 0,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isDesktop ? 64.0 : 16.0,
                      isDesktop ? 24.0 : 8.0, // 모바일 상단 패딩 더 축소
                      isDesktop ? 64.0 : 16.0,
                      isDesktop ? 24.0 : 8.0, // 모바일 하단 패딩 더 축소 (날짜 잘림 방지)
                    ),
                    child: isDesktop
                        ? _buildRowLayout(
                            titleFontSize,
                            descFontSize,
                            false,
                            true,
                            overrideIndex: pageIndex,
                          )
                        : _buildColumnLayout(
                            titleFontSize,
                            descFontSize,
                            true,
                            true,
                            overrideIndex: pageIndex,
                            maxHeight:
                                height -
                                (isDesktop
                                    ? 100 + 24 + 24
                                    : 16 + 8 + 8), // Padding + Top 반영
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 기존 인디케이터 (직사각형) ---
  Widget _buildIndicators({int? overrideIndex}) {
    final int targetIndex = overrideIndex ?? _currentPage;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _galleryItems.length,
        (int index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          width: 16.0,
          height: 6.0,
          decoration: BoxDecoration(
            color: targetIndex == index
                ? AppColors.neonPurple
                : AppColors.neonPurple.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
      ),
    );
  }

  // --- 본문 콘텐츠 (좋아요, 텍스트) ---
  Widget _buildLikesAndContent(
    double titleFontSize,
    double descFontSize,
    bool isMobileOrSmall, {
    int? overrideIndex,
    bool isCapture = false,
  }) {
    final int index = overrideIndex ?? _currentPage;
    final GalleryItem item = _galleryItems[index];

    // 좋아요 숫자 3자리마다 콤마 찍기
    final String formattedLikes = _likeCounts[index]
        .toString()
        .replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (Match match) => ',',
        );

    // 최소 높이를 보장하여 텍스트가 적을 때도 하단 버튼 등이 위로 튀어오르는 현상 방지 (캡처 모델에서는 축소)
    return Container(
      constraints: BoxConstraints(
        minHeight: isCapture ? 100.0 : 250.0,
      ), // 200 -> 250 상향
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SelectableText(
            '좋아요 $formattedLikes개',
            style: TextStyle(
              fontFamily: 'WantedSans', // 가독성 폰트
              fontWeight: FontWeight.bold,
              fontSize: descFontSize * 0.95, // 소폭 키움
              color: Colors.white,
            ),
          ),
          SizedBox(height: isMobileOrSmall ? 12 : 24), // 간격 소폭 상향
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            layoutBuilder:
                (Widget? currentChild, List<Widget> previousChildren) {
                  return Stack(
                    alignment: Alignment.topLeft,
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
            child: Column(
              key: ValueKey<int>(index),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SelectableText(
                  item.title,
                  style: TextStyle(
                    fontFamily: 'PFStardust', // 메인 폰트
                    fontSize: titleFontSize * 0.9, // 0.8 -> 0.9 상향
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12), // 8 -> 12 상향
                SelectableText(
                  item.description,
                  style: TextStyle(
                    fontFamily: 'WantedSans', // 가독성 폰트
                    fontSize: descFontSize,
                    color: Colors.white.withValues(
                      alpha: 0.9,
                    ), // 70 -> 90% 밝기 상향
                    height: 1.6, // 줄간격 살짝 상향
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 선물 확인하기 버튼 (혹은 캡처 시 날짜 표시) ---
  Widget _buildEnterButton(bool isCapture, {int? overrideIndex}) {
    if (isCapture) {
      final DateTime now = DateTime.now();
      final String dateText =
          '- ${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')} -';
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16), // 캡처 시 여백 축소
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/title_logo.png',
                height: 32, // 로고 크기 축소
                color: Colors.white24, // 하단 로고는 은은하게 표시
              ),
              const SizedBox(height: 8),
              Text(
                dateText,
                style: const TextStyle(
                  fontFamily: 'WantedSans',
                  fontSize: 10,
                  color: Colors.white38, // 그레이 색상
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity, // 버튼 넓이 확장
      child: ElevatedButton(
        onPressed: _isLastPageReached ? _onEnterPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonPurple,
          disabledBackgroundColor: Colors.white12,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white38,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: _isLastPageReached ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
          elevation: 0,
        ),
        child: const Text(
          '선물 확인하기',
          style: TextStyle(
            fontFamily: 'PFStardust',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 모바일: 위에서 아래로 인스타그램 디자인 피드 배치
  Widget _buildColumnLayout(
    double titleFontSize,
    double descFontSize,
    bool isMobileOrSmall,
    bool isCapture, {
    int? overrideIndex,
    double? maxHeight, // 캡처 시 고정 높이 확보를 위해 추가
  }) {
    final Widget mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildInstagramHeader(titleFontSize, overrideIndex: overrideIndex),
        const SizedBox(height: 24), // 16 -> 24
        // Expanded 대신 정사각형(1:1) 비율 부여로 스크롤 가능한 이미지 크기 확보
        AspectRatio(
          aspectRatio: 1.0,
          child: isCapture
              ? _buildImageContent(overrideIndex ?? _currentPage, false)
              : _buildImageSection(false),
        ),
        const SizedBox(height: 24), // 16 -> 24
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildActionRow(),
            if (!isCapture) _buildIndicators(overrideIndex: overrideIndex),
          ],
        ),
        const SizedBox(height: 16), // 12 -> 16
        _buildLikesAndContent(
          titleFontSize,
          descFontSize,
          isMobileOrSmall,
          overrideIndex: overrideIndex,
          isCapture: isCapture,
        ),
        if (isCapture)
          const Spacer(), // 캡처 시 하단부(로고/날짜)를 전용으로 고정하기 위해 Spacer 추가
        SizedBox(height: isCapture ? 20 : 40), // 16/32 -> 20/40 상향
        _buildEnterButton(isCapture, overrideIndex: overrideIndex),
        if (!isCapture) const SizedBox(height: 50),
      ],
    );

    if (isCapture && maxHeight != null) {
      return SizedBox(height: maxHeight, child: mainContent);
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: mainContent,
    );
  }

  // 데스크톱 / 태블릿: 좌측 이미지, 우측 피드 정보 배치
  Widget _buildRowLayout(
    double titleFontSize,
    double descFontSize,
    bool isMobileOrSmall,
    bool isCapture, {
    int? overrideIndex,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 좌측: 슬라이딩되는 이미지 위젯 및 하단 인디케이터
        Expanded(
          flex: 6, // 5 -> 6 비율 조정
          child: Column(
            children: <Widget>[
              Expanded(
                child: isCapture
                    ? _buildImageContent(overrideIndex ?? _currentPage, true)
                    : _buildImageSection(true),
              ),
              if (!isCapture) ...[
                const SizedBox(height: 24), // 16 -> 24 상향
                _buildIndicators(overrideIndex: overrideIndex),
              ],
            ],
          ),
        ),
        const SizedBox(width: 60), // 48 -> 60 상향
        // 우측: 인스타그램 피드 형태의 텍스트 및 조작 버튼
        Expanded(
          flex: 5, // 4 -> 5 비율 조정 (우측 가독성 면적 확보)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildInstagramHeader(
                titleFontSize,
                overrideIndex: overrideIndex,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20), // 16 -> 20 상향
                child: Divider(
                  color: Colors.white38,
                  height: 1,
                ), // 24 -> 38 선명도 상향
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(right: 12), // 스크롤바 간섭 방지 여백
                  child: _buildLikesAndContent(
                    titleFontSize,
                    descFontSize,
                    isMobileOrSmall,
                    overrideIndex: overrideIndex,
                    isCapture: isCapture,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Colors.white38, height: 1),
              ),
              _buildActionRow(),
              const SizedBox(height: 32), // 24 -> 32 상향
              _buildEnterButton(isCapture, overrideIndex: overrideIndex),
            ],
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 픽셀 아트 둥근 모서리를 그리기 위한 패스 클리퍼 및 그림자 페인터
// -----------------------------------------------------------------------------

class PixelCornerClipper extends CustomClipper<Path> {
  final double pixelSize;
  PixelCornerClipper({this.pixelSize = 4.0});

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double p = pixelSize;
    final double w = size.width;
    final double h = size.height;

    // 2계단형으로 각진 도트 스타일의 둥근 모서리 경로 생성
    path.moveTo(p * 2, 0);
    path.lineTo(w - p * 2, 0);

    path.lineTo(w - p * 2, p);
    path.lineTo(w - p, p);
    path.lineTo(w - p, p * 2);
    path.lineTo(w, p * 2);

    path.lineTo(w, h - p * 2);
    path.lineTo(w - p, h - p * 2);
    path.lineTo(w - p, h - p);
    path.lineTo(w - p * 2, h - p);

    path.lineTo(w - p * 2, h);
    path.lineTo(p * 2, h);

    path.lineTo(p * 2, h - p);
    path.lineTo(p, h - p);
    path.lineTo(p, h - p * 2);
    path.lineTo(0, h - p * 2);

    path.lineTo(0, p * 2);
    path.lineTo(p, p * 2);
    path.lineTo(p, p);
    path.lineTo(p * 2, p);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant PixelCornerClipper oldClipper) =>
      oldClipper.pixelSize != pixelSize;
}

class PixelShadowPainter extends CustomPainter {
  final Offset offset;
  final Color color;
  final double pixelSize;

  PixelShadowPainter({
    required this.offset,
    required this.color,
    required this.pixelSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    // 위에 작성한 Clipper와 동일한 Path를 활용하여 클리핑 모양의 그림자 생성
    final Path path = PixelCornerClipper(pixelSize: pixelSize).getClip(size);
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant PixelShadowPainter oldDelegate) =>
      oldDelegate.offset != offset ||
      oldDelegate.color != color ||
      oldDelegate.pixelSize != pixelSize;
}
