import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildAction(
          context,
          icon: Icons.auto_awesome,
          label: 'Ask AI',
          color: AppColors.primary,
          onTap: () => Get.toNamed(AppRoutes.chat),
        ),
        const SizedBox(width: 12),
        _buildAction(
          context,
          icon: Icons.checklist,
          label: 'Todo',
          color: AppColors.success,
          onTap: () => Get.toNamed(AppRoutes.todo),
        ),
        const SizedBox(width: 12),
        _buildAction(
          context,
          icon: Icons.edit_outlined,
          label: 'Write',
          color: AppColors.accent,
          onTap: () => Get.toNamed(AppRoutes.writing),
        ),
        const SizedBox(width: 12),
        _buildAction(
          context,
          icon: Icons.note_add_outlined,
          label: 'Note',
          color: AppColors.warning,
          onTap: () => Get.toNamed(AppRoutes.notes),
        ),
      ],
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
