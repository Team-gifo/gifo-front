import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../lobby/model/lobby_data.dart';

// 반응형 레이아웃 기준 너비 (태블릿 이하)
const double _kCompactBreakpoint = 768.0;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _codeController = TextEditingController();

  // 모바일에서 검색 모드 여부
  bool _isSearching = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // 초대코드 유효성 검사 후 이동하는 공통 로직
  void _handleEnter(BuildContext context) {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    if (LobbyData.getDummyByCode(code) != null) {
      if (_isSearching) {
        setState(() {
          _isSearching = false;
        });
      }
      context.push('/lobby', extra: code);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('알림'),
          content: const Text('잘못된 코드입니다'),
          actions: [
            TextButton(onPressed: () => context.pop(), child: const Text('확인')),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < _kCompactBreakpoint;

    // 모바일 검색 모드일 때의 Leading
    Widget? leading;
    if (isCompact && _isSearching) {
      leading = IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
        onPressed: () => setState(() => _isSearching = false),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true, // 중앙 배치를 위해 true 설정
        leading: leading,
        leadingWidth: (isCompact && _isSearching) ? 56 : 0, // 검색 모드일 때만 공간 차지
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: isCompact ? 20.0 : 40.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // 로고: 좌측 정렬 (모바일 검색 모드에서는 숨김)
              if (!(isCompact && _isSearching))
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/title_logo.png',
                    height: 60,
                  ),
                ),

              // 검색 바: 중앙 정렬
              // 모바일 검색 모드일 때는 전체 확장, 데스크탑은 maxWidth 제한
              if (!isCompact || _isSearching)
                Padding(
                  padding: EdgeInsets.only(
                    left: (isCompact && _isSearching) ? 0 : 60,
                    top: 10,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: (isCompact && _isSearching)
                          ? double.infinity
                          : 500, // 중앙 집중에 적절한 너비
                    ),
                    child: _InviteCodeSearchBar(
                      controller: _codeController,
                      onChanged: () => setState(() {}),
                      onEnter: () => _handleEnter(context),
                      isCompact: isCompact,
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          if (isCompact && !_isSearching)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: GestureDetector(
                  onTap: () => setState(() => _isSearching = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '입장하기',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.login_rounded,
                          size: 16,
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            // 데스크탑에서는 좌우 균형을 위해 빈 공간 예약
            const SizedBox(width: 40),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 1. 메인 타이틀 섹션
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 180.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Gifo for (~를 위한 선물)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '상대방에게 소중한 추억을 남겨주세요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        final Uri url = Uri.base.resolve('/addgift');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, webOnlyWindowName: '_blank');
                        } else {
                          if (context.mounted) {
                            context.push('/');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 20.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '선물 포장하러가기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. 서비스 소개 섹션
            Container(
              width: double.infinity,
              color: Colors.grey.shade50,
              padding: const EdgeInsets.symmetric(
                vertical: 100.0,
                horizontal: 24.0,
              ),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Gifo, 어떤 서비스인가요?',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Wrap(
                    spacing: 24.0,
                    runSpacing: 24.0,
                    alignment: WrapAlignment.center,
                    children: List<Widget>.generate(3, (int index) {
                      return Container(
                        width: 320,
                        height: 240,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '소개 카드 예시 ${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // 3. 하단 권유 섹션
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 120.0,
                horizontal: 24.0,
              ),
              child: const Column(
                children: <Widget>[
                  Text(
                    '지금 바로 특별한 선물을 준비해보세요.',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '몇 번의 클릭만으로 링크로 전달할 수 있습니다.',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 초대코드 입력 + 입장하기 버튼이 통합된 검색 바 위젯
class _InviteCodeSearchBar extends StatelessWidget {
  const _InviteCodeSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onEnter,
    required this.isCompact,
  });

  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback onEnter;
  // 모바일 드롭다운일 때 패딩 등 미세 조정에 사용
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    // 텍스트 입력 여부에 따라 버튼 활성화 상태 결정
    final bool hasText = controller.text.trim().isNotEmpty;

    return Container(
      height: isCompact ? 52 : 48,
      decoration: BoxDecoration(
        color: Colors.white, // 배경색을 화이트로 변경
        borderRadius: BorderRadius.circular(999), // Pill 형태
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          // 좌측 아이콘
          const SizedBox(width: 16),
          const Icon(Icons.confirmation_number, color: Colors.orange, size: 18),
          const SizedBox(width: 10),

          // 초대코드 입력 필드
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (_) => onChanged(),
              onSubmitted: (_) => onEnter(),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              decoration: InputDecoration(
                hintText: '친구에게 전달받은 초대코드',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          // 텍스트가 있을 때만 X 버튼 표시
          if (hasText)
            GestureDetector(
              onTap: () {
                controller.clear();
                onChanged();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.grey.shade400,
                  size: 18,
                ),
              ),
            ),

          // 구분선
          Container(width: 1, height: 24, color: Colors.grey.shade300),

          // 입장하기 버튼 (우측)
          GestureDetector(
            onTap: hasText ? onEnter : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '입장하기',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: hasText ? Colors.black87 : Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.login_rounded,
                    size: 16,
                    color: hasText ? Colors.black87 : Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
