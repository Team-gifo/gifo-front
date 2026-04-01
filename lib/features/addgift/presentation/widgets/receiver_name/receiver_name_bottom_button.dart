import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class ReceiverNameBottomButton extends StatelessWidget {
  const ReceiverNameBottomButton({
    super.key,
    required this.nameController,
    required this.onNext,
  });

  final TextEditingController nameController;
  final ValueChanged<String> onNext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: nameController,
        builder: (BuildContext context, TextEditingValue value, Widget? child) {
          final bool isNameEmpty = value.text.trim().isEmpty;
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: isNameEmpty ? null : () => onNext(value.text.trim()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonPurple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.white12,
                  disabledForegroundColor: Colors.white38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '다음',
                      style: TextStyle(
                        fontFamily: 'WantedSans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 22),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
