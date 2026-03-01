import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../lobby/model/lobby_data.dart';

class UnboxingView extends StatefulWidget {
  final String code;

  const UnboxingView({super.key, required this.code});

  @override
  State<UnboxingView> createState() => _UnboxingViewState();
}

class _UnboxingViewState extends State<UnboxingView> {
  late LobbyData lobbyData;
  late UnboxingContent unboxingContent;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    // 전달된 코드를 바탕으로 모델 초기화 (라우터 로직을 통해 보장되었다고 가정)
    lobbyData = LobbyData.getDummyByCode(widget.code)!;
    unboxingContent = lobbyData.content!.unboxing!;
  }

  void _onReceiveGift() {
    // 선물 받기 버튼 클릭 시 결과창으로 이동
    context.push(
      '/content/result',
      extra: <String, dynamic>{
        'itemName': unboxingContent.afterOpen.itemName,
        'imageUrl': unboxingContent.afterOpen.imageUrl,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Image.asset('assets/images/title_logo.png', height: 50),
              const SizedBox(width: 16),
              // 데스크탑/모바일에 따라 타이틀 텍스트 크기 조정
              if (size.width > 600)
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: lobbyData.user,
                        style: const TextStyle(color: Colors.blue),
                      ),
                      const TextSpan(text: '님의 '),
                      TextSpan(
                        text: lobbyData.subTitle,
                        style: const TextStyle(color: Colors.blue),
                      ),
                      const TextSpan(text: ' 선물상자'),
                    ],
                  ),
                )
              else
                Expanded(
                  child: Text(
                    '${lobbyData.user}님의 ${lobbyData.subTitle} 선물상자',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (isDesktop) const SizedBox(height: 48),

                  Container(
                    constraints: const BoxConstraints(maxWidth: 700),
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: <Widget>[
                        // 상자 이미지 (beforeOpen.imageUrl)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            unboxingContent.beforeOpen.imageUrl,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: isDesktop ? 500 : 350,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // 2. 설명 텍스트 (beforeOpen.description)
                        Text(
                          unboxingContent.beforeOpen.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // 데스크탑인 경우 버튼을 컨텐츠 바로 하단에 배치
                  if (isDesktop) _buildReceiveButton(isDesktop: true),

                  if (isDesktop) const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
      // 모바일인 경우 버튼을 화면 최하단에 고정
      bottomNavigationBar: isDesktop
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildReceiveButton(isDesktop: false),
              ),
            ),
    );
  }

  // 선물 받기 버튼 위젯
  Widget _buildReceiveButton({required bool isDesktop}) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovering ? -5 : 0, 0),
        width: isDesktop ? 400 : double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: _onReceiveGift,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC7DEFF), // 포인트 버튼 색상 (연한 파랑)
            foregroundColor: Colors.black,
            elevation: _isHovering ? 8 : 4,
            shadowColor: Colors.blue.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          child: const Text(
            '🎁 선물 받기',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
