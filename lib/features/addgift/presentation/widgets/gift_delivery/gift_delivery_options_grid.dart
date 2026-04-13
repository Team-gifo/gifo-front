import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import 'gift_delivery_option_card.dart';

class GiftDeliveryOptionsGrid extends StatelessWidget {
  const GiftDeliveryOptionsGrid({
    super.key,
    required this.isDesktop,
    required this.onTapOption,
  });

  final bool isDesktop;
  final ValueChanged<String> onTapOption;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // 부모의 가용 너비(constraints.maxWidth)를 기준으로 동적으로 열 개수를 조정합니다.
        // 데스크탑처럼 넓은 공간(600px 이상)이 확보되면 3개, 태블릿 등 공간이 좁으면 2개로 배치
        final int crossAxisCount = constraints.maxWidth >= 600 ? 3 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.8,
          ),
          itemCount: _options.length,
          itemBuilder: (BuildContext context, int index) {
            final _GiftDeliveryOptionData option = _options[index];
            return GiftDeliveryOptionCard(
              title: option.title,
              description: option.description,
              iconPath: option.iconPath,
              accent: option.accent,
              onTap: () => onTapOption(option.title),
            );
          },
        );
      },
    );
  }
}

class _GiftDeliveryOptionData {
  const _GiftDeliveryOptionData({
    required this.title,
    required this.description,
    required this.iconPath,
    required this.accent,
  });

  final String title;
  final String description;
  final String iconPath;
  final Color accent;
}

const List<_GiftDeliveryOptionData> _options = <_GiftDeliveryOptionData>[
  _GiftDeliveryOptionData(
    title: '캡슐 뽑기',
    description: '"꽝" 없이 랜덤하게 선물 뽑기',
    iconPath: 'assets/images/gacha_machine.png',
    accent: AppColors.neonPurple,
  ),
  _GiftDeliveryOptionData(
    title: '문제 맞추기',
    description: '객관식 / 주관식 / OX 문제',
    iconPath: 'assets/images/quiz_character.png',
    accent: AppColors.neonBlue,
  ),
  _GiftDeliveryOptionData(
    title: '서프라이즈',
    description: '간단한 내용 전달 후, 선물 공개',
    iconPath: 'assets/images/open_gift_box.png',
    accent: AppColors.neonPurple,
  ),
];
