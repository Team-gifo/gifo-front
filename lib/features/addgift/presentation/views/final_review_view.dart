import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/gift_packaging_bloc.dart';

class FinalReviewView extends StatelessWidget {
  const FinalReviewView({super.key, this.fromAi = false});

  /// AI 추천 설문 직후 진입이면 true
  final bool fromAi;

  @override
  Widget build(BuildContext context) {
    final GiftPackagingState state = context.watch<GiftPackagingBloc>().state;

    return Title(
      title: '최종 확인 - Gifo',
      color: Colors.black,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          toolbarHeight: 68,
          backgroundColor: const Color(0xFFF8F9FA),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => context.go('/'),
          ),
          title: const Text(
            '최종 확인',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    '포장 전에 한번 더\n내용을 확인해주세요.',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _section(
                    title: '받는 사람',
                    child: Text(
                      state.receiverName.isNotEmpty ? state.receiverName : '입력되지 않음',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _section(
                    title: '메인 문구',
                    child: Text(
                      state.subTitle.isNotEmpty ? state.subTitle : '입력되지 않음',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _section(
                    title: 'BGM',
                    child: Text(
                      state.bgm.isNotEmpty ? state.bgm : '입력되지 않음',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _section(
                    title: '추억 갤러리',
                    child: state.gallery.isEmpty
                        ? const Text('추억 갤러리가 비어 있어요.', style: TextStyle(fontSize: 16))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: state.gallery
                                .map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      '• ${item.title} - ${item.description}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                  const SizedBox(height: 12),
                  _section(
                    title: '전달 방식',
                    child: Text(
                      _contentTypeLabel(state.selectedContentType),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '필요하다면 [수정하기]를 눌러\n이전 단계에서 내용을 다시 손볼 수 있어요.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      // AI에서 온 경우: 상태 유지한 채 수동 플로우 1단계로 이동
                      // (ReceiverNameView가 reset하지 않도록 resume=true)
                      if (fromAi) {
                        context.push('/addgift?resume=true');
                      } else {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      '수정하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // AI 추천이면 바로 추천된 콘텐츠 세팅으로 보내주는 편이 UX가 좋음
                      final route = switch (state.selectedContentType) {
                        ContentType.gacha => '/addgift/gacha-setting',
                        ContentType.quiz => '/addgift/quiz-setting',
                        ContentType.unboxing => '/addgift/direct-open-setting',
                        null => '/addgift/delivery-method',
                      };
                      context.push(route);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '이대로 진행하기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

  static Widget _section({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  static String _contentTypeLabel(ContentType? type) {
    return switch (type) {
      ContentType.gacha => '캡슐 뽑기',
      ContentType.quiz => '문제 맞추기',
      ContentType.unboxing => '바로 오픈',
      null => '선택되지 않음',
    };
  }
}

