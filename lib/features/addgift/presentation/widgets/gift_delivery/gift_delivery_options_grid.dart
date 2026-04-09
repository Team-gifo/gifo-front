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
    final int crossAxisCount = isDesktop ? 3 : 2;

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
          iconPath: option.iconPath,
          accent: option.accent,
          onTap: () => onTapOption(option.title),
        );
      },
    );
  }
}

class _GiftDeliveryOptionData {
  const _GiftDeliveryOptionData({
    required this.title,
    required this.iconPath,
    required this.accent,
  });

  final String title;
  final String iconPath;
  final Color accent;
}

const List<_GiftDeliveryOptionData> _options = <_GiftDeliveryOptionData>[
  _GiftDeliveryOptionData(
    title: '캡슐 뽑기',
    iconPath: 'assets/images/gacha_machine.png',
    accent: AppColors.neonPurple,
  ),
  _GiftDeliveryOptionData(
    title: '문제 맞추기',
    iconPath: 'assets/images/quiz_character.png',
    accent: AppColors.neonBlue,
  ),
  _GiftDeliveryOptionData(
    title: '바로 오픈',
    iconPath: 'assets/images/open_gift_box.png',
    accent: AppColors.neonPurple,
  ),
];
