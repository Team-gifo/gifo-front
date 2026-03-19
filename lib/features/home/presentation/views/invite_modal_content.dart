import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../lobby/model/lobby_data.dart';

class InviteModalContent extends StatefulWidget {
  const InviteModalContent({super.key});

  @override
  State<InviteModalContent> createState() => _InviteModalContentState();
}

class _InviteModalContentState extends State<InviteModalContent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  late AnimationController _glowController;
  late Animation<Color?> _borderColorAnim;
  late Animation<double> _shadowBlurAnim;

  bool _isInputEmpty = true;
  bool _hasError = false; // 에러 상태 관리

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

    // 텍스트 변화 감지하여 버튼 활성화 상태 및 아이콘 트리거
    _codeController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final bool isEmpty = _codeController.text.isEmpty;
    
    // 텍스트가 변경되면 에러 상태 해제
    if (_hasError) {
      setState(() {
        _hasError = false;
      });
    }

    if (_isInputEmpty != isEmpty) {
      setState(() {
        _isInputEmpty = isEmpty;
      });
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

  void _handleEnter() {
    final String code = _codeController.text.trim();
    if (code.isEmpty) return;

    if (LobbyData.getDummyByCode(code) != null) {
      context.pop();
      context.push('/lobby', extra: code);
    } else {
      // 에러 상태 활성화 (토스트 대신 화면 내 문구 출력)
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                height: _hasError ? 24 : 0,
                child: _hasError
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
                  // 에러 상태에 따라 테두리 색상 변경
                  border: Border.all(
                    color: _hasError ? Colors.redAccent : AppColors.pixelPurple,
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
                  cursorColor: _hasError ? Colors.redAccent : AppColors.neonPurpleLight,
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
                    // 우측 아이콘 버튼 구성 (붙여넣기 / 삭제)
                    suffixIcon: _isInputEmpty
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
              // 입장하기 버튼 (활성화 로직 적용)
              GestureDetector(
                onTap: _isInputEmpty ? null : _handleEnter,
                child: MouseRegion(
                  cursor: _isInputEmpty
                      ? SystemMouseCursors.basic
                      : SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: _isInputEmpty
                          ? Colors.white10
                          : (_hasError ? Colors.redAccent.withValues(alpha: 0.3) : AppColors.pixelPurple),
                      boxShadow: [
                        if (!_isInputEmpty && !_hasError)
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
                        '입장하기',
                        style: TextStyle(
                          fontFamily: 'PFStardustS',
                          color: _isInputEmpty ? Colors.white24 : (_hasError ? Colors.redAccent : Colors.black),
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
  }
}
