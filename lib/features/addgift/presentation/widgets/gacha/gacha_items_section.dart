import 'dart:math';

import 'package:flutter/material.dart';

import '../../../application/gacha_setting/gacha_setting_bloc.dart';
import 'gacha_capsule_item.dart';

class GachaItemsSection extends StatelessWidget {
  const GachaItemsSection({
    super.key,
    required this.totalPercent,
    required this.isMobile,
    required this.uiItems,
    required this.hoveredItemId,
    required this.selectedItemId,
    required this.onAddItem,
    required this.onRemoveAllItems,
    required this.onTapItem,
    required this.onRemoveItem,
    required this.onHoverEnter,
    required this.onHoverExit,
  });

  final double totalPercent;
  final bool isMobile;
  final List<DefaultGachaItemData> uiItems;
  final int? hoveredItemId;
  final int? selectedItemId;
  final VoidCallback onAddItem;
  final VoidCallback onRemoveAllItems;
  final ValueChanged<DefaultGachaItemData> onTapItem;
  final ValueChanged<int> onRemoveItem;
  final ValueChanged<int> onHoverEnter;
  final VoidCallback onHoverExit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (isMobile) ...<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (uiItems.length < 10) ...<Widget>[
                ElevatedButton.icon(
                  onPressed: onAddItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('추가'),
                ),
                const SizedBox(width: 8),
              ],
              ElevatedButton.icon(
                onPressed: onRemoveAllItems,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('모두 제거'),
              ),
            ],
          ),
        ] else ...<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PFStardust',
                      color: Colors.white,
                    ),
                    children: <InlineSpan>[
                      const TextSpan(text: '전체 확률 : '),
                      TextSpan(
                        text: '${totalPercent.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color:
                              (totalPercent >= 99.99 && totalPercent <= 100.01)
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const TextSpan(text: ' / 100.0%'),
                      const TextSpan(text: ' [ '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Image.asset(
                          'assets/images/gacha.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                      const TextSpan(
                        text: ' : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: '${uiItems.length}개 ]',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (uiItems.length < 10) ...<Widget>[
                    ElevatedButton.icon(
                      onPressed: onAddItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('추가'),
                    ),
                    const SizedBox(width: 8),
                  ],
                  ElevatedButton.icon(
                    onPressed: onRemoveAllItems,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('모두 제거'),
                  ),
                ],
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _CapsuleListContainer(
                isMobile: true,
                uiItems: uiItems,
                hoveredItemId: hoveredItemId,
                selectedItemId: selectedItemId,
                onAddItem: onAddItem,
                onTapItem: onTapItem,
                onRemoveItem: onRemoveItem,
                onHoverEnter: onHoverEnter,
                onHoverExit: onHoverExit,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Center(
                  child: Text(
                    '캡슐은 최대 10개까지만 추가가 가능합니다',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ),
              ),
            ],
          )
        else
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _CapsuleListContainer(
                    isMobile: false,
                    uiItems: uiItems,
                    hoveredItemId: hoveredItemId,
                    selectedItemId: selectedItemId,
                    onAddItem: onAddItem,
                    onTapItem: onTapItem,
                    onRemoveItem: onRemoveItem,
                    onHoverEnter: onHoverEnter,
                    onHoverExit: onHoverExit,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Center(
                      child: Text(
                        '캡슐은 최대 10개까지만 추가가 가능합니다',
                        style: TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _CapsuleListContainer extends StatelessWidget {
  const _CapsuleListContainer({
    required this.isMobile,
    required this.uiItems,
    required this.hoveredItemId,
    required this.selectedItemId,
    required this.onAddItem,
    required this.onTapItem,
    required this.onRemoveItem,
    required this.onHoverEnter,
    required this.onHoverExit,
  });

  final bool isMobile;
  final List<DefaultGachaItemData> uiItems;
  final int? hoveredItemId;
  final int? selectedItemId;
  final VoidCallback onAddItem;
  final ValueChanged<DefaultGachaItemData> onTapItem;
  final ValueChanged<int> onRemoveItem;
  final ValueChanged<int> onHoverEnter;
  final VoidCallback onHoverExit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        spacing: 32,
        runSpacing: 32,
        children: <Widget>[
          for (int i = 0; i < uiItems.length; i++)
            GachaCapsuleItem(
              item: uiItems[i],
              isMobile: isMobile,
              isHovered: hoveredItemId == uiItems[i].id,
              isSelected: selectedItemId == uiItems[i].id,
              onTap: () => onTapItem(uiItems[i]),
              onRemove: () => onRemoveItem(uiItems[i].id),
              onHoverEnter: () => onHoverEnter(uiItems[i].id),
              onHoverExit: onHoverExit,
            ),
          if (uiItems.length < 10)
            InkWell(
              onTap: onAddItem,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: isMobile ? 80 : 96,
                height: isMobile ? 80 : 96,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _DashedCirclePainter(
                          color: Colors.white38,
                          strokeWidth: 1.5,
                        ),
                      ),
                    ),
                    const Center(
                      child: Icon(Icons.add, color: Colors.white38, size: 32),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  _DashedCirclePainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final double perimeter = 2 * pi * radius;
    const double dashLength = 6.0;
    const double dashSpace = 4.0;

    final int dashCount = (perimeter / (dashLength + dashSpace)).floor();
    final double sweepAngle = (dashLength / perimeter) * 360 * (pi / 180);
    final double spaceAngle = (dashSpace / perimeter) * 360 * (pi / 180);

    double currentAngle = 0;
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        currentAngle,
        sweepAngle,
        false,
        paint,
      );
      currentAngle += sweepAngle + spaceAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
