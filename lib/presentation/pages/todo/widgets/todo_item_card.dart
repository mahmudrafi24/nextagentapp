import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_date_utils.dart';
import '../../../../domain/entities/todo.dart';

class TodoItemCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItemCard({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  Color get _priorityColor {
    switch (todo.priority) {
      case TodoPriority.high:
        return AppColors.error;
      case TodoPriority.medium:
        return AppColors.warning;
      case TodoPriority.low:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: todo.isCompleted
                        ? AppColors.success
                        : AppColors.textMuted,
                    width: 2,
                  ),
                  color: todo.isCompleted
                      ? AppColors.success
                      : Colors.transparent,
                ),
                child: todo.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: AppTextStyles.body.copyWith(
                      color: todo.isCompleted
                          ? AppColors.textMuted
                          : Theme.of(context).colorScheme.onSurface,
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Priority indicator
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _priorityColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        todo.priority.name,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      if (todo.dueDate != null) ...[
                        const SizedBox(width: 12),
                        Icon(Icons.schedule,
                            size: 12, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          AppDateUtils.formatDueDate(todo.dueDate),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                      if (todo.tags.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        ...todo.tags.take(2).map((tag) => Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tag,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                ),
                              ),
                            )),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
