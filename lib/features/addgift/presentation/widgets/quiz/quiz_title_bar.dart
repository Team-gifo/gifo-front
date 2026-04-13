import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class QuizTitleBar extends StatelessWidget {
  const QuizTitleBar({
    super.key,
    required this.userNameController,
    required this.subTitleController,
    this.suffixLabel = '문제 맞추기',
  });

  final TextEditingController userNameController;
  final TextEditingController subTitleController;
  final String suffixLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 100,
          child: TextFormField(
            controller: userNameController,
            decoration: InputDecoration(
              hintText: '닉네임',
              isDense: true,
              hintStyle: const TextStyle(
                color: Colors.white38,
                fontFamily: 'WantedSans',
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.neonPurple,
                  width: 1.5,
                ),
              ),
            ),
            style: const TextStyle(
              color: AppColors.neonPurpleLight,
              fontFamily: 'WantedSans',
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text('님의', style: TextStyle(fontSize: 16, color: Colors.white70)),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: subTitleController,
            decoration: InputDecoration(
              hintText: '서브 타이틀',
              hintStyle: const TextStyle(
                color: Colors.white38,
                fontFamily: 'WantedSans',
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.neonPurple,
                  width: 1.5,
                ),
              ),
            ),
            style: const TextStyle(
              color: AppColors.neonPurpleLight,
              fontFamily: 'WantedSans',
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          suffixLabel,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
