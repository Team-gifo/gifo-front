import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../application/memory_gallery_setting/memory_gallery_setting_bloc.dart';

class MemoryDesktopCard extends StatelessWidget {
  const MemoryDesktopCard({
    required super.key,
    required this.index,
    required this.itemData,
    required this.isIncomplete,
    required this.isSelected,
    required this.isHovered,
    required this.onTap,
    required this.onRemove,
    required this.onHoverEnter,
    required this.onHoverExit,
  });

  final int index;
  final MemoryGalleryItemData itemData;
  final bool isIncomplete;
  final bool isSelected;
  final bool isHovered;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onHoverEnter;
  final VoidCallback onHoverExit;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHoverEnter(),
      onExit: (_) => onHoverExit(),
      child: ReorderableDragStartListener(
        index: index,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned.fill(
                child: Material(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide(
                      color: isSelected ? AppColors.neonPurple : Colors.white24,
                      width: isSelected ? 2.5 : 1.0,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 24.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: itemData.imageFile != null
                                  ? Image.network(
                                      itemData.imageFile!.path,
                                      fit: BoxFit.contain,
                                    )
                                  : Icon(
                                      Icons.photo,
                                      size: 40,
                                      color: Colors.grey.withAlpha(100),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                itemData.title.isEmpty ? '제목 없음' : itemData.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'WantedSans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: itemData.title.isEmpty
                                      ? Colors.white38
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                itemData.description.isEmpty
                                    ? '설명 없음'
                                    : itemData.description.replaceAll('\n', ' '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'WantedSans',
                                  fontSize: 14,
                                  height: 1.5,
                                  color: itemData.description.isEmpty
                                      ? Colors.white38
                                      : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (isIncomplete)
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
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

