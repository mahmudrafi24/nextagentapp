import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/datasources/local/storage_service.dart';
import '../../../data/models/persona_model.dart';
import '../../../presentation/controllers/persona_controller.dart';
import '../../../presentation/controllers/settings_controller.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0) {
      if (_nameController.text.trim().isEmpty) {
        Get.snackbar('Name Required', 'Please enter your name to continue',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
    }
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _complete() {
    if (!_formKey.currentState!.validate()) return;

    final storage = Get.find<StorageService>();
    final settings = Get.find<SettingsController>();

    storage.saveUserName(_nameController.text.trim());
    settings.updateUserName(_nameController.text.trim());

    storage.saveApiKey(_apiKeyController.text.trim());
    settings.updateApiKey(_apiKeyController.text.trim());

    // Update Dio with new API key
    final dio = Get.find<Dio>();
    DioClient.updateApiKey(dio, _apiKeyController.text.trim());

    storage.setOnboardingComplete();
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? AppColors.primary
                            : AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildNamePage(),
                  _buildPersonaPage(),
                  _buildApiKeyPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNamePage() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to OpenClaw AI",
                  style: AppTextStyles.heading1.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Let's personalize your experience. What should I call you?",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                AppTextField(
                  controller: _nameController,
                  hintText: 'Enter your name',
                  prefixIcon: Icons.person_outline,
                  autofocus: true,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: AppButton(
            text: 'Continue',
            onPressed: _nextPage,
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonaPage() {
    final personaController = Get.find<PersonaController>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            "Choose Your AI Mode",
            style: AppTextStyles.heading1.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "You can always change this later",
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(() {
              final currentMode = personaController.currentMode.value;
              return ListView.separated(
                  itemCount: PersonaModel.defaultPersonas.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final persona = PersonaModel.defaultPersonas[index];
                    final isSelected = currentMode == persona.mode;

                    return GestureDetector(
                      onTap: () =>
                          personaController.selectPersona(persona.mode),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(persona.icon,
                                style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    persona.name,
                                    style: AppTextStyles.heading3.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    persona.description,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle,
                                  color: AppColors.primary),
                          ],
                        ),
                      ),
                    );
                  },
                );
            }),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Continue',
            onPressed: _nextPage,
            width: double.infinity,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildApiKeyPage() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter Your API Key",
                    style: AppTextStyles.heading1.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Your OpenClaw API key is stored locally on your device and never shared.",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),
                  AppTextField(
                    controller: _apiKeyController,
                    hintText: 'sk-...',
                    prefixIcon: Icons.key_outlined,
                    validator: Validators.validateApiKey,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline,
                            color: AppColors.accent, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your API key is stored securely on this device only.',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: AppButton(
              text: "Let's Go!",
              onPressed: _complete,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
