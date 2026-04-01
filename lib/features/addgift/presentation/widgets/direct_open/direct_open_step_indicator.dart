import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class DirectOpenStepIndicator extends StatelessWidget {
  const DirectOpenStepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _DirectOpenStepCircle(number: '1'),
          _DirectOpenStepLine(),
          _DirectOpenStepCircle(number: '2'),
          _DirectOpenStepLine(),
          _DirectOpenStepCircle(number: '3'),
        ],
      ),
    );
  }
}

class _DirectOpenStepCircle extends StatelessWidget {
  const _DirectOpenStepCircle({required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.pixelPurple,
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _DirectOpenStepLine extends StatelessWidget {
  const _DirectOpenStepLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 2,
      color: AppColors.pixelPurple.withValues(alpha: 0.5),
    );
  }
}
