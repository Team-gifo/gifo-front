import 'package:flutter/material.dart';

import '../../../../core/widgets/shared_confetti_widget.dart';
import '../../data/models/lobby_data.dart';

class LobbyView extends StatefulWidget {
  final LobbyData data;

  const LobbyView({super.key, required this.data});

  @override
  State<LobbyView> createState() => _LobbyViewState();
}

class _LobbyViewState extends State<LobbyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 제거
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset(
            'assets/images/title_logo.png',
            height: 50,
          ), // 메인 로고 변경 및 텍스트 제거
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // 화면 상단에서 흩뿌려지는 색종이 애니메이션
            const Align(
              alignment: Alignment.topCenter,
              child: SharedConfettiWidget(autoPlay: true),
            ),
            Column(
              children: <Widget>[
                // 상단 텍스트와 중앙 파티룸을 묶어서 화면 비율에 맞춰 중앙 정렬
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 40),
                      // 1. 상단 텍스트 영역
                      Column(
                        children: <Widget>[
                          Text(
                            '${widget.data.user} 생일 축하해 !',
                            style: const TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.data.subTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40), // 텍스트와 파티룸 사이 간격
                      // 2. 중앙 파티룸 (Stack 형태)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Stack(
                            alignment: Alignment.center, // 요소들을 Stack 중앙에 배치
                            children: <Widget>[
                              // 배경 이미지 (싸이월드 파티룸 스타일)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                        'assets/images/room_bg.png',
                                      ),
                                      fit: BoxFit.contain, // 이미지가 짤리지 않게 전체 표시
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. 하단 게임 시작 버튼 영역
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // 추후 콘텐츠 이용 화면으로 이동하는 로직이 추가될 예정
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        '입장하기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
