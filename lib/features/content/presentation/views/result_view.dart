import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultView extends StatelessWidget {
  final String itemName;
  final String imageUrl;

  const ResultView({super.key, required this.itemName, required this.imageUrl});

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
          child: Image.asset('assets/images/title_logo.png', height: 50),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 48.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 축하 문구
                const Text(
                  '생일 축하드립니다 !',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // 물품 이미지 (네트워크 및 로컬 경로 대응)
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 300,
                    maxWidth: 500,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageUrl.startsWith('http')
                        ? Image.network(imageUrl, fit: BoxFit.contain)
                        : Image.asset(imageUrl, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 48),

                // 물품명 (선물 결과)
                Text(
                  '선물 결과 : $itemName',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // 친구한테 결과 공유하기 버튼
                ElevatedButton(
                  onPressed: () {
                    // 추후 공유하기 기능 연동 예정 (임시 알림 처리)
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('공유하기'),
                        content: const Text('친구에게 공유하는 기능이 팝업될 예정입니다.'),
                        actions: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: const Text('확인'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC7DEFF), // 연한 하늘색 배경
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '친구한테 결과 공유하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                // 홈으로 돌아가기 버튼
                TextButton(
                  onPressed: () {
                    // 공유 완료하거나 그만둘 때 메인 홈으로 돌려보냄
                    context.go('/');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                  ),
                  child: const Text(
                    '홈으로 돌아가기',
                    style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
