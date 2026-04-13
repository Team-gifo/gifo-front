import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({super.key, required this.activeStep});

  /// 현재 활성화된 단계 (1, 2, 3 중 하나).
  /// 해당 번호까지의 원과 연결선이 활성 색상으로 표시됩니다.
  final int activeStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildCircle(isActive: activeStep >= 1, number: '1'),
          _buildLine(isActive: activeStep >= 2),
          _buildCircle(isActive: activeStep >= 2, number: '2'),
          _buildLine(isActive: activeStep >= 3),
          _buildCircle(isActive: activeStep >= 3, number: '3'),
        ],
      ),
    );
  }

  Widget _buildCircle({required bool isActive, required String number}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.neonPurple : Colors.white12,
        border: isActive ? null : Border.all(color: Colors.white24),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontFamily: 'WantedSans',
            color: isActive ? Colors.white : Colors.white38,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Container(
      width: 16,
      height: 2,
      color: isActive
          ? AppColors.neonPurple.withValues(alpha: 0.5)
          : Colors.white12,
    );
  }
}
