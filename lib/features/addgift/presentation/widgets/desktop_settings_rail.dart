import 'package:flutter/material.dart';

class DesktopSettingsRail extends StatelessWidget {
  const DesktopSettingsRail({
    super.key,
    required this.settingsBuilder,
    required this.bottomAction,
    this.compactHeightThreshold = 860,
    this.defaultPadding = 40,
    this.compactPadding = 24,
    this.defaultSpacing = 24,
    this.compactSpacing = 16,
  });

  final Widget Function(BuildContext context, bool isCompactDesktop)
  settingsBuilder;
  final Widget bottomAction;
  final double compactHeightThreshold;
  final double defaultPadding;
  final double compactPadding;
  final double defaultSpacing;
  final double compactSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isCompactDesktop =
            constraints.maxHeight < compactHeightThreshold;
        final double outerPadding = isCompactDesktop
            ? compactPadding
            : defaultPadding;
        final double betweenSpacing = isCompactDesktop
            ? compactSpacing
            : defaultSpacing;

        return Padding(
          padding: EdgeInsets.all(outerPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: settingsBuilder(context, isCompactDesktop),
                  ),
                ),
              ),
              SizedBox(height: betweenSpacing),
              bottomAction,
            ],
          ),
        );
      },
    );
  }
}
