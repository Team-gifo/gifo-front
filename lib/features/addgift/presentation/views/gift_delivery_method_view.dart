import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/gift_packaging_bloc.dart';
import '../../model/gacha_content.dart';

class GiftDeliveryMethodView extends StatelessWidget {
  const GiftDeliveryMethodView({super.key});

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
                      // 우측 그리드 목록
                      Expanded(
                        flex: 2, // 그리드 부분이 좀 더 넓게 차지하도록
                        child: _buildGridOptions(isDesktop: true),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // 모바일 환경
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 40),
                      _buildMainText(TextAlign.center),
                      const SizedBox(height: 60),
                      _buildGridOptions(isDesktop: false),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
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
      '친구에게 전달할 방식을\n선택해주세요 !',
      textAlign: alignment,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.4,
      ),
    );
  }

  // 선택지 그리드 목록
  Widget _buildGridOptions({required bool isDesktop}) {
    // 항목 데이터
    final List<Map<String, String>> options = <Map<String, String>>[
      <String, String>{
        'title': '캡슐 뽑기',
        'icon': 'assets/images/gacha_machine.png', // 실제 이미지 에셋 경로 사용
        'type': 'image', // 아이콘인지 이미지인지 구분
      },
      <String, String>{
        'title': '문제 맞추기',
        'icon': 'assets/images/quiz_character.png',
        'type': 'image',
      },
      <String, String>{
        'title': '바로 오픈',
        'icon': 'assets/images/open_gift_box.png',
        'type': 'image',
      },
    ];

    // 모바일 환경은 2열, 데스크톱 환경은 3열로 설정하여 최대 3개 배치 요구 조건 충족
    final int crossAxisCount = isDesktop ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 0.8, // 세로로 좀 더 긴 형태
      ),
      itemCount: options.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildDeliveryOptionCard(
          title: options[index]['title']!,
          iconData: options[index]['icon']!,
          type: options[index]['type']!,
          onTap: () => _handleOptionTap(context, options[index]['title']!),
        );
      },
    );
  }

  Future<void> _handleOptionTap(BuildContext context, String title) async {
    final bloc = context.read<GiftPackagingBloc>();
    final state = bloc.state;

    // 현재 각 콘텐츠별 데이터 유무 확인
    final savedGacha = state.gachaContent;
    final bool hasGachaData = savedGacha != null && savedGacha.list.isNotEmpty;

    ContentType selectedType = ContentType.gacha;
    String route = '/addgift/gacha-setting';

    if (title == '캡슐 뽑기') {
      selectedType = ContentType.gacha;
      route = '/addgift/gacha-setting';
    } else if (title == '문제 맞추기') {
      selectedType = ContentType.quiz;
      route = '/addgift/quiz-setting';
    } else if (title == '바로 오픈') {
      selectedType = ContentType.unboxing;
      route = '/addgift/direct-open-setting';
    }

    if (hasGachaData && selectedType != ContentType.gacha) {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            '콘텐츠 변경',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            '캡슐 뽑기에 작성 중인 데이터가 있습니다.\n초기화하고 새로운 콘텐츠로 넘어가겠습니까?',
            style: TextStyle(height: 1.5, fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(
                '아니오',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                '예',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirm == true) {
        // 기존 캡슐 뽑기 데이터 초기화
        bloc.add(SetGachaContent(const GachaContent()));
        bloc.add(SetContentType(selectedType));
        if (context.mounted) {
          context.push(route);
        }
      }
    } else {
      bloc.add(SetContentType(selectedType));
      context.push(route);
    }
  }

  // 개별 방식 선택 카드
  Widget _buildDeliveryOptionCard({
    required String title,
    required String iconData,
    required String type,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 이미지 또는 아이콘 표시 영역
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent, // 이미지 배경 투명하게
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: type == 'image'
                      ? Image.asset(iconData, fit: BoxFit.contain)
                      : Icon(
                          _getIconForTitle(title),
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 항목별 임시 아이콘 반환용 유틸리티 함수
  IconData _getIconForTitle(String title) {
    switch (title) {
      case '캡슐 뽑기':
        return Icons.catching_pokemon_outlined; // 유사한 모양으로 대체
      case '문제 맞추기':
        return Icons.quiz_outlined;
      case '바로 오픈':
        return Icons.card_giftcard_outlined;
      default:
        return Icons.image_outlined;
    }
  }

  // 상단 진행 단계 인디케이터 위젯 (현재 3단계로 가정)
  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildCircle(isActive: true, number: '1'),
          _buildLine(isActive: true),
          _buildCircle(isActive: true, number: '2'),
          _buildLine(isActive: true),
          _buildCircle(isActive: true, number: '3'),
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
