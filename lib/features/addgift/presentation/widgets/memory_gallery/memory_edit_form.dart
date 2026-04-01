import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../application/memory_gallery_setting/memory_gallery_setting_bloc.dart';

class MemoryEditForm extends StatelessWidget {
  const MemoryEditForm({
    super.key,
    required this.itemId,
    required this.onPickImage,
  });

  final int itemId;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoryGallerySettingBloc, MemoryGallerySettingState>(
      builder: (BuildContext context, MemoryGallerySettingState state) {
        final MemoryGalleryItemData? itemData = state.uiItems
            .where((MemoryGalleryItemData item) => item.id == itemId)
            .firstOrNull;

        if (itemData == null) return const SizedBox.shrink();

        final bool isTitleValid = itemData.title.trim().isNotEmpty;
        final bool isDescriptionValid = itemData.description.trim().isNotEmpty;
        final bool hasImage = itemData.imageFile != null;

        return Container(
          color: const Color(0xFF1A1A2E),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 32.0,
                    right: 32.0,
                    top: 32.0,
                    bottom: MediaQuery.viewInsetsOf(context).bottom + 32.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(width: 24),
                          const Text(
                            '추억 상세 설정',
                            style: TextStyle(
                              fontFamily: 'WantedSans',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white70,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '제목',
                        style: TextStyle(
                          fontFamily: 'WantedSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        key: ValueKey<String>('title_$itemId'),
                        initialValue: itemData.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'WantedSans',
                        ),
                        onChanged: (String val) {
                          context.read<MemoryGallerySettingBloc>().add(
                            UpdateMemoryItemTitle(itemId, val),
                          );
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.07),
                          hintText: '제목을 입력해주세요',
                          hintStyle: const TextStyle(
                            color: Colors.white38,
                            fontFamily: 'WantedSans',
                          ),
                          errorStyle: const TextStyle(fontFamily: 'WantedSans'),
                          suffixIcon: itemData.title.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  onPressed: () {
                                    context
                                        .read<MemoryGallerySettingBloc>()
                                        .add(
                                          UpdateMemoryItemTitle(itemId, ''),
                                        );
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isTitleValid
                                  ? const Color(0xFF6DE1F1)
                                  : Colors.red,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isTitleValid ? Colors.white24 : Colors.red,
                              width: isTitleValid ? 1.0 : 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isTitleValid
                                  ? AppColors.neonPurple
                                  : Colors.red,
                              width: 1.5,
                            ),
                          ),
                          errorText: !isTitleValid
                              ? '제목은 최소 1글자 이상이어야 합니다.'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '이미지',
                        style: TextStyle(
                          fontFamily: 'WantedSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (!hasImage)
                        InkWell(
                          onTap: onPickImage,
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: Colors.white38,
                              ),
                            ),
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              constraints:
                                  const BoxConstraints(maxHeight: 500),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  itemData.imageFile!.path,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                OutlinedButton.icon(
                                  onPressed: onPickImage,
                                  icon: const Icon(Icons.edit, size: 16),
                                  label: const Text(
                                    '수정',
                                    style: TextStyle(fontFamily: 'WantedSans'),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.neonBlue,
                                    side: const BorderSide(
                                      color: AppColors.neonBlue,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    context
                                        .read<MemoryGallerySettingBloc>()
                                        .add(RemoveMemoryItemImage(itemId));
                                  },
                                  icon: const Icon(Icons.delete, size: 16),
                                  label: const Text(
                                    '삭제',
                                    style: TextStyle(fontFamily: 'WantedSans'),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.redAccent,
                                    side: const BorderSide(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),
                      const Text(
                        '- 부적절한 제목이나 이미지는 신고 대상이 될 수 있으며, 관련 책임은 등록 주체에게 있음을 알려드립니다.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'WantedSans',
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '설명',
                        style: TextStyle(
                          fontFamily: 'WantedSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        key: ValueKey<String>('desc_$itemId'),
                        initialValue: itemData.description,
                        maxLines: 4,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'WantedSans',
                        ),
                        onChanged: (String val) {
                          context.read<MemoryGallerySettingBloc>().add(
                            UpdateMemoryItemDescription(itemId, val),
                          );
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.07),
                          hintText: '설명을 입력해주세요',
                          hintStyle: const TextStyle(
                            color: Colors.white38,
                            fontFamily: 'WantedSans',
                          ),
                          errorStyle: const TextStyle(fontFamily: 'WantedSans'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDescriptionValid
                                  ? AppColors.neonPurple
                                  : Colors.red,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDescriptionValid
                                  ? Colors.white24
                                  : Colors.red,
                              width: isDescriptionValid ? 1.0 : 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDescriptionValid
                                  ? AppColors.neonPurple
                                  : Colors.red,
                              width: 1.5,
                            ),
                          ),
                          errorText: !isDescriptionValid
                              ? '설명은 최소 1글자 이상이어야 합니다.'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<MemoryGallerySettingBloc>().add(
                            RemoveMemoryItem(itemId),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '삭제',
                          style: TextStyle(
                            fontFamily: 'WantedSans',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neonPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '닫기',
                          style: TextStyle(
                            fontFamily: 'WantedSans',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
