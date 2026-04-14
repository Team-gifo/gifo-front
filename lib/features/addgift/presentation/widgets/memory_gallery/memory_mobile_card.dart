import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../application/memory_gallery_setting/memory_gallery_setting_bloc.dart';

class MemoryMobileCard extends StatelessWidget {
  const MemoryMobileCard({
    required super.key,
    required this.index,
    required this.itemData,
    required this.isIncomplete,
    required this.isSelected,
    required this.onTap,
    required this.onRemove,
  });

  final int index;
  final MemoryGalleryItemData itemData;
  final bool isIncomplete;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 24.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Material(
            color: Colors.white.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: isSelected ? AppColors.neonPurple : Colors.white24,
                width: isSelected ? 2.0 : 1.0,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ReorderableDragStartListener(
                      index: index,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 12, 8),
                        child: Icon(Icons.drag_handle, color: Colors.grey),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: itemData.imageFile != null
                          ? Image.network(
                              itemData.imageFile!.path,
                              fit: BoxFit.contain,
                            )
                          : Icon(
                              Icons.photo,
                              size: 30,
                              color: Colors.grey.shade300,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            itemData.title.isEmpty ? '제목 없음' : itemData.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'WantedSans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: itemData.title.isEmpty
                                  ? Colors.white38
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            itemData.description.isEmpty
                                ? '설명 없음'
                                : itemData.description.replaceAll('\n', ' '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'WantedSans',
                              fontSize: 13,
                              color: itemData.description.isEmpty
                                  ? Colors.white38
                                  : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: onRemove,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
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
        ],
      ),
    );
  }
}
