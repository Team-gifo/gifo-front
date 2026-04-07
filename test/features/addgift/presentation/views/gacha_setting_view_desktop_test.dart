import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gifo/features/addgift/application/gift_packaging_bloc.dart';
import 'package:gifo/features/addgift/presentation/views/gacha_setting_view.dart';
import 'package:gifo/features/addgift/presentation/widgets/desktop_settings_rail.dart';

void main() {
  testWidgets('데스크톱에서 설정 패널은 스크롤 영역과 하단 고정 완료 버튼을 함께 표시한다', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final GiftPackagingBloc packagingBloc = GiftPackagingBloc();
    addTearDown(packagingBloc.close);

    await tester.pumpWidget(
      BlocProvider<GiftPackagingBloc>.value(
        value: packagingBloc,
        child: const MaterialApp(home: GachaSettingView()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DesktopSettingsRail), findsOneWidget);
    expect(find.text('BGM 설정'), findsOneWidget);
    expect(find.text('포장 완료'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(DesktopSettingsRail),
        matching: find.byType(SingleChildScrollView),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
