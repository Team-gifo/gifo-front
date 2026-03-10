import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MemoryDecisionView extends StatelessWidget {
  const MemoryDecisionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        toolbarHeight: 68,
        backgroundColor: const Color(0xFFF8F9FA),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        actions: <Widget>[_buildStepIndicator()],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // 화면 너비가 800 이상이면 데스크톱(가로) 배치, 미만이면 모바일(세로) 배치
            final bool isDesktop = constraints.maxWidth >= 800;

            if (isDesktop) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 24.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // 좌측 텍스트
                      Expanded(flex: 1, child: _buildMainText(TextAlign.left)),
                      const SizedBox(width: 80),
                      // 우측 버튼 목록
                      Expanded(flex: 1, child: _buildButtonsColumn(context)),
                    ],
                  ),
                ),
              );
            } else {
              // 모바일 및 아이패드 환경: 스크롤 가능하되 내용물이 적으면 버튼이 하단에 배치됨
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(height: 48),
                          _buildMainText(TextAlign.center),
                          const Spacer(),
                          const SizedBox(height: 48),
                          _buildButtonsColumn(context),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // 안내 문구 위젯 (텍스트 정렬 방향 동적 적용)
  Widget _buildMainText(TextAlign alignment) {
    return Text(
      '선물을 공개하기 전,\n친구와 추억을 공유할까요?',
      textAlign: alignment,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.4,
      ),
    );
  }

  // 선택 버튼 목록을 담은 Column
  Widget _buildButtonsColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // 첫 번째 옵션
        _buildSelectionButton(
          title: '네,',
          subtitle: '저는 친구와 함께 추억을 공유하고 싶어요!',
          icon: Icons.photo_library_rounded,
          onPressed: () {
            // 추억 공유 기능을 거쳐가는 2단계(갤러리 셋팅)로 이동
            context.push('/addgift/memory-gallery');
          },
        ),
        const SizedBox(height: 16),
        // 두 번째 옵션
        _buildSelectionButton(
          title: '아니요,',
          subtitle: '저는 바로 선물을 공개할거에요.',
          icon: Icons.card_giftcard_rounded,
          onPressed: () {
            // 추억 공유 없이 3단계로 이동 -> 배송 방식 선택으로 라우팅 완료
            context.push('/addgift/delivery-method');
          },
        ),
      ],
    );
  }

  // 개별 선택 버튼 빌더
  Widget _buildSelectionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final Color contentColor = Colors.black;

    // 버튼 내부에 렌더링될 위젯 구조
    final Widget buttonContent = Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: contentColor),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26, // 크기를 좀 더 크게
              fontWeight: FontWeight.bold,
              height: 1.3,
              color: contentColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: contentColor,
            ),
          ),
        ],
      ),
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.grey.shade400, width: 2.0),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      child: buttonContent,
    );
  }

  // 상단 진행 단계 인디케이터 위젯 (현재 2단계)
  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildCircle(isActive: true, number: '1'),
          _buildLine(isActive: true),
          _buildCircle(isActive: true, number: '2'),
          _buildLine(isActive: false),
          _buildCircle(isActive: false, number: '3'),
        ],
      ),
    );
  }

  // 인디케이터 원형 위젯
  Widget _buildCircle({required bool isActive, required String number}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black : Colors.grey.shade200,
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 인디케이터 연결 선 위젯
  Widget _buildLine({required bool isActive}) {
    return Container(
      width: 16,
      height: 2,
      color: isActive ? Colors.black : Colors.grey.shade200,
    );
  }
}
