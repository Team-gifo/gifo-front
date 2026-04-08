import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../application/memory_gallery_setting/memory_gallery_setting_bloc.dart';
import 'memory_mobile_card.dart';
import 'memory_sort_button.dart';

class MemoryGalleryMobileBody extends StatelessWidget {
  const MemoryGalleryMobileBody({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Wrap(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  MemorySortButton(
                    state: galleryState,
                    type: MemorySortType.createdAt,
                    label: '생성순',
                    isMobile: true,
                  ),
                  MemorySortButton(
                    state: galleryState,
                    type: MemorySortType.titleKo,
                    label: '제목 (한글)',
                    isMobile: true,
                  ),
                  MemorySortButton(
                    state: galleryState,
                    type: MemorySortType.titleEn,
                    label: '제목 (영어)',
                    isMobile: true,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: onAddItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text(
                      '추가',
                      style: TextStyle(fontFamily: 'PFStardust'),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text(
                      '초기화',
                      style: TextStyle(fontFamily: 'PFStardust'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (galleryState.uiItems.isEmpty)
          const Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.photo_library_outlined,
                    size: 64,
                    color: Colors.white24,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '아직 등록된 추억이 없어요.',
                    style: TextStyle(color: Colors.white38, fontSize: 15),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: Theme(
              data: ThemeData(canvasColor: Colors.transparent),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: <PointerDeviceKind>{
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: ReorderableListView.builder(
                  scrollController: scrollController,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 8.0,
                  ),
                  itemCount: galleryState.uiItems.length,
                  buildDefaultDragHandles: false,
                  onReorder: (int oldIndex, int newIndex) {
                    context.read<MemoryGallerySettingBloc>().add(
                      ReorderMemoryItems(oldIndex, newIndex),
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final MemoryGalleryItemData item =
                        galleryState.uiItems[index];
                    return MemoryMobileCard(
                      key: ValueKey<int>(item.id),
                      index: index,
                      itemData: item,
                      isIncomplete: isItemIncomplete(item),
                      isSelected: galleryState.selectedItemId == item.id,
                      onTap: () => onItemTap(item),
                      onRemove: () => context
                          .read<MemoryGallerySettingBloc>()
                          .add(RemoveMemoryItem(item.id)),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
