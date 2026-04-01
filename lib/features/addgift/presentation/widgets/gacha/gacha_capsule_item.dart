import 'package:flutter/material.dart';

import '../../../application/gacha_setting/gacha_setting_bloc.dart';

class GachaCapsuleItem extends StatelessWidget {
  const GachaCapsuleItem({
    super.key,
    required this.item,
    required this.isMobile,
    required this.isHovered,
    required this.isSelected,
    required this.onTap,
    required this.onRemove,
    required this.onHoverEnter,
    required this.onHoverExit,
  });

  final DefaultGachaItemData item;
  final bool isMobile;
  final bool isHovered;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onHoverEnter;
  final VoidCallback onHoverExit;

  @override
  Widget build(BuildContext context) {
    final double? percentValue = double.tryParse(item.percentStr);
    final bool needsEdit =
        item.itemName.trim().isEmpty ||
        percentValue == null ||
        percentValue < 0.01 ||
        percentValue > 100.0;

    final double size = isMobile ? 80.0 : 96.0;
    final double halfSize = size / 2;
    final double iconSize = isMobile ? 42.0 : 50.0;
    final double titleFontSize = isMobile ? 14.0 : 16.0;
    final double percentFontSize = isMobile ? 12.0 : 14.0;

    return MouseRegion(
      onEnter: (_) => onHoverEnter(),
      onExit: (_) => onHoverExit(),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          InkWell(
            onTap: onTap,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: size,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.orange : Colors.black,
                        width: isSelected ? 3 : 2,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: item.imageFile != null
                              ? Image.network(
                                  item.imageFile!.path,
                                  width: size,
                                  height: size,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.question_mark,
                                  size: iconSize,
                                  color: Colors.black87,
                                ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: halfSize,
                          child: Container(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: halfSize,
                          child: Container(
                            color: item.color.withValues(alpha: 0.7),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(height: 1, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.itemName.isEmpty ? '제목 없음' : item.itemName,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color:
                          item.itemName.isEmpty ? Colors.white38 : Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    item.percentOpen ? '(${item.percentStr}%)' : '(미공개)',
                    style: TextStyle(
                      fontSize: percentFontSize,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (needsEdit)
            Positioned(
              top: -6,
              left: -6,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.priority_high,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          if (isHovered)
            Positioned(
              top: -6,
              right: -6,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
