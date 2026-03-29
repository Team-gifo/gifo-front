import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/gift_packaging_bloc.dart';
import '../../model/gacha_content.dart';
import '../widgets/addgift_scaffold.dart';
import '../widgets/step_indicator.dart';

class GiftDeliveryMethodView extends StatelessWidget {
  const GiftDeliveryMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '선물 포장하기 - Gifo',
      color: AppColors.darkBg,
      child: AddgiftScaffold(
        appBar: AppBar(
          toolbarHeight: 68,
          backgroundColor: AppColors.darkBg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
          actions: <Widget>[const StepIndicator(activeStep: 3)],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool isDesktop =
                  constraints.maxWidth >= AppBreakpoints.tablet;
              if (isDesktop) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 24.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: _buildMainText(TextAlign.left),
                        ),
                        const SizedBox(width: 80),
                        Expanded(
                          flex: 2,
                          child: _buildGridOptions(context, isDesktop: true),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 40),
                      _buildMainText(TextAlign.center),
                      const SizedBox(height: 48),
                      _buildGridOptions(context, isDesktop: false),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainText(TextAlign alignment) {
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

  Widget _buildGridOptions(BuildContext context, {required bool isDesktop}) {
    final List<Map<String, dynamic>> options = <Map<String, dynamic>>[
      <String, dynamic>{
        'title': '캡슐 뽑기',
        'icon': 'assets/images/gacha_machine.png',
        'accent': AppColors.neonPurple,
      },
      <String, dynamic>{
        'title': '문제 맞추기',
        'icon': 'assets/images/quiz_character.png',
        'accent': AppColors.neonBlue,
      },
      <String, dynamic>{
        'title': '바로 오픈',
        'icon': 'assets/images/open_gift_box.png',
        'accent': AppColors.pixelPurple,
      },
    ];

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
      itemCount: options.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildOptionCard(
          context: context,
          title: options[index]['title'] as String,
          iconPath: options[index]['icon'] as String,
          accent: options[index]['accent'] as Color,
        );
      },
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required String iconPath,
    required Color accent,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleOptionTap(context, title),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: accent.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Image.asset(iconPath, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'WantedSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleOptionTap(BuildContext context, String title) async {
    final GiftPackagingBloc bloc = context.read<GiftPackagingBloc>();
    final GiftPackagingState state = bloc.state;
    final GachaContent? savedGacha = state.gachaContent;
    final bool hasGachaData = savedGacha != null && savedGacha.list.isNotEmpty;

    ContentType selectedType = ContentType.gacha;
    String route = '/addgift/gacha-setting';

    if (title == '캡슐 뽑기') {
      selectedType = ContentType.gacha;
      route = '/addgift/gacha-setting';
    } else if (title == '문제 맞추기') {
      selectedType = ContentType.quiz;
      route = '/addgift/quiz-setting';
    } else if (title == '바로 오픈') {
      selectedType = ContentType.unboxing;
      route = '/addgift/direct-open-setting';
    }

    if (hasGachaData && selectedType != ContentType.gacha) {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            '콘텐츠 변경',
            style: TextStyle(
              fontFamily: 'WantedSans',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: const Text(
            '캡슐 뽑기에 작성 중인 데이터가 있습니다.\n초기화하고 새로운 콘텐츠로 넘어가겠습니까?',
            style: TextStyle(
              fontFamily: 'WantedSans',
              height: 1.5,
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(
                '아니오',
                style: TextStyle(
                  fontFamily: 'WantedSans',
                  color: Colors.white38,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                '예',
                style: TextStyle(
                  fontFamily: 'WantedSans',
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      if (confirm == true) {
        bloc.add(SetGachaContent(const GachaContent()));
        bloc.add(SetContentType(selectedType));
        if (context.mounted) context.push(route);
      }
    } else {
      bloc.add(SetContentType(selectedType));
      context.push(route);
    }
  }

}
