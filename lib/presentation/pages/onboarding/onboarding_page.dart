import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
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
  int _currentPage = 0;
  String _selectedModel = 'claude';

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
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
    final storage = Get.find<StorageService>();
    final settings = Get.find<SettingsController>();

    storage.saveUserName(_nameController.text.trim());
    settings.updateUserName(_nameController.text.trim());

    storage.saveSelectedModel(_selectedModel);
    settings.updateSelectedModel(_selectedModel);

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
                  _buildModelSelectionPage(),
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

  static const List<Map<String, String>> _aiModels = [
    {'id': 'chatgpt', 'name': 'ChatGPT', 'icon': '\u{1F7E2}', 'desc': 'OpenAI\'s versatile language model'},
    {'id': 'claude', 'name': 'Claude', 'icon': '\u{1F7E3}', 'desc': 'Anthropic\'s helpful AI assistant'},
    {'id': 'grok', 'name': 'Grok', 'icon': '\u{26A1}', 'desc': 'xAI\'s witty and informative model'},
    {'id': 'deepseek', 'name': 'DeepSeek', 'icon': '\u{1F50D}', 'desc': 'Advanced reasoning AI model'},
    {'id': 'moonshot', 'name': 'Moonshot', 'icon': '\u{1F319}', 'desc': 'Kimi\'s powerful language model'},
  ];

  Widget _buildModelSelectionPage() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose Your AI Model",
                  style: AppTextStyles.heading1.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Select the AI model you'd like to use. You can change this later in settings.",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: _aiModels.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final model = _aiModels[index];
                      final isSelected = _selectedModel == model['id'];

                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedModel = model['id']!);
                        },
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
                              Text(model['icon']!,
                                  style: const TextStyle(fontSize: 28)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model['name']!,
                                      style: AppTextStyles.heading3.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      model['desc']!,
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
    );
  }
}
