import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset('assets/images/title_logo.png', height: 50),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // 초대코드 입력용 TextField
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _codeController,
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: '친구에게 받은 초대코드 (혹은 주소)',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // 입장하기 버튼
                ElevatedButton(
                  onPressed: _codeController.text.isEmpty
                      ? null
                      : () {
                          // 입력된 초대 코드의 유효성 검사
                          if (_codeController.text == 'helloworld') {
                            context.push('/lobby');
                          } else {
                            // 잘못된 코드 알림 표시
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('알림'),
                                content: const Text('잘못된 코드입니다'),
                                actions: [
                                  TextButton(
                                    onPressed: () => context.pop(),
                                    child: const Text('확인'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('입장하기'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 1. 메인 타이틀 섹션 (첫 화면 영역)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 180.0,
              ), // 첫 화면에 텍스트가 중앙에 위치하도록 상하 여백 추가
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // 서비스 기본 타이틀 및 설명
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
                      onPressed: () {
                        context.push(
                          '/addgift/receiver-name',
                        ); // 선물 포장 - 받는 분 성함 입력 화면으로 이동
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

            // 2. 서비스 소개 섹션 (스크롤 시 보이는 예시 데이터)
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

            // 3. 하단 권유 섹션 예시
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
