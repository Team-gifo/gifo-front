import 'package:flutter/material.dart';

class MemoryDecisionMainText extends StatelessWidget {
  const MemoryDecisionMainText({super.key, required this.alignment});

  final TextAlign alignment;

  @override
  Widget build(BuildContext context) {
    return Text(
      '선물을 공개하기 전,\n친구와 추억을 공유할까요?',
      textAlign: alignment,
      style: const TextStyle(
        fontFamily: 'PFStardustS',
        fontSize: 28,
        color: Colors.white,
        height: 1.5,
      ),
    );
  }
}
