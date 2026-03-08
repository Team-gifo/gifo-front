import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/unboxing/unboxing_bloc.dart';

class UnboxingView extends StatefulWidget {
  final String code;

  const UnboxingView({super.key, required this.code});

  @override
  State<UnboxingView> createState() => _UnboxingViewState();
}

class _UnboxingViewState extends State<UnboxingView> {
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    context.read<UnboxingBloc>().add(InitUnboxing(widget.code));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900;

    return BlocConsumer<UnboxingBloc, UnboxingState>(
      // 선물 수령 완료 시 결과 화면으로 이동
      listener: (context, state) {
        if (state.isReceived && state.unboxingContent != null) {
          context.push(
            '/content/result',
            extra: <String, dynamic>{
              'itemName': state.unboxingContent!.afterOpen.itemName,
              'imageUrl': state.unboxingContent!.afterOpen.imageUrl,
            },
          );
        }
      },
      builder: (context, state) {
        if (state.unboxingContent == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(state, size),
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.asset(
                                state.unboxingContent!.beforeOpen.imageUrl,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: isDesktop ? 500 : 350,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              state.unboxingContent!.beforeOpen.description,
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
                      if (isDesktop) _buildReceiveButton(isDesktop: true),
                      if (isDesktop) const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: isDesktop
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildReceiveButton(isDesktop: false),
                  ),
                ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(UnboxingState state, Size size) {
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
                      text: state.userName,
                      style: const TextStyle(color: Colors.blue),
                    ),
                    const TextSpan(text: '님의 '),
                    TextSpan(
                      text: state.subTitle,
                      style: const TextStyle(color: Colors.blue),
                    ),
                    const TextSpan(text: ' 선물상자'),
                  ],
                ),
              )
            else
              Expanded(
                child: Text(
                  '${state.userName}님의 ${state.subTitle} 선물상자',
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
    );
  }

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
          onPressed: () =>
              context.read<UnboxingBloc>().add(const ReceiveGift()),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC7DEFF),
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
