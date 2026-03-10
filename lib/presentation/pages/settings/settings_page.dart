import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/error_snackbar.dart';
import '../../../core/network/dio_client.dart';
import 'package:dio/dio.dart';
import '../../controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTextStyles.heading3.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            Text(
              'Profile',
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsTile(
              context,
              icon: Icons.person_outline,
              title: 'Display Name',
              subtitle: controller.userName.value,
              onTap: () => _editName(context, controller),
            ),
            const SizedBox(height: 24),

            // Appearance
            Text(
              'Appearance',
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => _buildSettingsTile(
                  context,
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: controller.themeMode.value == ThemeMode.dark,
                    onChanged: (_) => controller.toggleTheme(),
                    activeTrackColor: AppColors.primary,
                  ),
                )),
            const SizedBox(height: 24),

            // API
            Text(
              'API Configuration',
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => _buildSettingsTile(
                  context,
                  icon: Icons.key_outlined,
                  title: 'API Key',
                  subtitle: controller.hasApiKey
                      ? '••••••••${controller.apiKey.value.substring(controller.apiKey.value.length > 8 ? controller.apiKey.value.length - 4 : 0)}'
                      : 'Not set',
                  onTap: () => _editApiKey(context, controller),
                )),
            const SizedBox(height: 24),

            // AI Persona
            Text(
              'AI Settings',
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsTile(
              context,
              icon: Icons.smart_toy_outlined,
              title: 'AI Persona',
              subtitle: 'Change AI behavior mode',
              onTap: () => Get.toNamed(AppRoutes.personas),
            ),
            const SizedBox(height: 24),

            // Data
            Text(
              'Data',
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsTile(
              context,
              icon: Icons.delete_outline,
              title: 'Clear All Data',
              subtitle: 'Remove all chats, todos, and notes',
              titleColor: AppColors.error,
              onTap: () => _confirmClearData(context, controller),
            ),
            const SizedBox(height: 32),

            // About
            Center(
              child: Column(
                children: [
                  Text(
                    AppConstants.appName,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Powered by OpenClaw AI',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: titleColor ?? AppColors.textSecondary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      color: titleColor ??
                          Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
                (onTap != null
                    ? const Icon(Icons.chevron_right,
                        color: AppColors.textMuted)
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  void _editName(BuildContext context, SettingsController controller) {
    final textController =
        TextEditingController(text: controller.userName.value);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Name'),
        content: AppTextField(
          controller: textController,
          hintText: 'Your name',
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                controller.updateUserName(textController.text.trim());
                Get.back();
                showSuccessSnackbar('Name updated!');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editApiKey(BuildContext context, SettingsController controller) {
    final textController =
        TextEditingController(text: controller.apiKey.value);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: textController,
              hintText: 'sk-...',
              autofocus: true,
            ),
            const SizedBox(height: 8),
            Text(
              'Your API key is stored locally on this device.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                controller.updateApiKey(textController.text.trim());
                DioClient.updateApiKey(
                    Get.find<Dio>(), textController.text.trim());
                Get.back();
                showSuccessSnackbar('API key updated!');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmClearData(
      BuildContext context, SettingsController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your chats, todos, notes, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await controller.clearAllData();
              Get.back();
              Get.offAllNamed(AppRoutes.onboarding);
            },
            child: const Text('Clear All',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
