
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../lobby/application/lobby_bloc.dart';

class InviteModalContent extends StatelessWidget {
  const InviteModalContent({super.key});

  @override
  Widget build(BuildContext context) {
    // LobbyBloc을 이 위젯 트리에 주입 (모달 단위 스코프)
    return BlocProvider(
      create: (_) => LobbyBloc(),
      child: const _InviteModalBody(),
    );
  }
}

// 실제 UI와 Bloc 연동을 담당하는 내부 위젯
class _InviteModalBody extends StatefulWidget {
  const _InviteModalBody();

  @override
  State<_InviteModalBody> createState() => _InviteModalBodyState();
}

class _InviteModalBodyState extends State<_InviteModalBody>
    with SingleTickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  late AnimationController _glowController;
  late Animation<Color?> _borderColorAnim;
  late Animation<double> _shadowBlurAnim;

  bool _isInputEmpty = true;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _borderColorAnim = ColorTween(
      begin: AppColors.pixelPurple,
      end: AppColors.neonPurpleLight,
    ).animate(_glowController);

    _shadowBlurAnim = Tween<double>(
      begin: 10.0,
      end: 20.0,
    ).animate(_glowController);

    _codeController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final bool isEmpty = _codeController.text.isEmpty;
    if (_isInputEmpty != isEmpty) {
      setState(() => _isInputEmpty = isEmpty);
    }
  }

  @override
  void dispose() {
    _codeController.removeListener(_onTextChanged);
    _codeController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final ClipboardData? data = await Clipboard.getData('text/plain');
    if (data?.text != null) {
      setState(() {
        _codeController.text = data!.text!.trim().toUpperCase();
        _codeController.selection = TextSelection.fromPosition(
          TextPosition(offset: _codeController.text.length),
        );
      });
    }
  }

  // 코드 제출: Bloc 이벤트만 발행, 결과 처리는 BlocListener가 담당
  void _handleEnter() {
    final String code = _codeController.text.trim();
    if (code.isEmpty) return;
    context.read<LobbyBloc>().add(SubmitInviteCode(code));
  }

  // 유효한 코드를 새 창으로 열기 (/gift/code/{code})
  Future<void> _openGiftPage(BuildContext context, String code) async {
    // 모달을 먼저 닫고 새 창 열기
    if (context.mounted) context.pop();

    final Uri giftUrl = Uri.base.resolve('/gift/code/$code');
    if (await canLaunchUrl(giftUrl)) {
      unawaited(launchUrl(giftUrl, webOnlyWindowName: '_blank'));
    } else {
      // 새 창을 열 수 없는 환경(네이티브 등)에서는 현재 탭에서 이동
      if (context.mounted) context.push('/gift/code/$code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LobbyBloc, LobbyState>(
      // 상태 변화에 따른 사이드 이펙트 처리
      listener: (context, state) {
        if (state.status == LobbyCodeStatus.valid &&
            state.validatedCode != null) {
          _openGiftPage(context, state.validatedCode!);
        }
      },
      builder: (context, state) {
        final bool isLoading = state.status == LobbyCodeStatus.loading;
        final bool hasError = state.status == LobbyCodeStatus.invalid;

        return AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: AppColors.darkBg,
                border: Border.all(
                  color: _borderColorAnim.value ?? AppColors.pixelPurple,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        _borderColorAnim.value?.withValues(alpha: 0.5) ??
                        AppColors.pixelPurple.withValues(alpha: 0.5),
                    blurRadius: _shadowBlurAnim.value,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '초대 코드 입력',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PFStardustS',
                      fontSize: 24,
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  // 에러 발생 시 문구 출력 영역
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: hasError ? 24 : 0,
                    child: hasError
                        ? const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              '잘못된 코드입니다',
                              style: TextStyle(
                                fontFamily: 'WantedSans',
                                color: Colors.redAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 32),
                  // TextField 영역
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: hasError
                            ? Colors.redAccent
                            : AppColors.pixelPurple,
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: _codeController,
                      autofocus: true,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontFamily: 'WantedSans',
                        color: Colors.white,
                        fontSize: 24,
                        letterSpacing: 2.0,
                      ),
                      textCapitalization: TextCapitalization.characters,
                      cursorColor: hasError
                          ? Colors.redAccent
                          : AppColors.neonPurpleLight,
                      // 로딩 중에는 입력 비활성화
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: 'EX) 1234ABC',
                        hintStyle: const TextStyle(
                          fontFamily: 'WantedSans',
                          color: Colors.white24,
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        suffixIcon: isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.neonPurpleLight,
                                  ),
                                ),
                              )
                            : _isInputEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.content_paste_rounded,
                                  color: AppColors.pixelPurple,
                                ),
                                tooltip: '클립보드 붙여넣기',
                                onPressed: _pasteFromClipboard,
                              )
                            : IconButton(
                                icon: const Icon(
                                  Icons.cancel_rounded,
                                  color: Colors.white54,
                                ),
                                tooltip: '지우기',
                                onPressed: () => _codeController.clear(),
                              ),
                      ),
                      onSubmitted: (_) => _handleEnter(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 입장하기 버튼
                  GestureDetector(
                    onTap: (_isInputEmpty || isLoading) ? null : _handleEnter,
                    child: MouseRegion(
                      cursor: (_isInputEmpty || isLoading)
                          ? SystemMouseCursors.basic
                          : SystemMouseCursors.click,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: _isInputEmpty || isLoading
                              ? Colors.white10
                              : (hasError
                                    ? Colors.redAccent.withValues(alpha: 0.3)
                                    : AppColors.pixelPurple),
                          boxShadow: [
                            if (!_isInputEmpty && !hasError && !isLoading)
                              BoxShadow(
                                color: AppColors.neonPurpleLight.withValues(
                                  alpha: 0.5,
                                ),
                                offset: const Offset(4, 4),
                              ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            isLoading ? '확인 중...' : '입장하기',
                            style: TextStyle(
                              fontFamily: 'PFStardustS',
                              color: (_isInputEmpty || isLoading)
                                  ? Colors.white24
                                  : (hasError
                                        ? Colors.redAccent
                                        : Colors.black),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
