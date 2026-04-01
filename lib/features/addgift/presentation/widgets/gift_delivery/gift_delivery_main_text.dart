import 'package:flutter/material.dart';

class GiftDeliveryMainText extends StatelessWidget {
  const GiftDeliveryMainText({super.key, required this.alignment});

  final TextAlign alignment;

  @override
  Widget build(BuildContext context) {
    return Text(
      '친구에게 전달할 방식을\n선택해주세요 !',
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
