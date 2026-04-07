import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

/// 캡슐 상세 설정 / 퀴즈 문제 설정 폼에서 공통으로 사용하는 스타일 유틸리티.
class EditFormStyles {
  EditFormStyles._();

  // ── 색상 상수 ──
  static const Color formBackground = AppColors.darkBg;
  static const Color inputFill = Color(0x12FFFFFF); // white alpha 0.07
  static const Color inputBorderColor = Color(0x26FFFFFF); // white alpha 0.15

  // ── 폼 컨테이너 데코레이션 ──
  static BoxDecoration formDecoration({bool isDesktop = false}) {
    return BoxDecoration(
      color: formBackground,
      borderRadius: isDesktop
          ? BorderRadius.zero
          : const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
    );
  }

  // ── 섹션 타이틀 ──
  static Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'WantedSans',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
    );
  }

  // ── 폼 헤더 타이틀 스타일 ──
  static const TextStyle headerTitleStyle = TextStyle(
    fontFamily: 'WantedSans',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // ── InputDecoration ──
  static InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white38,
        fontFamily: 'WantedSans',
      ),
      filled: true,
      fillColor: inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: inputBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: inputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.neonPurple),
      ),
    );
  }

  // ── 에러 상태를 포함한 InputDecoration ──
  static InputDecoration inputDecorationWithValidation({
    required String hint,
    required bool isValid,
    String? errorText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white38,
        fontFamily: 'WantedSans',
      ),
      filled: true,
      fillColor: inputFill,
      errorText: errorText,
      errorStyle: const TextStyle(fontFamily: 'WantedSans'),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: !isValid ? Colors.red : inputBorderColor,
          width: !isValid ? 1.5 : 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: !isValid ? Colors.red : inputBorderColor,
          width: !isValid ? 1.5 : 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: !isValid ? Colors.red : AppColors.neonPurple,
          width: 1.5,
        ),
      ),
    );
  }

  // ── 드래그 핸들 (바텀시트용) ──
  static Widget dragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // ── 이미지 피커 섹션 (빈 상태) ──
  static Widget emptyImagePicker({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: const Center(
          child: Icon(
            Icons.add_photo_alternate,
            size: 40,
            color: Colors.white38,
          ),
        ),
      ),
    );
  }

  // ── 이미지 프리뷰 + 수정/삭제 버튼 ──
  static Widget imagePreviewWithActions({
    required String imagePath,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    VoidCallback? onFullscreen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              constraints: const BoxConstraints(maxHeight: 500),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imagePath, fit: BoxFit.contain),
              ),
            ),
            if (onFullscreen != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onFullscreen,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.open_in_full,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            OutlinedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, size: 16),
              label: const Text(
                '수정',
                style: TextStyle(fontFamily: 'WantedSans'),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, size: 16),
              label: const Text(
                '삭제',
                style: TextStyle(fontFamily: 'WantedSans'),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
