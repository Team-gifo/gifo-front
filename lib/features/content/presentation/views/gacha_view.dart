import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../lobby/data/models/lobby_data.dart';

class GachaView extends StatefulWidget {
  final String code;

  const GachaView({super.key, required this.code});

  @override
  State<GachaView> createState() => _GachaViewState();
}

class _GachaViewState extends State<GachaView> {
  late LobbyData lobbyData;
  late GachaContent gachaContent;
  late int remainingCount;

  // 뽑기 히스토리 목록
  final List<Map<String, String>> history = [];

  @override
  void initState() {
    super.initState();
    // 이전 라우터 로직을 통해 캡슐 데이터가 보장된 상태라고 가정
    lobbyData = LobbyData.getDummyByCode(widget.code)!;
    gachaContent = lobbyData.content!.gacha!;
    remainingCount = gachaContent.playCount;
  }

  // 간단한 날짜 포맷 함수
  String _formatTime(DateTime time) {
    final month = time.month;
    final day = time.day;
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final ampm = hour < 12 ? '오전' : '오후';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$month월 $day일 $ampm $hour12시 $minute분';
  }

  void _drawGacha() {
    if (remainingCount <= 0) return;

    setState(() {
      remainingCount--;
    });

    // 랜덤 상품 뽑기
    final randomItem =
        gachaContent.list[Random().nextInt(gachaContent.list.length)];

    final timeStr = _formatTime(DateTime.now());

    setState(() {
      history.insert(0, {'time': timeStr, 'item': randomItem.itemName});
    });

    // 결과창으로 이동 (실제 반환될 결과 데이터 전송)
    context.push(
      '/content/result',
      extra: {'itemName': randomItem.itemName, 'imageUrl': randomItem.imageUrl},
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Image.asset('assets/images/title_logo.png', height: 50),
              const SizedBox(width: 16),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: lobbyData.user,
                      style: const TextStyle(color: Colors.blue),
                    ),
                    const TextSpan(text: '님의 '),
                    const TextSpan(
                      text: '신나는 오락',
                      style: TextStyle(color: Colors.blue),
                    ),
                    const TextSpan(text: ' 뽑기'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: isDesktop
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.history, color: Colors.black),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('히스토리'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: _buildHistoryBoard(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: const Text('닫기'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8.0),
              ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
        ),
      ),
      bottomNavigationBar: isDesktop
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: _buildDrawButton(isMobile: true),
              ),
            ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 왼쪽 기계 영역
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text(
                '남은 기회 : $remainingCount회',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/gacha_machine.png',
                fit: BoxFit.contain,
                height: 500,
              ),
            ],
          ),
        ),
        const SizedBox(width: 48),
        // 2. 오른쪽 목록 및 컨트롤 영역
        Expanded(
          flex: 6,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildPrizeListBoard()),
                    const SizedBox(width: 24),
                    Expanded(child: _buildHistoryBoard()),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildDrawButton(isMobile: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            '남은 기회 : $remainingCount회',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Image.asset(
            'assets/images/gacha_machine.png',
            fit: BoxFit.contain,
            height: 300,
          ),
          const SizedBox(height: 32),
          _buildPrizeListBoard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 경품 목록 위젯
  Widget _buildPrizeListBoard() {
    return Column(
      children: [
        const Text(
          '경품 목록',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 400, // 통일된 높이
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: gachaContent.list.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = gachaContent.list[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.itemName, style: const TextStyle(fontSize: 16)),
                  Text(
                    item.percentOpen
                        ? '${item.percent.toStringAsFixed(item.percent == item.percent.toInt() ? 0 : 3)}%'
                        : '비공개',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // 히스토리 목록 위젯
  Widget _buildHistoryBoard() {
    return Column(
      children: [
        const Text(
          '히스토리',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 400, // 통일된 높이
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: history.isEmpty
              ? const Center(
                  child: Text(
                    '아직 뽑은 기록이 없어요.',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: history.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final h = history[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h['time']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: '"${h['item']}"',
                                style: const TextStyle(
                                  color: Colors.redAccent, // 뽑은 아이템 강조 (이미지 참고)
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: ' 를 뽑았습니다.'),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }

  // 봅기 버튼
  Widget _buildDrawButton({required bool isMobile}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: remainingCount > 0 ? _drawGacha : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC7DEFF), // 연한 하늘색 배경
          foregroundColor: Colors.black,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          '지금 뽑기',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
