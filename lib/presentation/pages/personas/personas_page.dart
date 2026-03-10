import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/error_snackbar.dart';
import '../../controllers/persona_controller.dart';

class PersonasPage extends StatelessWidget {
  const PersonasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PersonaController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Personas',
          style: AppTextStyles.heading3.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose how Claw interacts with you',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                    final currentMode = controller.currentMode.value;
                    return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: controller.personas.length,
                    itemBuilder: (context, index) {
                      final persona = controller.personas[index];
                      final isSelected = currentMode == persona.mode;

                      return GestureDetector(
                        onTap: () {
                          controller.selectPersona(persona.mode);
                          showSuccessSnackbar(
                              '${persona.name} mode activated!');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(persona.icon,
                                  style: const TextStyle(fontSize: 36)),
                              const SizedBox(height: 8),
                              Text(
                                persona.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.heading3.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                persona.description,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 6),
                              AnimatedOpacity(
                                opacity: isSelected ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 200),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Active',
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
