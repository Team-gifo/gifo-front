import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../lobby/model/lobby_data.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  final ScrollController _scrollController = ScrollController();

  // 각 섹션의 GlobalKey (스크롤 위치 계산에 사용)
  final List<GlobalKey> _sectionKeys = List.generate(6, (_) => GlobalKey());

  // 현재 활성 섹션 인덱스
  int _currentSection = 0;

  // 스크롤 중 중복 처리 방지
  bool _isScrolling = false;

  // FAB 표시 여부
  bool _showFab = false;

  // AppBar 초대코드 버튼 표시 여부 (두 번째 섹션부터 노출)
  bool _showAppBarAction = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 스크롤 위치 변화 감지 -> FAB 표시 여부 결정
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bool shouldShowFab = _scrollController.offset > 100;
    if (shouldShowFab != _showFab) {
      setState(() {
        _showFab = shouldShowFab;
      });
    }

    // 첫 섹션(히어로)을 벗어나면 AppBar 초대코드 버튼 노출
    final bool shouldShowAction = _currentSection > 0;
    if (shouldShowAction != _showAppBarAction) {
      setState(() {
        _showAppBarAction = shouldShowAction;
      });
    }
  }

  // 특정 섹션으로 부드럽게 스크롤
  void _scrollToSection(int index) {
    if (_isScrolling) return;
    if (index < 0 || index >= _sectionKeys.length) return;

    final context = _sectionKeys[index].currentContext;
    if (context == null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    // AppBar 높이(80.0)를 빼주어 정확한 스크롤 offset 위치 보정
    final double targetOffset = index == 0
        ? 0.0
        : (box.localToGlobal(Offset.zero, ancestor: null).dy +
              _scrollController.offset -
              80.0);

    _isScrolling = true;
    _scrollController
        .animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
        )
        .then((_) => _isScrolling = false);
  }

  // 최상단으로 스크롤
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  // 마우스 휠 이벤트: 섹션 단위 이동
  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    if (_isScrolling) return;

    final double dy = event.scrollDelta.dy;
    if (dy > 0) {
      // 아래로
      final next = math.min(_currentSection + 1, _sectionKeys.length - 1);
      if (next != _currentSection) {
        setState(() => _currentSection = next);
        _scrollToSection(next);
      }
    } else if (dy < 0) {
      // 위로
      final prev = math.max(_currentSection - 1, 0);
      if (prev != _currentSection) {
        setState(() => _currentSection = prev);
        _scrollToSection(prev);
      }
    }
  }

  void _showInviteModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            child: const _InviteModalContent(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double topPadding = MediaQuery.of(context).padding.top;

    final bool isMobile = screenWidth < AppBreakpoints.mobile;
    final bool isTablet =
        screenWidth >= AppBreakpoints.mobile &&
        screenWidth < AppBreakpoints.tablet;

    // AppBar(80) + safe area를 제외한 가용 뷰포트 높이
    final double heroHeight = math.max(
      isMobile ? 520.0 : 600.0,
      screenHeight - 80.0 - topPadding,
    );
    // 일반 섹션 높이 (화면 꽉 채우기)
    final double sectionHeight = math.max(
      isMobile ? 500.0 : 640.0,
      screenHeight - 80.0 - topPadding,
    );

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        // 우측 하단 기본 위치에서 좌로 10, 위로 10 오프셋
        padding: const EdgeInsets.only(right: 30, bottom: 30),
        child: AnimatedOpacity(
          opacity: _showFab ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: !_showFab,
            child: FloatingActionButton(
              onPressed: () {
                setState(() => _currentSection = 0);
                _scrollToTop();
              },
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: AppColors.neonPurple, width: 2),
              ),
              elevation: 0,
              highlightElevation: 0,
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: AppColors.neonPurple,
                size: 28,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: Colors.black.withValues(alpha: 0.8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white, width: 4),
                ),
              ),
            ),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 8.0
                : isTablet
                ? 16.0
                : 60.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Logo
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/title_logo.png',
                    width: isMobile ? 72 : 100,
                    color: Colors.white,
                  ),
                ],
              ),
              // Action: 두 번째 섹션 이후부터 표시
              AnimatedOpacity(
                opacity: _showAppBarAction ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: IgnorePointer(
                  ignoring: !_showAppBarAction,
                  child: GestureDetector(
                    onTap: () => _showInviteModal(context),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                            color: AppColors.neonPurple,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neonPurple.withValues(
                                alpha: 0.3,
                              ),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '초대코드 입력',
                          style: TextStyle(
                            fontFamily: 'PFStardustS',
                            color: AppColors.neonPurpleLight,
                            fontSize: isMobile ? 11 : 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // 그리드 배경
          Positioned.fill(child: CustomPaint(painter: GridBackgroundPainter())),

          // 마우스 휠 이벤트 감지 (데스크톱)
          Listener(
            onPointerSignal: _handlePointerSignal,
            child: SingleChildScrollView(
              controller: _scrollController,
              // 마우스 휠의 기본 스크롤을 막고, 섹션 단위로만 동작
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  // ---- 1. 메인 히어로 섹션 ----
                  Container(
                    key: _sectionKeys[0],
                    width: double.infinity,
                    height: heroHeight,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20.0 : 40.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: _buildMockPixelGiftBox(isMobile: isMobile),
                        ),
                        SizedBox(height: isMobile ? 28 : 48),
                        Text(
                          'Surprise, Play, and Gift.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PFStardustS',
                            fontSize: isMobile
                                ? 22
                                : isTablet
                                ? 36
                                : 56,
                            height: 1.4,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: isMobile ? 14 : 24),
                        Text(
                          '기억에 남고 특별한 감동을 선물하고 싶다면\n오직 한 사람만을 위한 생일 사이트를 포장하고, 전달해주세요.\n\n'
                          '* 현재 무료 서비스로 운영중',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'WantedSans',
                            fontSize: isMobile
                                ? 12
                                : isTablet
                                ? 15
                                : 18,
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                            height: 1.8,
                          ),
                        ),
                        SizedBox(height: isMobile ? 28 : 48),
                        // 버튼 Row: 선물 포장하기 + 초대코드 입력
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 선물 포장하기 버튼
                            GestureDetector(
                              onTap: () async {
                                final Uri url = Uri.base.resolve('/addgift');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    webOnlyWindowName: '_blank',
                                  );
                                } else {
                                  if (context.mounted) {
                                    context.push('/');
                                  }
                                }
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 24 : 40,
                                    vertical: isMobile ? 14 : 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.neonPurple,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: isMobile ? 2 : 4,
                                    ),
                                  ),
                                  child: Text(
                                    '선물 포장하기',
                                    style: TextStyle(
                                      fontFamily: 'PFStardustS',
                                      color: Colors.white,
                                      fontSize: isMobile ? 11 : 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: isMobile ? 12 : 16),
                            // 초대코드 입력 버튼
                            GestureDetector(
                              onTap: () => _showInviteModal(context),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 20 : 36,
                                    vertical: isMobile ? 14 : 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: AppColors.neonPurple,
                                      width: isMobile ? 2 : 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.neonPurple.withValues(
                                          alpha: 0.2,
                                        ),
                                        offset: const Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '초대코드 입력',
                                    style: TextStyle(
                                      fontFamily: 'PFStardustS',
                                      color: AppColors.neonPurpleLight,
                                      fontSize: isMobile ? 11 : 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ---- 2. WHAT IS GIFO? 소개 섹션 ----
                  Container(
                    key: _sectionKeys[1],
                    width: double.infinity,
                    height: sectionHeight,
                    padding: EdgeInsets.symmetric(
                      vertical: isMobile ? 40.0 : 80.0,
                      horizontal: isMobile ? 20.0 : 24.0,
                    ),
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 12 : 20,
                            vertical: isMobile ? 6 : 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.neonPurple,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonPurple.withValues(
                                  alpha: 0.2,
                                ),
                                offset: const Offset(4, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            'WHAT IS GIFO?',
                            style: TextStyle(
                              fontFamily: 'PFStardustS',
                              color: AppColors.neonPurpleLight,
                              fontSize: isMobile
                                  ? 13
                                  : isTablet
                                  ? 18
                                  : 24,
                            ),
                          ),
                        ),
                        SizedBox(height: isMobile ? 28 : 48),
                        _TitleAndSubtitleAnimation(screenWidth: screenWidth),
                        SizedBox(height: isMobile ? 24 : 40),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          padding: EdgeInsets.all(
                            isMobile
                                ? 16.0
                                : isTablet
                                ? 24.0
                                : 40.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkBg,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.6),
                                offset: const Offset(8, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "선물은 진심을 담아 전할 때 비로소 가치가 빛납니다.\n최근 모바일 교환권으로 가볍게 주고받는 트렌드 속에서,\n우리는 점차 희미해져 가는 '진짜 선물의 의미'를 되찾고자 합니다.",
                                style: TextStyle(
                                  fontFamily: 'WantedSans',
                                  fontSize: isMobile
                                      ? 11
                                      : isTablet
                                      ? 13
                                      : 16,
                                  color: Colors.white70,
                                  height: 1.8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: isMobile ? 14 : 24),
                              Text(
                                'Gifo는 특별한 날, 당신만의 마음을 꾹꾹 눌러 담아\n세상에 단 하나뿐인 포장 공간을 만들고 전달하는 서비스입니다.',
                                style: TextStyle(
                                  fontFamily: 'WantedSans',
                                  fontSize: isMobile
                                      ? 11
                                      : isTablet
                                      ? 13
                                      : 16,
                                  color: Colors.white,
                                  height: 1.8,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---- 3. Surprise 섹션 ----
                  _SectionLayout(
                    sectionKey: _sectionKeys[2],
                    height: sectionHeight,
                    isMobile: isMobile,
                    isTablet: isTablet,
                    tag: 'SURPRISE',
                    title: '환영 및 추억 갤러리',
                    description:
                        '상대방의 이름과 함께했던 추억을 알려주시면\n'
                        '멋진 초기 환영 화면과 추억 갤러리를 꾸며드립니다.\n\n'
                        '당신만의 공간에서 소중한 기억들이\n'
                        '픽셀 아트로 아름답게 펼쳐집니다.',
                    imagePlaceholderLabel: 'Lobby Preview',
                    imagePaths: const [
                      'assets/images/example/surprise_ex.png',
                      'assets/images/example/surprise_ex.png',
                    ],
                  ),

                  // ---- 4. Play 섹션 ----
                  _SectionLayout(
                    sectionKey: _sectionKeys[3],
                    height: sectionHeight,
                    isMobile: isMobile,
                    isTablet: isTablet,
                    tag: 'PLAY',
                    title: '다양한 특별한 콘텐츠',
                    description:
                        '단순히 선물만 주면 너무 시시하잖아요?\n'
                        '캡슐 뽑기, 문제 맞추기, 바로 오픈 등\n'
                        '하나를 골라 상대방이 직접 즐길 수 있게 해보세요.\n\n'
                        '(콘텐츠는 주기적으로 업데이트 됩니다.)\n\n'
                        '당신이 준비한 콘텐츠를 통해 더 특별한 순간을 만드세요.',
                    imagePlaceholderLabel: 'Play Contents',
                    imagePaths: const [
                      'assets/images/example/play_ex.png',
                      'assets/images/example/play_ex.png',
                    ],
                    reversed: true, // 이미지 좌측, 텍스트 우측
                  ),

                  // ---- 5. Gift 섹션 ----
                  _SectionLayout(
                    sectionKey: _sectionKeys[4],
                    height: sectionHeight,
                    isMobile: isMobile,
                    isTablet: isTablet,
                    tag: 'GIFT',
                    title: '선물 쿠폰으로 전달',
                    description:
                        '결과에 따른 선물은 언제든 받을 수 있게\n'
                        '쿠폰 이미지로 발급해 제공해드립니다.\n\n'
                        '특별한 날의 추억을 이미지로 간직하고,\n'
                        '소중한 사람에게 영원히 기억될 선물을 전하세요.',
                    imagePlaceholderLabel: 'Gift Coupon',
                    imagePaths: const [
                      'assets/images/example/gift_ex.png',
                      'assets/images/example/gift_ex.png',
                    ],
                  ),

                  // ---- 6. 하단 권유 섹션 ----
                  Container(
                    key: _sectionKeys[5],
                    width: double.infinity,
                    height: sectionHeight,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20.0 : 24.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '지금 바로 특별한 선물을 준비해보세요.',
                          style: TextStyle(
                            fontFamily: 'PFStardustS',
                            fontSize: isMobile ? 11 : 40,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isMobile ? 10 : 16),
                        Text(
                          '몇 번의 클릭만으로 링크로 전달할 수 있습니다.',
                          style: TextStyle(
                            fontFamily: 'WantedSans',
                            fontSize: isMobile ? 11 : 16,
                            color: Colors.white54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isMobile ? 32 : 48),
                        GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.base.resolve('/addgift');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, webOnlyWindowName: '_blank');
                            } else if (context.mounted) {
                              context.push('/');
                            }
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 28 : 48,
                                vertical: isMobile ? 14 : 22,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.neonPurple,
                                border: Border.all(
                                  color: Colors.white,
                                  width: isMobile ? 2 : 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.neonPurple.withValues(
                                      alpha: 0.5,
                                    ),
                                    offset: const Offset(6, 6),
                                  ),
                                ],
                              ),
                              child: Text(
                                '선물 포장하기',
                                style: TextStyle(
                                  fontFamily: 'PFStardustS',
                                  color: Colors.white,
                                  fontSize: isMobile ? 11 : 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockPixelGiftBox({bool isMobile = false}) {
    final double boxSize = isMobile ? 140 : 200;
    final double innerSize = isMobile ? 70 : 100;
    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: AppColors.neonPurple,
          width: isMobile ? 3 : 4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: 0.3),
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: innerSize,
              height: innerSize,
              child: Image.asset('assets/images/icons/app_icon.png'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 공통 섹션 레이아웃 (좌-텍스트 / 우-이미지)
// reversed=true 이면 좌-이미지 / 우-텍스트
// ==========================================
class _SectionLayout extends StatefulWidget {
  final GlobalKey sectionKey;
  final double height;
  final bool isMobile;
  final bool isTablet;
  final String tag;
  final String title;
  final String description;
  final String imagePlaceholderLabel;
  final List<String> imagePaths;
  final bool reversed;

  const _SectionLayout({
    required this.sectionKey,
    required this.height,
    required this.isMobile,
    required this.isTablet,
    required this.tag,
    required this.title,
    required this.description,
    required this.imagePlaceholderLabel,
    this.imagePaths = const [],
    this.reversed = false,
  });

  @override
  State<_SectionLayout> createState() => _SectionLayoutState();
}

class _SectionLayoutState extends State<_SectionLayout> {
  late PageController _pageController;
  late int _currentPage;
  Timer? _autoSlideTimer;

  // 무한 스크롤을 위해 매우 큰 값 설정
  static const int _loopCount = 10000;
  int get _initialPage => widget.imagePaths.length * (_loopCount ~/ 2);

  @override
  void initState() {
    super.initState();
    _currentPage = _initialPage;
    _pageController = PageController(initialPage: _initialPage);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || widget.imagePaths.length <= 1) return;
      // 항상 오른쪽으로만 이동 (정방향 무한 루프)
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (widget.imagePaths.length <= 1) return;
    _startAutoSlide();
    _pageController.animateToPage(
      _currentPage + 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _prevPage() {
    if (widget.imagePaths.length <= 1) return;
    _startAutoSlide();
    _pageController.animateToPage(
      _currentPage - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showFullScreenImage(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.black.withValues(alpha: 0.8)),
            ),
            Center(child: InteractiveViewer(child: Image.asset(path))),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 데스크톱 양 끝 여백을 조정하여 콘텐츠 영역 확보
    final double hPad = widget.isMobile
        ? 20.0
        : widget.isTablet
        ? 48.0
        : 80.0;

    final Widget textBlock = _buildTextBlock();
    final Widget imageBlock = _buildImageBlock(context);

    return Container(
      key: widget.sectionKey,
      width: double.infinity,
      height: widget.height,
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: (widget.isMobile || widget.isTablet)
          // 모바일 + 태블릿: 이미지(위) -> 텍스트(아래) 세로 배치, 전체 center 정렬
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                imageBlock,
                SizedBox(height: widget.isTablet ? 60 : 28),
                // 텍스트 블록은 내부적으로 start 정렬을 유지하되 전체는 center
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: widget.isTablet ? 560 : double.infinity,
                  ),
                  child: textBlock,
                ),
              ],
            )
          // 데스크톱: 가로 배치가 기본이나, reversed 여부에 따라 순서 변경
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widget.reversed
                  ? [
                      // reversed: 이미지(좌) -> 텍스트(우) / 이미지 비중 확대 (6:4)
                      Expanded(flex: 6, child: Center(child: imageBlock)),
                      const SizedBox(width: 80),
                      Expanded(flex: 4, child: textBlock),
                    ]
                  : [
                      // normal: 텍스트(좌) -> 이미지(우) / 이미지 비중 확대 (6:4)
                      Expanded(flex: 4, child: textBlock),
                      const SizedBox(width: 80),
                      Expanded(flex: 6, child: Center(child: imageBlock)),
                    ],
            ),
    );
  }

  Widget _buildTextBlock() {
    // 모바일/태블릿: center 정렬, 데스크톱: reversed 여부에 따라 end / start 분기
    final bool centerAlign = widget.isMobile || widget.isTablet;
    final CrossAxisAlignment crossAlign = centerAlign
        ? CrossAxisAlignment.center
        : widget.reversed
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final TextAlign textAlign = centerAlign
        ? TextAlign.center
        : widget.reversed
        ? TextAlign.end
        : TextAlign.start;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAlign,
      children: [
        // 태그 뱃지 (모바일/태블릿에서 center로 자동 배치됨)
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 10 : 16,
            vertical: widget.isMobile ? 4 : 6,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neonPurple, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonPurple.withValues(alpha: 0.2),
                offset: const Offset(3, 3),
              ),
            ],
          ),
          child: Text(
            widget.tag,
            style: TextStyle(
              fontFamily: 'PFStardustS',
              color: AppColors.neonPurpleLight,
              fontSize: widget.isMobile ? 10 : 18,
            ),
          ),
        ),
        SizedBox(height: widget.isMobile ? 20 : 28),
        // 큰 제목
        Text(
          widget.title,
          textAlign: textAlign,
          style: TextStyle(
            fontFamily: 'PFStardustS',
            fontSize: widget.isMobile
                ? 20
                : widget.isTablet
                ? 28
                : 40,
            color: Colors.white,
            height: 1.3,
          ),
        ),
        SizedBox(height: widget.isMobile ? 16 : 24),
        // 소개 문구
        Text(
          widget.description,
          textAlign: textAlign,
          style: TextStyle(
            fontFamily: 'WantedSans',
            fontSize: widget.isMobile
                ? 12
                : widget.isTablet
                ? 14
                : 16,
            color: Colors.white70,
            height: 1.8,
          ),
        ),
      ],
    );
  }

  Widget _buildImageBlock(BuildContext context) {
    if (widget.imagePaths.isEmpty) {
      return _buildPlaceholder();
    }

    final int realIndex = _currentPage % widget.imagePaths.length;
    final bool showArrows = !widget.isMobile && !widget.isTablet && widget.imagePaths.length > 1;

    // 메인 이미지 컨테이너 (그림자 및 테두리 포함)
    Widget imageArea = Container(
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: 0.15),
            offset: const Offset(8, 8),
          ),
        ],
      ),
      child: ClipRect(
        child: PageView.builder(
          controller: _pageController,
          physics: const ClampingScrollPhysics(),
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.trackpad,
            },
          ),
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: widget.imagePaths.length * _loopCount,
          itemBuilder: (context, index) {
            final int rIdx = index % widget.imagePaths.length;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _showFullScreenImage(context, widget.imagePaths[rIdx]),
                child: Image.asset(
                  widget.imagePaths[rIdx],
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            );
          },
        ),
      ),
    );

    // 전체 레이아웃: [좌화살표 - 이미지 - 우화살표] + 하단 인디케이터
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showArrows)
              _buildArrowButton(Icons.arrow_back_ios_new, _prevPage),
            
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: widget.isMobile ? 420 : widget.isTablet ? 640 : 1000,
                ),
                child: AspectRatio(
                  aspectRatio: 1.6,
                  child: imageArea,
                ),
              ),
            ),

            if (showArrows)
              _buildArrowButton(Icons.arrow_forward_ios, _nextPage),
          ],
        ),
        
        // 하단 인디케이터 (영역 밖)
        if (widget.imagePaths.length > 1) ...[
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.imagePaths.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  index == realIndex ? Icons.circle : Icons.circle_outlined,
                  size: 10,
                  color: index == realIndex ? AppColors.neonPurple : Colors.white38,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: IconButton(
        icon: Icon(icon, color: Colors.white60, size: 28),
        onPressed: onPressed,
        hoverColor: AppColors.neonPurple.withValues(alpha: 0.1),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: widget.isMobile ? 420 : widget.isTablet ? 640 : 1000,
      ),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.darkBg,
            border: Border.all(color: Colors.white12, width: 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image_outlined, size: 48, color: Colors.white24),
                  const SizedBox(height: 12),
                  Text(
                    widget.imagePlaceholderLabel,
                    style: const TextStyle(
                      fontFamily: 'PFStardustS',
                      fontSize: 13,
                      color: Colors.white24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 이미지 플레이스홀더용 점선 배경 painter
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    const double gap = 20;
    for (double x = 0; x < size.width; x += gap) {
      for (double y = 0; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// 초대 코드 모달
// ==========================================
class _InviteModalContent extends StatefulWidget {
  const _InviteModalContent();

  @override
  State<_InviteModalContent> createState() => _InviteModalContentState();
}

class _InviteModalContentState extends State<_InviteModalContent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  late AnimationController _glowController;
  late Animation<Color?> _borderColorAnim;
  late Animation<double> _shadowBlurAnim;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _borderColorAnim = ColorTween(
      begin: AppColors.pixelPurple,
      end: AppColors.neonPurpleLight,
    ).animate(_glowController);

    _shadowBlurAnim = Tween<double>(
      begin: 10.0,
      end: 20.0,
    ).animate(_glowController);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _handleEnter() {
    final String code = _codeController.text.trim();
    if (code.isEmpty) return;

    if (LobbyData.getDummyByCode(code) != null) {
      context.pop();
      context.push('/lobby', extra: code);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.darkBg,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(0),
          ),
          title: const Text(
            '알림',
            style: TextStyle(color: Colors.white, fontFamily: 'PFStardustS'),
          ),
          content: const Text(
            '잘못된 코드입니다',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text(
                '확인',
                style: TextStyle(color: AppColors.neonPurpleLight),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: AppColors.darkBg,
            border: Border.all(
              color: _borderColorAnim.value ?? AppColors.pixelPurple,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    _borderColorAnim.value?.withValues(alpha: 0.5) ??
                    AppColors.pixelPurple.withValues(alpha: 0.5),
                blurRadius: _shadowBlurAnim.value,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '초대 코드 입력',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PFStardustS',
                  fontSize: 24,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  border: Border(
                    top: BorderSide(color: AppColors.pixelPurple, width: 2),
                    left: BorderSide(color: AppColors.pixelPurple, width: 2),
                    right: BorderSide(color: AppColors.pixelPurple, width: 2),
                    bottom: BorderSide(color: AppColors.pixelPurple, width: 2),
                  ),
                ),
                child: TextField(
                  controller: _codeController,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'PFStardustS',
                    color: AppColors.pixelPurple,
                    fontSize: 20,
                    letterSpacing: 2.0,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  cursorColor: AppColors.neonPurpleLight,
                  decoration: InputDecoration(
                    hintText: 'ex) 1234ABC',
                    hintStyle: TextStyle(
                      fontFamily: 'WantedSans',
                      color: Colors.purple.shade900,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onSubmitted: (_) => _handleEnter(),
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _handleEnter,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColors.pixelPurple,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonPurpleLight.withValues(
                            alpha: 0.5,
                          ),
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '입장하기',
                        style: TextStyle(
                          fontFamily: 'PFStardustS',
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ==========================================
// 타이핑 애니메이션 및 자막 위젯
// ==========================================
class _TitleAndSubtitleAnimation extends StatefulWidget {
  final double screenWidth;

  const _TitleAndSubtitleAnimation({super.key, required this.screenWidth});

  @override
  State<_TitleAndSubtitleAnimation> createState() =>
      _TitleAndSubtitleAnimationState();
}

class _TitleAndSubtitleAnimationState
    extends State<_TitleAndSubtitleAnimation> {
  bool _hasStarted = false;
  bool _isTypingFinished = false;
  String _currentText = '';

  void _runTypingSequence() async {
    if (_hasStarted) return;
    setState(() {
      _hasStarted = true;
    });

    // 0. 스크롤 진입 시 0.5초 대기
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    const Duration typingSpeed = Duration(milliseconds: 60);
    const Duration backspaceSpeed = Duration(milliseconds: 50);
    const Duration pauseDuration = Duration(milliseconds: 400);

    const String step1 = 'Gifo';
    const String remainingAfterDelete = 't for';

    // 1. "Gifo" 타이핑
    for (int i = 1; i <= step1.length; i++) {
      await Future.delayed(typingSpeed);
      if (!mounted) return;
      setState(() {
        _currentText = step1.substring(0, i);
      });
    }

    // 2. 잠시 대기
    await Future.delayed(pauseDuration);
    if (!mounted) return;

    // 3. 'o' 삭제 -> "Gif" 유지
    await Future.delayed(backspaceSpeed);
    if (!mounted) return;
    setState(() {
      _currentText = 'Gif';
    });
    await Future.delayed(const Duration(milliseconds: 100));

    // 4. "t for ~" 타이핑
    for (int i = 1; i <= remainingAfterDelete.length; i++) {
      await Future.delayed(typingSpeed);
      if (!mounted) return;
      setState(() {
        _currentText = 'Gif${remainingAfterDelete.substring(0, i)}';
      });
    }

    // 5. 커서 숨기고 자막 노출
    setState(() {
      _isTypingFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = widget.screenWidth < AppBreakpoints.mobile;
    final bool isTablet =
        widget.screenWidth >= AppBreakpoints.mobile &&
        widget.screenWidth < AppBreakpoints.tablet;

    final double titleFontSize = isMobile
        ? 26
        : isTablet
        ? 36
        : 48;
    final double subtitleFontSize = isMobile
        ? 13
        : isTablet
        ? 16
        : 22;

    return VisibilityDetector(
      key: const Key('custom-typing-animation'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_hasStarted) {
          _runTypingSequence();
        }
      },
      child: Column(
        children: [
          // 레이아웃 쉬프트 방지용 Stack
          Stack(
            alignment: Alignment.center,
            children: [
              // 공간 확보용 (투명)
              Opacity(
                opacity: 0.0,
                child: Text(
                  'Gift for',
                  style: TextStyle(
                    fontFamily: 'PFStardustS',
                    fontSize: titleFontSize,
                    height: 1.2,
                  ),
                ),
              ),
              // 타이핑 문자열 (진행 중엔 _ 커서 노출)
              Text(
                _hasStarted
                    ? '$_currentText${!_isTypingFinished ? '_' : ''}'
                    : '',
                style: TextStyle(
                  fontFamily: 'PFStardustS',
                  color: Colors.white,
                  fontSize: titleFontSize,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: isMobile ? 10 : 16),
          AnimatedOpacity(
            opacity: _isTypingFinished ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 600),
            child: Text(
              '오직 한 사람을 위한 특별한 선물',
              style: TextStyle(
                fontFamily: 'WantedSans',
                fontSize: subtitleFontSize,
                color: AppColors.neonPurpleLight,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
