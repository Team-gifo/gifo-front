import 'package:flutter/material.dart';

class GiftDeliveryOptionCard extends StatelessWidget {
  const GiftDeliveryOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String description;
  final String iconPath;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Image.asset(iconPath, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'WantedSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'WantedSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white60,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
