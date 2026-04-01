import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../application/quiz_setting/quiz_setting_bloc.dart';
import '../../../model/quiz_setting_models.dart';
import 'quiz_list_item.dart';

class QuizItemsSection extends StatelessWidget {
  const QuizItemsSection({
    super.key,
    required this.isMobile,
    required this.quizState,
    required this.onAddItem,
    required this.onRemoveAllItems,
    required this.onReorder,
    required this.onRemoveItem,
    required this.onTapItem,
  });

  final bool isMobile;
  final QuizSettingState quizState;
  final VoidCallback onAddItem;
  final VoidCallback onRemoveAllItems;
  final ReorderCallback onReorder;
  final ValueChanged<String> onRemoveItem;
  final ValueChanged<QuizItemData> onTapItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ElevatedButton(
              onPressed: onAddItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonPurple,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('추가'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onRemoveAllItems,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('모두 제거'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: quizState.uiItems.isEmpty
                ? const Center(
                    child: Text(
                      '추가 버튼을 눌러 문제를 생성해보세요.',
                      style: TextStyle(color: Colors.white38),
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: quizState.uiItems.length,
                    onReorder: onReorder,
                    buildDefaultDragHandles: false,
                    proxyDecorator:
                        (Widget child, int index, Animation<double> animation) {
                          return Material(
                            color: Colors.transparent,
                            elevation: 0,
                            child: child,
                          );
                        },
                    itemBuilder: (BuildContext context, int index) {
                      final QuizItemData item = quizState.uiItems[index];
                      return QuizListItem(
                        key: ValueKey<String>(item.id),
                        item: item,
                        index: index,
                        onRemove: () => onRemoveItem(item.id),
                        onTap: () => onTapItem(item),
                      );
                    },
                  ),
          ),
        ),
        if (isMobile) const SizedBox(height: 24),
      ],
    );
  }
}
