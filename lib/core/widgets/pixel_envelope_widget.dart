import 'package:flutter/material.dart';

class PixelEnvelopeWidget extends StatelessWidget {
  final double size;
  final Color primaryColor;
  final Color outlineColor;

  const PixelEnvelopeWidget({
    super.key,
    this.size = 200,
    this.primaryColor = Colors.white,
    this.outlineColor = const Color(0xFFBC13FE), // AppColors.neonPurple
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.7,
      child: CustomPaint(
        painter: _PixelEnvelopePainter(
          primaryColor: primaryColor,
          outlineColor: outlineColor,
        ),
      ),
    );
  }
}

class _PixelEnvelopePainter extends CustomPainter {
  final Color primaryColor;
  final Color outlineColor;

  _PixelEnvelopePainter({
    required this.primaryColor,
    required this.outlineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 24x16 grid envelope
    final List<String> pixelMap = <String>[
      '                        ',
      '  oooooooooooooooooooo  ',
      '  o                  o  ',
      '  o oooooooooooooooo o  ',
      '  o o              o o  ',
      '  o  o            o  o  ',
      '  o   o          o   o  ',
      '  o    o        o    o  ',
      '  o     o      o     o  ',
      '  o      o    o      o  ',
      '  o       o  o       o  ',
      '  o        oo        o  ',
      '  o                  o  ',
      '  o                  o  ',
      '  oooooooooooooooooooo  ',
      '                        ',
    ];

    final int cols = pixelMap[0].length;
    final int rows = pixelMap.length;

    final double pixelWidth = size.width / cols;
    final double pixelHeight = size.height / rows;

    final Paint outlinePaint = Paint()..color = outlineColor;
    final Paint darkFillPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.7);

    // Draw base background first (excluding borders)
    canvas.drawRect(
      Rect.fromLTWH(
        2 * pixelWidth,
        2 * pixelHeight,
        (cols - 4) * pixelWidth,
        (rows - 4) * pixelHeight,
      ),
      darkFillPaint,
    );

    // Draw individual pixels
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        final String char = pixelMap[y][x];
        if (char == 'o') {
          final Rect rect = Rect.fromLTWH(
            x * pixelWidth,
            y * pixelHeight,
            pixelWidth,
            pixelHeight,
          );
          canvas.drawRect(rect, outlinePaint);
        } else if (char == ' ') {
          // Inside the envelope flap could have another color if needed
        }
      }
    }

    // Add neon glow
    final Paint glowPaint = Paint()
      ..color = outlineColor.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawRect(
      Rect.fromLTWH(
        2 * pixelWidth,
        2 * pixelHeight,
        (cols - 4) * pixelWidth,
        (rows - 4) * pixelHeight,
      ),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
