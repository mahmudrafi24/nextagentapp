import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../controllers/chat_controller.dart';
import 'widgets/message_bubble.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/typing_indicator.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat with Claw',
          style: AppTextStyles.heading3.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'clear') {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Clear Chat'),
                    content: const Text(
                        'Are you sure you want to clear this conversation?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.clearChat();
                          Get.back();
                        },
                        child: const Text('Clear',
                            style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20),
                    SizedBox(width: 8),
                    Text('Clear Chat'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return _buildEmptyState(context);
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: controller.messages.length +
                    (controller.isLoading.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.messages.length) {
                    return const TypingIndicator();
                  }
                  final message = controller.messages[index];
                  return MessageBubble(message: message);
                },
              );
            }),
          ),
          // Error message
          Obx(() {
            if (controller.errorMessage.value.isEmpty) {
              return const SizedBox.shrink();
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.error.withValues(alpha: 0.1),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.error, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      controller.errorMessage.value,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.errorMessage.value = '',
                    child: const Icon(Icons.close,
                        color: AppColors.error, size: 16),
                  ),
                ],
              ),
            );
          }),
          // Input bar
          ChatInputBar(controller: controller),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.auto_awesome,
                  color: AppColors.primary, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              'Start a Conversation',
              style: AppTextStyles.heading2.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ask me anything! I can help with tasks, answer questions, write content, and more.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildSuggestionChip(context, 'What can you do?'),
                _buildSuggestionChip(context, 'Help me plan my day'),
                _buildSuggestionChip(context, 'Write a quick email'),
                _buildSuggestionChip(context, 'Explain something'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(BuildContext context, String text) {
    final controller = Get.find<ChatController>();

    return GestureDetector(
      onTap: () {
        controller.inputController.text = text;
        controller.inputText.value = text;
        controller.sendMessage();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
