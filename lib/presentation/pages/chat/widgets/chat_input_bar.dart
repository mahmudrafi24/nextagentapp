import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../controllers/chat_controller.dart';

class ChatInputBar extends StatelessWidget {
  final ChatController controller;

  const ChatInputBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? 8
            : MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerTheme.color ?? AppColors.bgSurface,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.inputController,
              onChanged: (value) => controller.inputText.value = value,
              onSubmitted: (_) => controller.sendMessage(),
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.send,
              style: AppTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Message Claw...',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textMuted,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                filled: true,
                fillColor: Theme.of(context).cardTheme.color,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => GestureDetector(
                onTap: controller.isLoading.value
                    ? null
                    : controller.sendMessage,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: controller.inputText.value.trim().isEmpty
                        ? AppColors.bgSurface
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: controller.inputText.value.trim().isEmpty
                        ? AppColors.textMuted
                        : Colors.white,
                    size: 20,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
