import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../controllers/writing_controller.dart';

class ModeSelectorChips extends StatelessWidget {
  final WritingController controller;

  const ModeSelectorChips({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: WritingController.writingModes.map((mode) {
            final isSelected =
                controller.selectedMode.value == mode['key'];

            return GestureDetector(
              onTap: () => controller.selectMode(mode['key']!),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(mode['icon']!,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      mode['label']!,
                      style: AppTextStyles.label.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }
}
