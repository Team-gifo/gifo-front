import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gifo/features/addgift/application/gift_packaging_bloc.dart';
import 'package:gifo/features/addgift/application/quiz_setting/quiz_setting_bloc.dart';
import 'package:gifo/features/addgift/presentation/widgets/quiz/quiz_settings_panel.dart';

void main() {
  testWidgets('isCompactDesktop=true일 때 핵심 카드가 렌더되고 이미지 피커 크기가 축소된다', (
    WidgetTester tester,
  ) async {
    final GiftPackagingBloc packagingBloc = GiftPackagingBloc();
    final QuizSettingBloc quizBloc = QuizSettingBloc(packagingBloc);
    addTearDown(packagingBloc.close);
    addTearDown(quizBloc.close);

    final TextEditingController successController = TextEditingController();
    final TextEditingController failController = TextEditingController();
    addTearDown(successController.dispose);
    addTearDown(failController.dispose);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<GiftPackagingBloc>.value(value: packagingBloc),
          BlocProvider<QuizSettingBloc>.value(value: quizBloc),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: 380,
                child: QuizSettingsPanel(
                  quizState: quizBloc.state,
                  isMobile: false,
                  isCompactDesktop: true,
                  successRewardNameController: successController,
                  failRewardNameController: failController,
                  onPickSuccessRewardImage: () {},
                  onPickFailRewardImage: () {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('포장 완료 조건'), findsOneWidget);
    expect(find.text('BGM 설정'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is SizedBox && widget.width == 74 && widget.height == 74,
      ),
      findsNWidgets(2),
    );
    expect(tester.takeException(), isNull);
  });
}
