import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../application/memory_gallery_setting/memory_gallery_setting_bloc.dart';
import 'memory_desktop_card.dart';
import 'memory_sort_button.dart';

class MemoryGalleryDesktopBody extends StatelessWidget {
  const MemoryGalleryDesktopBody({
    super.key,
    required this.galleryState,
    required this.scrollController,
    required this.onAddItem,
    required this.onItemTap,
    required this.isItemIncomplete,
  });

  final MemoryGallerySettingState galleryState;
  final ScrollController scrollController;
  final VoidCallback onAddItem;
  final ValueChanged<MemoryGalleryItemData> onItemTap;
  final bool Function(MemoryGalleryItemData) isItemIncomplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  MemorySortButton(
                    state: galleryState,
                    type: MemorySortType.createdAt,
                    label: '생성순',
                  ),
                  MemorySortButton(
                    state: galleryState,
                    type: MemorySortType.titleKo,
                    label: '제목 (한글)',
                  ),
                  MemorySortButton(
                    state: galleryState,
                    type: MemorySortType.titleEn,
                    label: '제목 (영어)',
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (galleryState.uiItems.length < 10)
                    ElevatedButton.icon(
                      onPressed: onAddItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neonBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.black,
                      ),
                      label: const Text(
                        '추가',
                        style: TextStyle(
                          fontFamily: 'WantedSans',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MemoryGallerySettingBloc>().add(
                        const RemoveAllMemoryItems(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.black,
                    ),
                    label: const Text(
                      '초기화',
                      style: TextStyle(
                        fontFamily: 'WantedSans',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double availableWidth = constraints.maxWidth;
                int crossAxisCount;
                if (availableWidth >= 1400) {
                  crossAxisCount = 5;
                } else if (availableWidth >= 1100) {
                  crossAxisCount = 4;
                } else if (availableWidth >= 800) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 2;
                }

                return Theme(
                  data: ThemeData(canvasColor: Colors.transparent),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: <PointerDeviceKind>{
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.trackpad,
                      },
                    ),
                    child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: ReorderableGridView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(4, 4, 20, 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: galleryState.uiItems.length < 10
                            ? galleryState.uiItems.length + 1
                            : 10,
                        onReorder: (int oldIndex, int newIndex) {
                          if (oldIndex == galleryState.uiItems.length ||
                              newIndex == galleryState.uiItems.length) {
                            return;
                          }
                          context.read<MemoryGallerySettingBloc>().add(
                            ReorderMemoryItems(oldIndex, newIndex),
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          if (index == galleryState.uiItems.length) {
                            if (galleryState.uiItems.length >= 10) {
                              return const SizedBox.shrink(
                                key: ValueKey<String>('add_card_dummy'),
                              );
                            }
                            return Padding(
                              key: const ValueKey<String>('add_card'),
                              padding: const EdgeInsets.all(10.0),
                              child: _DesktopAddCard(onPressed: onAddItem),
                            );
                          }
                          final MemoryGalleryItemData item =
                              galleryState.uiItems[index];
                          return MemoryDesktopCard(
                            key: ValueKey<int>(item.id),
                            index: index,
                            itemData: item,
                            isIncomplete: isItemIncomplete(item),
                            isSelected: galleryState.selectedItemId == item.id,
                            isHovered: galleryState.hoveredItemId == item.id,
                            onTap: () => onItemTap(item),
                            onRemove: () {
                              context.read<MemoryGallerySettingBloc>().add(
                                RemoveMemoryItem(item.id),
                              );
                              context.read<MemoryGallerySettingBloc>().add(
                                const ClearHoverMemoryItem(),
                              );
                            },
                            onHoverEnter: () => context
                                .read<MemoryGallerySettingBloc>()
                                .add(HoverMemoryItem(item.id)),
                            onHoverExit: () => context
                                .read<MemoryGallerySettingBloc>()
                                .add(const ClearHoverMemoryItem()),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopAddCard extends StatelessWidget {
  const _DesktopAddCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        side: const BorderSide(color: AppColors.neonBlue, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 36.0),
      ),
      onPressed: onPressed,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add_circle_outline, size: 28, color: AppColors.neonBlue),
          SizedBox(width: 10),
          Text(
            '추억 추가하기',
            style: TextStyle(
              fontFamily: 'WantedSans',
              color: AppColors.neonBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
