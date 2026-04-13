import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/gift_packaging_bloc.dart';
import '../../model/gacha_content.dart';
import '../../model/quiz_content.dart';
import '../../model/unboxing_content.dart';
import '../widgets/addgift_scaffold.dart';
import '../widgets/gift_delivery/gift_delivery_main_text.dart';
import '../widgets/gift_delivery/gift_delivery_options_grid.dart';
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
          actions: const <Widget>[StepIndicator(activeStep: 3)],
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
                        const Expanded(
                          child: GiftDeliveryMainText(
                            alignment: TextAlign.left,
                          ),
                        ),
                        const SizedBox(width: 80),
                        Expanded(
                          flex: 2,
                          child: GiftDeliveryOptionsGrid(
                            isDesktop: true,
                            onTapOption: (String title) =>
                                _handleOptionTap(context, title),
                          ),
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
                      const GiftDeliveryMainText(alignment: TextAlign.center),
                      const SizedBox(height: 48),
                      GiftDeliveryOptionsGrid(
                        isDesktop: false,
                        onTapOption: (String title) =>
                            _handleOptionTap(context, title),
                      ),
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

  Future<void> _handleOptionTap(BuildContext context, String title) async {
    final GiftPackagingBloc bloc = context.read<GiftPackagingBloc>();
    final GiftPackagingState state = bloc.state;

    ContentType selectedType = ContentType.gacha;
    String route = '/addgift/gacha-setting';

    if (title == '캡슐 뽑기') {
      selectedType = ContentType.gacha;
      route = '/addgift/gacha-setting';
    } else if (title == '문제 맞추기') {
      selectedType = ContentType.quiz;
      route = '/addgift/quiz-setting';
    } else if (title == '서프라이즈') {
      selectedType = ContentType.unboxing;
      route = '/addgift/direct-open-setting';
    }

    bool hasData(ContentType type) {
      if (type == ContentType.gacha) {
        return state.gachaContent != null &&
            state.gachaContent!.list.isNotEmpty;
      } else if (type == ContentType.quiz) {
        return state.quizContent != null &&
            (state.quizContent!.list.isNotEmpty ||
                state.quizContent!.successReward.itemName.isNotEmpty ||
                state.quizContent!.failReward.itemName.isNotEmpty);
      } else if (type == ContentType.unboxing) {
        return state.unboxingContent != null &&
            (state.unboxingContent!.beforeOpen.description.isNotEmpty ||
                state.unboxingContent!.afterOpen.itemName.isNotEmpty);
      }
      return false;
    }

    String getName(ContentType type) {
      if (type == ContentType.gacha) return '캡슐 뽑기';
      if (type == ContentType.quiz) return '문제 맞추기';
      if (type == ContentType.unboxing) return '서프라이즈';
      return '';
    }

    bool needsConfirm = false;
    String conflictName = '';

    for (final type in [
      ContentType.gacha,
      ContentType.quiz,
      ContentType.unboxing,
    ]) {
      if (type != selectedType && hasData(type)) {
        needsConfirm = true;
        conflictName = getName(type);
        break;
      }
    }

    if (needsConfirm) {
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
          content: Text(
            '$conflictName에 작성 중인 데이터가 있습니다.\n초기화하고 새로운 콘텐츠로 넘어가겠습니까?',
            style: const TextStyle(
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
        bloc.add(
          SetQuizContent(
            const QuizContent(
              successReward: QuizSuccessReward(),
              failReward: QuizFailReward(),
            ),
          ),
        );
        bloc.add(
          SetUnboxingContent(
            const UnboxingContent(
              beforeOpen: BeforeOpen(),
              afterOpen: AfterOpen(),
            ),
          ),
        );
        bloc.add(SetContentType(selectedType));
        if (context.mounted) {
          unawaited(context.push(route));
        }
      }
    } else {
      bloc.add(SetContentType(selectedType));
      unawaited(context.push(route));
    }
  }
}
