import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/grid_background_painter.dart';

/// addgift 플로우 전체에서 공통으로 사용하는 스캐폴드 래퍼.
/// 다크 배경(AppColors.darkBg) + 그리드 패턴(GridBackgroundPainter)을 기본 제공한다.
class AddgiftScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  const AddgiftScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(painter: GridBackgroundPainter()),
          ),
          body,
        ],
      ),
    );
  }
}
