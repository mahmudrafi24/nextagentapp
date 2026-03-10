import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../controllers/todo_controller.dart';
import 'widgets/todo_item_card.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodoController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Todo List',
          style: AppTextStyles.heading3.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: Column(
        children: [
          // Input bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.inputController,
                    onChanged: (value) => controller.inputText.value = value,
                    onSubmitted: (_) => controller.addTodoFromNaturalLanguage(),
                    style: AppTextStyles.body.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add a task... e.g. "Call mom tomorrow at 3pm"',
                      hintStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                      prefixIcon: const Icon(Icons.add_task),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => GestureDetector(
                      onTap: controller.isParsing.value
                          ? null
                          : controller.addTodoFromNaturalLanguage,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: controller.isParsing.value
                            ? const Padding(
                                padding: EdgeInsets.all(14),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.add,
                                color: Colors.white, size: 24),
                      ),
                    )),
              ],
            ),
          ),
          // AI parsing indicator
          Obx(() {
            if (!controller.isParsing.value) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.accent),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI is parsing your task...',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            );
          }),
          // Todo list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.todos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.task_alt,
                          size: 64, color: AppColors.textMuted),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks yet',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add tasks using natural language\ne.g. "Buy groceries by Friday"',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final active = controller.activeTodos;
              final completed = controller.completedTodos;

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (active.isNotEmpty) ...[
                    Text(
                      'Active (${active.length})',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...active.map((todo) => TodoItemCard(
                          todo: todo,
                          onToggle: () => controller.toggleTodo(todo.id),
                          onDelete: () => controller.deleteTodo(todo.id),
                        )),
                  ],
                  if (completed.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Completed (${completed.length})',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...completed.map((todo) => TodoItemCard(
                          todo: todo,
                          onToggle: () => controller.toggleTodo(todo.id),
                          onDelete: () => controller.deleteTodo(todo.id),
                        )),
                  ],
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
