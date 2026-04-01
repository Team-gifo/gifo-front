import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../application/memory_gallery_setting/memory_gallery_setting_bloc.dart';

class MemorySortButton extends StatelessWidget {
  const MemorySortButton({
    super.key,
    required this.state,
    required this.type,
    required this.label,
    this.isMobile = false,
  });

  final MemoryGallerySettingState state;
  final MemorySortType type;
  final String label;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = state.sortType == type;

    return InkWell(
      onTap: () {
        context.read<MemoryGallerySettingBloc>().add(SortMemoryItems(type));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 12,
          vertical: isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.neonPurple.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.neonPurple
                : Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontFamily: 'WantedSans',
                color: isSelected ? AppColors.neonPurple : Colors.white60,
                fontSize: isMobile ? 12 : 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            if (isSelected) ...<Widget>[
              const SizedBox(width: 4),
              Icon(
                state.isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: isMobile ? 14 : 16,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
