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
import '../../application/memory_gallery_action/memory_gallery_action_bloc.dart';
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

    final double titleFontSize = isDesktop ? 36 : (isTablet ? 32 : 26);
    final double descFontSize = isDesktop ? 20 : (isTablet ? 18 : 16);
    final double paddingHorizontal = isDesktop
        ? 64.0
        : (isTablet ? 48.0 : 16.0); // 모바일은 여백을 줄여 피드 이미지 확보

    return Title(
      title: 'Happy Birthday, ${lobbyData.user} | Gifo',
      color: Colors.black,
      child: Scaffold(
        backgroundColor: AppColors.darkBg,
        // 기존 AppBar를 제거하고 본문에 직관적으로 배치
        body: SafeArea(
          child:
              BlocListener<MemoryGalleryActionBloc, MemoryGalleryActionState>(
                listener: (context, state) {
                  if (state.status == ActionStatus.success) {
                    toastification.show(
                      context: context,
                      title: const Text('다운로드 완료!'),
                      type: ToastificationType.success,
                      autoCloseDuration: const Duration(seconds: 3),
                    );
                  } else if (state.status == ActionStatus.failure) {
                    toastification.show(
                      context: context,
                      title: const Text('다운로드 중 오류가 발생했습니다.'),
                      description: Text(state.errorMessage ?? ''),
                      type: ToastificationType.error,
                      autoCloseDuration: const Duration(seconds: 3),
                    );
                  }
                },
                child: Stack(
                  children: <Widget>[
                    // 1. 배경 그리드 패턴 추가
                    Positioned.fill(
                      child: CustomPaint(painter: GridBackgroundPainter()),
                    ),
                    // 2. 상단 타이틀 로고 배치 (모바일은 중앙, 데스크톱은 좌측)
                    Positioned(
                      top: 12,
                      left: isMobileOrSmall ? 0 : paddingHorizontal,
                      right: isMobileOrSmall ? 0 : null,
                      child: Align(
                        alignment: isMobileOrSmall
                            ? Alignment.center
                            : Alignment.centerLeft,
                        child: MouseRegion(
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
                              height: isMobileOrSmall ? 60 : 80,
                              color: Colors.white, // 통일감 있는 색상 유지
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 3. 메인 콘텐츠 (이미지부 / 텍스트·버튼부 분리 배치)
                    Positioned.fill(
                      top: isMobileOrSmall ? 80 : 100, // 패딩(상단 로고 높이 + 여백 확보)
                      bottom:
                          0, // 하단은 padding으로만 조절하도록 변경. 하단까지 스크롤 자연스럽게 가기 위함.
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
                              )
                            : _buildRowLayout(
                                titleFontSize,
                                descFontSize,
                                false,
                              ),
                      ),
                    ),

                    // 4. 처리 중일 경우 오버레이 (다이얼로그 외의 전체 컴포넌트 커버)
                    Positioned.fill(
                      child: BlocBuilder<
                        MemoryGalleryActionBloc,
                        MemoryGalleryActionState
                      >(
                        builder: (context, state) {
                          if (state.status == ActionStatus.loading) {
                            return Container(
                              color: Colors.black.withValues(alpha: 0.6),
                              child: const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      color: AppColors.neonPurple,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      '다운로드 처리 중...',
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
            final GalleryItem item = _galleryItems[index];
            return Padding(
              // 데스크톱 환경에서는 좌우 화살표 공간 확보를 위해 패딩 추가
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64.0 : 0.0),
              child: CustomPaint(
                painter: PixelShadowPainter(
                  offset: const Offset(8, 8),
                  color: Colors.black.withValues(alpha: 0.8),
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
          },
        ),

        // 이전/다음 화살표 (데스크톱/태블릿 환경에서만 표시)
        if (isDesktop && _currentPage > 0)
          Positioned(
            left: -24.0, // 바깥으로 빼서 거리를 넓게 유지
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                iconSize: 48,
                color: Colors.white70,
                hoverColor: Colors.white12,
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  if (_currentPage > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ),
        if (isDesktop && _currentPage < _galleryItems.length - 1)
          Positioned(
            right: -24.0, // 바깥으로 밀어내기
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                iconSize: 48,
                color: Colors.white70,
                hoverColor: Colors.white12,
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  if (_currentPage < _galleryItems.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ),
      ],
    );
  }

  // --- 인스타그램 헤더 영역 ---
  Widget _buildInstagramHeader(double titleFontSize) {
    return Row(
      children: <Widget>[
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24, width: 1),
            image: const DecorationImage(
              image: AssetImage('assets/images/icons/app_icon.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          lobbyData.user,
          style: TextStyle(
            fontFamily: 'PFStardust',
            fontSize: titleFontSize * 0.7, // 약간 작게 조절
            color: Colors.white,
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
        IconButton(
          onPressed: _showDownloadModal,
          icon: const Icon(
            Icons.bookmark_border,
            color: Colors.white,
            size: 28,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  void _showDownloadModal() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AlertDialog(
              backgroundColor: AppColors.darkBg,
              title: const Text(
                '다운로드 옵션',
                style: TextStyle(color: Colors.white, fontFamily: 'PFStardust'),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text(
                      '원본 이미지',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: _dlOriginal,
                    onChanged: (bool? val) =>
                        setModalState(() => _dlOriginal = val ?? false),
                    activeColor: AppColors.neonPurple,
                  ),
                  CheckboxListTile(
                    title: const Text(
                      '웹사이트 프레임 캡처 (1920x1080)',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: _dlDesktop,
                    onChanged: (bool? val) =>
                        setModalState(() => _dlDesktop = val ?? false),
                    activeColor: AppColors.neonPurple,
                  ),
                  CheckboxListTile(
                    title: const Text(
                      '모바일 프레임 캡처 (393x852)',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: _dlMobile,
                    onChanged: (bool? val) =>
                        setModalState(() => _dlMobile = val ?? false),
                    activeColor: AppColors.neonPurple,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    '취소',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonPurple,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _executeDownload();
                  },
                  child: const Text(
                    '다운로드',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  Future<void> _executeDownload() async {
    final MemoryGalleryActionBloc bloc = context
        .read<MemoryGalleryActionBloc>();
    final GalleryItem item = _galleryItems[_currentPage];
    final List<Map<String, dynamic>> filesInfo = [];

    if (!_dlOriginal && !_dlDesktop && !_dlMobile) {
      toastification.show(
        context: context,
        title: const Text('선택된 항목이 없습니다.'),
        type: ToastificationType.warning,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    // 로딩 시작 (BLoC에만 보내면 실제 처리를 View가 하므로 직접 Loading 상태를 emit하려면
    // BLoC에서 캡처 처리를 해야하지만, 캡처는 위젯과 직결되므로 여기서 캡처 중이라도 사용자가 알 수 있게 UI를 막아둘 필요가 있음.
    // 캡처 전에 BLoC 상태를 임의로 바꿀 수 있게 Event를 주입하거나, UI 스레드에서 캡처하므로 잠시 프리징되는 것을 대기합니다.)
    // 가장 안전한 방법은 여기서 바로 BLoC Download 처리 이벤트를 보내되, 캡처는 미리 수행하는 것입니다.
    // 캡처하는 동안 살짝 프리징 될 수 있으므로, 캡처 전에 모달을 닫고 짧은 딜레이를 주어 닫히는 애니메이션을 보장합니다.
    await Future.delayed(const Duration(milliseconds: 300));
    if (!context.mounted) return;

    // 이 작업은 시간이 다소 소요되나 Progress Overlay 렌더링 시작을 위해
    // 임시로 ActionStatus.loading을 직접 Emit 하거나 View 단에서 캡처가 돌아가는걸 감안해야합니다.
    // 여기서는 BLoC 이벤트 실행 전에 미리 처리합니다.

    // 1. 원본 이미지
    if (_dlOriginal) {
      final ByteData data = await rootBundle.load(item.imageUrl);
      filesInfo.add({
        'name': 'Original_${item.title}.png',
        'bytes': data.buffer.asUint8List(),
      });
    }

    // 2. 데스크톱 캡처 (1920x1080 고정 해상도)
    if (_dlDesktop) {
      try {
        final Uint8List? desktopBytes = await _screenshotController
            .captureFromWidget(
              _buildCaptureFrame(isDesktop: true),
              delay: const Duration(milliseconds: 500),
              context: context,
              targetSize: const Size(1920, 1080),
              pixelRatio: 1.0,
            );
        if (desktopBytes != null) {
          filesInfo.add({
            'name': 'Desktop_${item.title}.png',
            'bytes': desktopBytes,
          });
        }
      } catch (e) {
        debugPrint('Desktop capture error: $e');
      }
    }

    // 3. 모바일 캡처 (아이폰 15 프로 기준 393x852 픽셀 배율, 스크린샷은 3x인 1179x2556 해상도 혹은 1배수.
    // 여기서는 너무 커지는 것을 방지하여 393x852 레이아웃 & pixelRatio: 3.0 으로 1179x2556 원본 해상도 지정)
    if (_dlMobile) {
      try {
        final Uint8List? mobileBytes = await _screenshotController
            .captureFromWidget(
              _buildCaptureFrame(isDesktop: false),
              delay: const Duration(milliseconds: 500),
              context: context,
              targetSize: const Size(393, 852),
              pixelRatio: 3.0,
            );
        if (mobileBytes != null) {
          filesInfo.add({
            'name': 'Mobile_${item.title}.png',
            'bytes': mobileBytes,
          });
        }
      } catch (e) {
        debugPrint('Mobile capture error: $e');
      }
    }

    if (filesInfo.isNotEmpty) {
      bloc.add(ProcessDownloadEvent(filesInfo: filesInfo));
    }
  }

  Widget _buildCaptureFrame({required bool isDesktop}) {
    final double titleFontSize = isDesktop ? 36 : 26;
    final double descFontSize = isDesktop ? 20 : 16;
    final double width = isDesktop ? 1920 : 393;
    final double height = isDesktop ? 1080 : 852;

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
                Positioned(
                  top: 12,
                  left: isDesktop ? 64.0 : 0,
                  right: isDesktop ? null : 0,
                  child: Align(
                    alignment: isDesktop
                        ? Alignment.centerLeft
                        : Alignment.center,
                    child: Image.asset(
                      'assets/images/title_logo.png',
                      height: isDesktop ? 80 : 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned.fill(
                  top: isDesktop ? 100 : 80,
                  bottom: 0,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isDesktop ? 64.0 : 16.0,
                      24.0,
                      isDesktop ? 64.0 : 16.0,
                      isDesktop ? 24.0 : 0,
                    ),
                    child: isDesktop
                        ? _buildRowLayout(titleFontSize, descFontSize, false)
                        : _buildColumnLayout(titleFontSize, descFontSize, true),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 기존 인디케이터 (직사각형, 파란색) ---
  Widget _buildIndicators() {
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
            color: _currentPage == index
                ? AppColors.neonPurple
                : AppColors.neonPurple.withValues(alpha: 0.3),
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
    bool isMobileOrSmall,
  ) {
    final GalleryItem item = _galleryItems[_currentPage];

    // 좋아요 숫자 3자리마다 콤마 찍기
    final String formattedLikes = _likeCounts[_currentPage]
        .toString()
        .replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (Match match) => ',',
        );

    // 최소 높이를 보장하여 텍스트가 적을 때도 하단 버튼 등이 위로 튀어오르는 현상 방지
    return Container(
      constraints: const BoxConstraints(minHeight: 200.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SelectableText(
            '좋아요 $formattedLikes개',
            style: TextStyle(
              fontFamily: 'WantedSans', // 가독성 폰트
              fontWeight: FontWeight.bold,
              fontSize: descFontSize * 0.9,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isMobileOrSmall ? 8 : 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            layoutBuilder:
                (Widget? currentChild, List<Widget> previousChildren) {
                  return Stack(
                    alignment: Alignment.topLeft,
                    children: <Widget>[...previousChildren, ?currentChild],
                  );
                },
            child: Column(
              key: ValueKey<int>(_currentPage),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SelectableText(
                  item.title,
                  style: TextStyle(
                    fontFamily: 'PFStardust', // 메인 폰트
                    fontSize: titleFontSize * 0.8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  item.description,
                  style: TextStyle(
                    fontFamily: 'WantedSans', // 가독성 폰트
                    fontSize: descFontSize,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 선물 확인하기 버튼 ---
  Widget _buildEnterButton() {
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
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildInstagramHeader(titleFontSize),
          const SizedBox(height: 16),
          // Expanded 대신 정사각형(1:1) 비율 부여로 스크롤 가능한 이미지 크기 확보
          AspectRatio(aspectRatio: 1.0, child: _buildImageSection(false)),
          const SizedBox(height: 16),
          // 액션 로우 버튼 및 가운데 인디케이터
          Stack(
            alignment: Alignment.center,
            children: <Widget>[_buildActionRow(), _buildIndicators()],
          ),
          const SizedBox(height: 12),
          _buildLikesAndContent(titleFontSize, descFontSize, isMobileOrSmall),
          const SizedBox(height: 24),
          _buildEnterButton(),
          const SizedBox(height: 48), // 모바일 환경 스크롤 최하단 여유 공간 확보
        ],
      ),
    );
  }

  // 데스크톱 / 태블릿: 좌측 이미지, 우측 피드 정보 배치
  Widget _buildRowLayout(
    double titleFontSize,
    double descFontSize,
    bool isMobileOrSmall,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 좌측: 슬라이딩되는 이미지 위젯 및 하단 인디케이터
        Expanded(
          flex: 5,
          child: Column(
            children: <Widget>[
              Expanded(child: _buildImageSection(true)),
              const SizedBox(height: 16),
              _buildIndicators(),
            ],
          ),
        ),
        const SizedBox(width: 48),
        // 우측: 인스타그램 피드 형태의 텍스트 및 조작 버튼
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildInstagramHeader(titleFontSize),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.white24, height: 1),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildLikesAndContent(
                    titleFontSize,
                    descFontSize,
                    isMobileOrSmall,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.white24, height: 1),
              ),
              _buildActionRow(),
              const SizedBox(height: 24),
              _buildEnterButton(),
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
