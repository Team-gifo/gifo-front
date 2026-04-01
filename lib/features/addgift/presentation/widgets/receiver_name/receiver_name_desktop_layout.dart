import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import 'receiver_name_input_field.dart';

class ReceiverNameDesktopLayout extends StatelessWidget {
  const ReceiverNameDesktopLayout({super.key, required this.nameController});

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 64.0,
              vertical: 48.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '선물 받는 분의',
                  style: TextStyle(
                    fontFamily: 'PFStardustS',
                    fontSize: 36,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
                const Text(
                  '닉네임을 알려주세요',
                  style: TextStyle(
                    fontFamily: 'PFStardustS',
                    fontSize: 36,
                    color: AppColors.neonPurple,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '받는 분의 닉네임으로 선물이 포장됩니다.',
                  style: TextStyle(
                    fontFamily: 'WantedSans',
                    fontSize: 15,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: SizedBox(
              width: 400,
              child: ReceiverNameInputField(controller: nameController),
            ),
          ),
        ),
      ],
    );
  }
}
