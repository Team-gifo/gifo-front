import 'dart:ui';
import 'package:flutter/material.dart';
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
  }

  @override
  void dispose() {
    _codeController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _handleEnter() {
    final String code = _codeController.text.trim();
    if (code.isEmpty) return;

    if (LobbyData.getDummyByCode(code) != null) {
      context.pop();
      context.push('/lobby', extra: code);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.darkBg,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(0),
          ),
          title: const Text(
            '알림',
            style: TextStyle(color: Colors.white, fontFamily: 'PFStardustS'),
          ),
          content: const Text(
            '잘못된 코드입니다',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text(
                '확인',
                style: TextStyle(color: AppColors.neonPurpleLight),
              ),
            ),
          ],
        ),
      );
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
              const SizedBox(height: 32),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  border: Border(
                    top: BorderSide(color: AppColors.pixelPurple, width: 2),
                    left: BorderSide(color: AppColors.pixelPurple, width: 2),
                    right: BorderSide(color: AppColors.pixelPurple, width: 2),
                    bottom: BorderSide(color: AppColors.pixelPurple, width: 2),
                  ),
                ),
                child: TextField(
                  controller: _codeController,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'PFStardustS',
                    color: AppColors.pixelPurple,
                    fontSize: 20,
                    letterSpacing: 2.0,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  cursorColor: AppColors.neonPurpleLight,
                  decoration: InputDecoration(
                    hintText: 'ex) 1234ABC',
                    hintStyle: TextStyle(
                      fontFamily: 'WantedSans',
                      color: Colors.purple.shade900,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onSubmitted: (_) => _handleEnter(),
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _handleEnter,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColors.pixelPurple,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonPurpleLight.withValues(
                            alpha: 0.5,
                          ),
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '입장하기',
                        style: TextStyle(
                          fontFamily: 'PFStardustS',
                          color: Colors.black,
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
