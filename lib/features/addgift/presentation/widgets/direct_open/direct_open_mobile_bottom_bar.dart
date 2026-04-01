import 'package:flutter/material.dart';

import 'direct_open_complete_button.dart';

class DirectOpenMobileBottomBar extends StatelessWidget {
  const DirectOpenMobileBottomBar({
    super.key,
    required this.onShowSettings,
    required this.onComplete,
  });

  final VoidCallback onShowSettings;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          border: const Border(top: BorderSide(color: Colors.white12)),
        ),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: onShowSettings,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
                child: const Icon(Icons.settings, color: Colors.white60),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DirectOpenCompleteButton(
                onPressed: onComplete,
                height: 56,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
