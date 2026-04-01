import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import 'memory_decision_selection_button.dart';

class MemoryDecisionButtonsColumn extends StatelessWidget {
  const MemoryDecisionButtonsColumn({
    super.key,
    required this.onSelectShareMemory,
    required this.onSelectDirectOpen,
  });

  final VoidCallback onSelectShareMemory;
  final VoidCallback onSelectDirectOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MemoryDecisionSelectionButton(
          title: '네,',
          subtitle: '저는 친구와 함께 추억을 공유하고 싶어요!',
          icon: Icons.photo_library_rounded,
          accentColor: AppColors.neonPurple,
          onPressed: onSelectShareMemory,
        ),
        const SizedBox(height: 16),
        MemoryDecisionSelectionButton(
          title: '아니요,',
          subtitle: '저는 바로 선물을 공개할거에요.',
          icon: Icons.card_giftcard_rounded,
          accentColor: AppColors.neonBlue,
          onPressed: onSelectDirectOpen,
        ),
      ],
    );
  }
}
