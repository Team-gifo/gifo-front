import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gifo/features/addgift/presentation/widgets/desktop_settings_rail.dart';

void main() {
  testWidgets('compact height에서 BGM과 포장 완료 버튼이 함께 렌더되고 overflow가 없다', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 420,
              height: 820,
              child: DesktopSettingsRail(
                settingsBuilder:
                    (BuildContext context, bool isCompactDesktop) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          height: 560,
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('BGM 설정'),
                        ),
                      ],
                    ),
                bottomAction: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('포장 완료'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Scrollbar), findsOneWidget);
    expect(find.text('BGM 설정'), findsOneWidget);
    expect(find.text('포장 완료'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
