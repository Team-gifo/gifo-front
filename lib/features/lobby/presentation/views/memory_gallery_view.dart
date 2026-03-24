import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../model/lobby_data.dart';

class MemoryGalleryView extends StatefulWidget {
  final String code;

  const MemoryGalleryView({super.key, required this.code});

  @override
  State<MemoryGalleryView> createState() => _MemoryGalleryViewState();
}

class _MemoryGalleryViewState extends State<MemoryGalleryView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLastPageReached = false;

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
                          await launchUrl(homeUri, webOnlyWindowName: '_blank');
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
                bottom: 0, // 하단은 padding으로만 조절하도록 변경. 하단까지 스크롤 자연스럽게 가기 위함.
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    paddingHorizontal,
                    24.0,
                    paddingHorizontal,
                    isMobileOrSmall ? 0 : 24.0, // 데스크톱은 하단 여백 부여
                  ),
                  child: isColumnLayout
                      ? _buildColumnLayout(titleFontSize, descFontSize)
                      : _buildRowLayout(titleFontSize, descFontSize),
                ),
              ),
            ],
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
    return const Row(
      children: <Widget>[
        Icon(Icons.favorite, color: Colors.red, size: 28),
        SizedBox(width: 16),
        Icon(Icons.mode_comment_outlined, color: Colors.white, size: 28),
        SizedBox(width: 16),
        Icon(Icons.send_outlined, color: Colors.white, size: 28),
        Spacer(),
        Icon(Icons.bookmark_border, color: Colors.white, size: 28),
      ],
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
  Widget _buildLikesAndContent(double titleFontSize, double descFontSize) {
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;

    final GalleryItem item = _galleryItems[_currentPage];
    final bool isMobileOrSmall = screenWidth < AppBreakpoints.tablet;

    // 좋아요 숫자 3자리마다 콤마 찍기
    final String formattedLikes = _likeCounts[_currentPage]
        .toString()
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (Match match) => ',');

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
            layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
              return Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  ...previousChildren,
                  ?currentChild,
                ],
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
  Widget _buildColumnLayout(double titleFontSize, double descFontSize) {
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
          _buildLikesAndContent(titleFontSize, descFontSize),
          const SizedBox(height: 24),
          _buildEnterButton(),
          const SizedBox(height: 48), // 모바일 환경 스크롤 최하단 여유 공간 확보
        ],
      ),
    );
  }

  // 데스크톱 / 태블릿: 좌측 이미지, 우측 피드 정보 배치
  Widget _buildRowLayout(double titleFontSize, double descFontSize) {
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
                  child: _buildLikesAndContent(titleFontSize, descFontSize),
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
