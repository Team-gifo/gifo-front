import 'package:flutter/material.dart';

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
    final int totalCount = quizState.uiItems.length;
    final int completedCount = quizState.uiItems.where((item) {
      if (item.title.trim().isEmpty) return false;
      if (item.answer.isEmpty) return false;
      if (item.type == QuizType.multipleChoice && item.options.length < 2) {
        return false;
      }
      return true;
    }).length;

    final bool isAllCompleted = totalCount > 0 && completedCount == totalCount;
    final Color counterColor = isAllCompleted ? Colors.green : Colors.orange;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.assignment_turned_in_outlined,
                  size: 20,
                  color: counterColor.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 8),
                if (!isMobile) ...[
                  const Text(
                    '완성된 문제',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'PFStardust',
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  '$completedCount개 / $totalCount개',
                  style: TextStyle(
                    color: counterColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PFStardust',
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: onAddItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    '추가',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onRemoveAllItems,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text(
                    '모두 제거',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                  _QuizAddButton(onTap: onAddItem),
                ],
              ),
            ),
          ),
        ),
        if (isMobile) const SizedBox(height: 24),
      ],
    );
  }
}

class _QuizAddButton extends StatelessWidget {
  const _QuizAddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: const Column(
          children: <Widget>[
            Icon(Icons.add_circle_outline, color: Colors.white38, size: 28),
            SizedBox(height: 8),
            Text(
              '문제 추가하기',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
