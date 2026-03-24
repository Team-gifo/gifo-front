import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifo/features/lobby/model/lobby_data.dart';
import 'package:go_router/go_router.dart';

import '../../application/gacha/gacha_bloc.dart';

class GachaView extends StatefulWidget {
  final String code;

  const GachaView({super.key, required this.code});

  @override
  State<GachaView> createState() => _GachaViewState();
}

class _GachaViewState extends State<GachaView> {
  @override
  void initState() {
    super.initState();
    context.read<GachaBloc>().add(InitGacha(widget.code));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900;

    return BlocConsumer<GachaBloc, GachaState>(
      // 뽑기 결과가 나오면 결과 화면으로 이동
      listener: (BuildContext context, GachaState state) {
        if (state.lastDrawnItem != null) {
          context.push(
            '/content/result',
            extra: <String, String>{
              'itemName': state.lastDrawnItem!.itemName,
              'imageUrl': state.lastDrawnItem!.imageUrl,
              'userName': state.userName,
            },
          );
        }
      },
      builder: (BuildContext context, GachaState state) {
        if (state.gachaContent == null) {
          return Title(
            title: 'Happy Birthday, ${state.userName} | Gifo',
            color: Colors.black,
            child: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return Title(
          title: 'Happy Birthday, ${state.userName} | Gifo',
          color: Colors.black,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildAppBar(state, isDesktop),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: isDesktop
                  ? _buildDesktopLayout(state)
                  : _buildMobileLayout(state),
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
                    child: _buildDrawButton(state, isMobile: true),
                  ),
                ),
        ));
      },
    );
  }

  PreferredSizeWidget _buildAppBar(GachaState state, bool isDesktop) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Image.asset('assets/images/title_logo.png', height: 50),
            const SizedBox(width: 16),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: <InlineSpan>[
                  TextSpan(
                    text: state.userName,
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
          : <Widget>[
              IconButton(
                icon: const Icon(Icons.history, color: Colors.black),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('히스토리'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: _buildHistoryBoard(state),
                      ),
                      actions: <Widget>[
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
    );
  }

  Widget _buildDesktopLayout(GachaState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 32),
              Text(
                '남은 기회 : ${state.remainingCount}회',
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
        Expanded(
          flex: 6,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: _buildPrizeListBoard(state)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildHistoryBoard(state)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildDrawButton(state, isMobile: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(GachaState state) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          Text(
            '남은 기회 : ${state.remainingCount}회',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Image.asset(
            'assets/images/gacha_machine.png',
            fit: BoxFit.contain,
            height: 300,
          ),
          const SizedBox(height: 32),
          _buildPrizeListBoard(state),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPrizeListBoard(GachaState state) {
    return Column(
      children: <Widget>[
        const Text(
          '경품 목록',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: state.gachaContent!.list.length,
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16),
            itemBuilder: (BuildContext context, int index) {
              final GachaItem item = state.gachaContent!.list[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
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

  Widget _buildHistoryBoard(GachaState state) {
    return Column(
      children: <Widget>[
        const Text(
          '히스토리',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: state.history.isEmpty
              ? const Center(
                  child: Text(
                    '아직 뽑은 기록이 없어요.',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.history.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (BuildContext context, int index) {
                    final Map<String, String> h = state.history[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                            children: <InlineSpan>[
                              TextSpan(
                                text: '"${h['item']}"',
                                style: const TextStyle(
                                  color: Colors.redAccent,
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

  Widget _buildDrawButton(GachaState state, {required bool isMobile}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: state.remainingCount > 0
            ? () => context.read<GachaBloc>().add(const DrawGacha())
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC7DEFF),
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
