import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../model/quiz_setting_models.dart';

class QuizListItem extends StatelessWidget {
  const QuizListItem({
    super.key,
    required this.item,
    required this.index,
    required this.onRemove,
    required this.onTap,
  });

  final QuizItemData item;
  final int index;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey<String>(item.id),
      color: Colors.white.withValues(alpha: 0.05),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.menu, color: Colors.white38),
        ),
        title: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.neonPurple.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.typeName,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'WantedSans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.title.isEmpty ? '[ Q. 제목을 입력해주세요 ]' : 'Q. ${item.title}',
                style: TextStyle(
                  color: item.title.isEmpty ? Colors.orange : Colors.white,
                  fontFamily: 'WantedSans',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            item.answer.isEmpty
                ? '[ A. 정답을 입력해주세요 ]'
                : 'A. ${item.answer.join(", ")}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: item.answer.isEmpty ? Colors.orange : Colors.green,
              fontFamily: 'WantedSans',
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 24, color: Colors.red),
          onPressed: onRemove,
        ),
        onTap: onTap,
      ),
    );
  }
}
