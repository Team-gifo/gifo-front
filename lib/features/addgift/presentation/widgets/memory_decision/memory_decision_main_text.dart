import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifo/core/constants/app_colors.dart';
import 'package:gifo/features/addgift/application/gift_packaging_bloc.dart';

class MemoryDecisionMainText extends StatelessWidget {
  const MemoryDecisionMainText({super.key, required this.alignment});

  final TextAlign alignment;

  @override
  Widget build(BuildContext context) {
    // GiftPackagingBloc 상태에서 받는 분의 닉네임을 가져옵니다.
    final String receiverName = context.select(
      (GiftPackagingBloc bloc) => bloc.state.receiverName,
    );

    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: receiverName,
            style: const TextStyle(
              fontFamily: 'WantedSans',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.neonPurple,
              height: 1.5,
            ),
          ),
          const TextSpan(
            text: '님에게 선물을 공개하기 전,\n',
            style: TextStyle(
              fontFamily: 'PFStardustS',
              fontSize: 28,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const TextSpan(
            text: '추억들을 공유하고 싶나요?',
            style: TextStyle(
              fontFamily: 'PFStardustS',
              fontSize: 28,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
      textAlign: alignment,
    );
  }
}
