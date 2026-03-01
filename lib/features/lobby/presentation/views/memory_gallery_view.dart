import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  late LobbyData lobbyData;
  late List<GalleryItem> _galleryItems;

  @override
  void initState() {
    super.initState();
    // 로비 데이터를 불러와 갤러리 리스트 초기화
    lobbyData = LobbyData.getDummyByCode(widget.code)!;
    _galleryItems = lobbyData.gallery;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 800;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 제거
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset('assets/images/title_logo.png', height: 50),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                // 상단 패딩
                Expanded(
                  child: PageView.builder(
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
                      });
                    },
                    itemCount: _galleryItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final GalleryItem item = _galleryItems[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 64.0 : 24.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // 1. 제목
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: isDesktop ? 32 : 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: isDesktop ? 48 : 32),
                            // 2. 이미지 (좌우 슬라이드)
                            Container(
                              constraints: BoxConstraints(
                                // PC 환경: 최대 가로 길이를 넓게 설정(1000), 높이 비율 60%
                                // 모바일/태블릿 환경: 화면 전체 가로 및 높이 비율 55%를 활용하여 세로 이점 확보
                                maxHeight: isDesktop
                                    ? size.height * 0.6
                                    : size.height * 0.55,
                                maxWidth: isDesktop ? 1000 : double.infinity,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.asset(
                                  item.imageUrl,
                                  fit: BoxFit.contain, // 비율 유지하여 전체 이미지 표시
                                ),
                              ),
                            ),
                            SizedBox(height: isDesktop ? 48 : 32),
                            // 3. 내용 (설명)
                            Text(
                              item.description,
                              style: TextStyle(
                                fontSize: isDesktop ? 20 : 16,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // 페이지 인디케이터 (점)
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
                            ? Colors.black
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80), // 하단 버튼을 위한 여백
              ],
            ),

            // 좌측 이전 화살표 (데스크톱 전용)
            if (isDesktop)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 48.0),
                  child: IconButton(
                    iconSize: 48,
                    color: Colors.black54,
                    hoverColor: Colors.black12,
                    icon: const Icon(Icons.arrow_back),
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

            // 우측 다음 화살표 (데스크톱 전용)
            if (isDesktop)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 48.0),
                  child: IconButton(
                    iconSize: 48,
                    color: Colors.black54,
                    hoverColor: Colors.black12,
                    icon: const Icon(Icons.arrow_forward),
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

            // 우측 하단 선물 확인하기 버튼
            Positioned(
              bottom: 24,
              right: 24,
              child: ElevatedButton(
                onPressed: () {
                  if (lobbyData.content != null) {
                    if (lobbyData.content!.gacha != null) {
                      context.push('/content/gacha', extra: widget.code);
                    } else if (lobbyData.content!.quiz != null) {
                      context.push('/content/quiz', extra: widget.code);
                    } else if (lobbyData.content!.unboxing != null) {
                      // context.push('/content/unboxing', extra: widget.code);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6ED4FF), // 예시 이미지와 유사한 하늘색
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '선물 확인하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
