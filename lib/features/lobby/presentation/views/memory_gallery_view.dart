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
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width;

    // AppBreakpoints 기반 해상도 분기
    final bool isMobile = screenWidth < AppBreakpoints.mobile;
    final bool isTablet =
        screenWidth >= AppBreakpoints.mobile &&
        screenWidth < AppBreakpoints.desktop; // 1024px 미만을 태블릿으로 간주
    final bool isDesktop =
        screenWidth >= AppBreakpoints.desktop; // 1024px 이상부터 데스크톱 가로 배율 적용

    // 모바일/태블릿 등 가로 폭이 좁은 구간에서는 상하(Column) 배치 적용
    final bool isColumnLayout = isMobile || isTablet;

    final double titleFontSize = isDesktop ? 36 : (isTablet ? 32 : 26);
    final double descFontSize = isDesktop ? 20 : (isTablet ? 18 : 16);
    final double paddingHorizontal = isDesktop
        ? 64.0
        : (isTablet ? 48.0 : 24.0);

    return Title(
      title: 'Happy Birthday, ${lobbyData.user} | Gifo',
      color: Colors.black,
      child: Scaffold(
        backgroundColor: AppColors.darkBg,
        // 기존 AppBar를 제거하고 본문에 직관적으로 배치
        body: SafeArea(
          child: Stack(
            children: [
              // 1. 배경 그리드 패턴 추가
              Positioned.fill(
                child: CustomPaint(painter: GridBackgroundPainter()),
              ),

              // 2. 상단 좌측 로고 배치 (AppBar를 대체)
              Positioned(
                top: 24,
                left: paddingHorizontal,
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
                      height: isMobile ? 40 : 80,
                      color: Colors.white, // 통일감 있는 색상 유지
                    ),
                  ),
                ),
              ),

              // 3. 메인 콘텐츠 (이미지부 / 텍스트·버튼부 분리 배치)
              Positioned.fill(
                top: isMobile ? 80 : 100, // 패딩(상단 로고 높이 + 여백 확보)
                bottom: isMobile ? 80 : 100,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: paddingHorizontal,
                    vertical: 24.0,
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
      children: [
        PageView.builder(
          controller: _pageController,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
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
          itemBuilder: (context, index) {
            final item = _galleryItems[index];
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

        // 이전/다음 화살표 (모바일/데스크톱 모두 표시, 이미지 엣지 기준 오버레이)
        Positioned(
          left: isDesktop ? -24.0 : 8.0, // 데스크톱은 바깥으로 빼서 거리를 넓게 유지
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton(
              iconSize: isDesktop ? 48 : 36,
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
        Positioned(
          right: isDesktop ? -24.0 : 8.0, // 우측 화면도 외곽으로 버튼 밀어내기
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton(
              iconSize: isDesktop ? 48 : 36,
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

  // --- 위젯 분리: 텍스트 및 조작 버튼 영역 (지정된 순서로 배치) ---
  Widget _buildTextAndControlSection(
    double titleFontSize,
    double descFontSize,
  ) {
    final item = _galleryItems[_currentPage];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start, // 전체를 좌측(start) 정렬로 변경
      mainAxisSize: MainAxisSize.min, // 텍스트 영역 길이에 맞춰 최소 높이만 사용
      children: [
        // 1. 텍스트 요소 (크로스페이드 애니메이션 부여)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Column(
            key: ValueKey<int>(_currentPage),
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 좌측 정렬
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 24),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: descFontSize,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),

        // 텍스트 시각적 그룹과 조작부 인디케이터+버튼 시각적 그룹을 띄우기 위한 넓은 여백 확보
        const SizedBox(height: 80),

        // 2. 컨트롤 요소 (텍스트 밑에 진행 상황 인디케이터와 확인 버튼 고정)
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // 조작부 요소들도 좌측 정렬
          children: [
            // 페이지 인디케이터 구성 (작은 직사각형, 파란색)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                _galleryItems.length,
                (index) => Container(
                  margin: const EdgeInsets.only(right: 6.0),
                  width: 16.0,
                  height: 6.0, // 직사각형 
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.blue
                        : Colors.blue.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // indicator와 button 사이는 10px로 밀착
            // 선물 확인하기 버튼 (마지막 슬라이드에 다다르기 전까지 비활성화 처리됨)
            ElevatedButton(
              onPressed: _isLastPageReached ? _onEnterPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonPurple,
                disabledBackgroundColor: Colors.white12, // 비활성화시 칙칙한 배경색 적용
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white38, // 텍스트도 흐리게 처리
                padding: const EdgeInsets.symmetric(
                  horizontal: 48.0,
                  vertical: 18.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                    color: _isLastPageReached
                        ? Colors.white
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                elevation: 0,
              ),
              child: const Text(
                '선물 확인하기',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ],
    );
  }

  // 모바일/태블릿: 상하단 분리형 세로 배치
  Widget _buildColumnLayout(double titleFontSize, double descFontSize) {
    return Column(
      children: [
        // 상단: 남는 공간을 이미지 위젯이 모두 차지하도록 유동적으로 조절
        Expanded(child: _buildImageSection(false)),
        const SizedBox(height: 32),
        // 하단: 텍스트 영역 길이에 맞춰 세로 공간 사용 (text가 길어지면 이미지가 줄어듦)
        _buildTextAndControlSection(titleFontSize, descFontSize),
      ],
    );
  }

  // 데스크톱: 좌우 대칭형 가로 배치
  Widget _buildRowLayout(double titleFontSize, double descFontSize) {
    return Row(
      children: [
        // 좌측: 슬라이딩되는 이미지 위젯
        Expanded(flex: 5, child: _buildImageSection(true)),
        const SizedBox(width: 48),
        // 우측: 텍스트 및 조작 버튼부 위젯
        Expanded(
          flex: 4,
          child: _buildTextAndControlSection(titleFontSize, descFontSize),
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
    final path = Path();
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
    final paint = Paint()..color = color;
    // 위에 작성한 Clipper와 동일한 Path를 활용하여 클리핑 모양의 그림자 생성
    final path = PixelCornerClipper(pixelSize: pixelSize).getClip(size);
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
