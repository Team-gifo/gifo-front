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
    final bool isTablet = screenWidth >= AppBreakpoints.mobile && screenWidth < AppBreakpoints.tablet;
    final bool isDesktop = screenWidth >= AppBreakpoints.tablet;
    
    // 모바일/태블릿 등 가로 폭이 좁은 구간에서는 상하(Column) 배치 적용 (태블릿까지는 Column 사용)
    final bool isColumnLayout = isMobile || isTablet;

    final double titleFontSize = isDesktop ? 36 : (isTablet ? 32 : 26);
    final double descFontSize = isDesktop ? 20 : (isTablet ? 18 : 16);
    final double paddingHorizontal = isDesktop ? 64.0 : (isTablet ? 48.0 : 24.0);

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
                      height: isMobile ? 40 : 50,
                      color: Colors.white, // 통일감 있는 색상 유지
                    ),
                  ),
                ),
              ),

              // 3. 메인 콘텐츠 (이미지부 / 텍스트·버튼부 분리 배치)
              Positioned.fill(
                top: isMobile ? 80 : 100, // 패딩(상단 로고 높이 + 여백 확보)
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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white12,
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    item.imageUrl,
                    fit: BoxFit.cover, // 여백 없이 화면에 꽉 차게 비율 유지
                  ),
                ),
              ),
            );
          },
        ),
        
        // 이전/다음 화살표 (모바일/데스크톱 모두 표시, 이미지 엣지 기준 오버레이)
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
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
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
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
  Widget _buildTextAndControlSection(double titleFontSize, double descFontSize) {
    final item = _galleryItems[_currentPage];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, // 텍스트 영역 길이에 맞춰 최소 높이만 사용
      children: [
        // 1. 텍스트 요소 (크로스페이드 애니메이션 부여)
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Column(
              key: ValueKey<int>(_currentPage),
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    item.title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: descFontSize,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

        // 2. 컨트롤 요소 (텍스트 밑에 진행 상황 인디케이터와 확인 버튼 고정)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 페이지 인디케이터 구성
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _galleryItems.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
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
                    color: _isLastPageReached ? Colors.white : Colors.transparent,
                    width: 2,
                  ),
                ),
                elevation: 0,
              ),
              child: const Text(
                '선물 확인하기',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        )
      ],
    );
  }

  // 모바일/태블릿: 상하단 분리형 세로 배치
  Widget _buildColumnLayout(double titleFontSize, double descFontSize) {
    return Column(
      children: [
        // 상단: 남는 공간을 이미지 위젯이 모두 차지하도록 유동적으로 조절
        Expanded(
          child: _buildImageSection(false),
        ),
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
        Expanded(
          flex: 5,
          child: _buildImageSection(true),
        ),
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
