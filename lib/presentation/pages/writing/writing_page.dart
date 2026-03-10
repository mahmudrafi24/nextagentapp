import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../controllers/writing_controller.dart';
import 'widgets/mode_selector_chips.dart';

class WritingPage extends StatelessWidget {
  const WritingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WritingController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Writing Assistant',
          style: AppTextStyles.heading3.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: controller.clearAll,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode selector
            Text(
              'Mode',
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ModeSelectorChips(controller: controller),
            const SizedBox(height: 20),
            // Translate language selector
            Obx(() {
              if (controller.selectedMode.value != 'translate') {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Target Language',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Spanish', 'French', 'German', 'Arabic', 'Hindi', 'Japanese']
                        .map((lang) => Obx(() => ChoiceChip(
                              label: Text(lang),
                              selected:
                                  controller.targetLanguage.value == lang,
                              onSelected: (_) =>
                                  controller.targetLanguage.value = lang,
                              selectedColor:
                                  AppColors.primary.withValues(alpha: 0.2),
                              labelStyle: TextStyle(
                                color: controller.targetLanguage.value == lang
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            )))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),
            // Input
            Text(
              'Your Text',
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.inputController,
              onChanged: (value) => controller.inputText.value = value,
              maxLines: 6,
              minLines: 4,
              style: AppTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: const InputDecoration(
                hintText: 'Paste or type your text here...',
              ),
            ),
            const SizedBox(height: 16),
            // Process button
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.processText,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Process Text'),
                  )),
            ),
            const SizedBox(height: 24),
            // Output
            Obx(() {
              if (controller.outputText.value.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Result',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(
                                text: controller.outputText.value),
                          );
                          controller.copyOutput();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.copy,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              'Copy',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: SelectableText(
                      controller.outputText.value,
                      style: AppTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
