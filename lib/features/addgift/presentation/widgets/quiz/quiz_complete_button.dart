import 'package:flutter/material.dart';

class QuizCompleteButton extends StatelessWidget {
  const QuizCompleteButton({
    super.key,
    required this.enabled,
    required this.onPressed,
    this.height = 60,
  });

  final bool enabled;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled
              ? const Color(0xFF6DE1F1)
              : Colors.grey.shade300,
          disabledBackgroundColor: Colors.grey.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          '포장 완료',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: enabled ? Colors.black : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}
