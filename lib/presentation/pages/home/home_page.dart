import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../controllers/home_controller.dart';
import 'widgets/morning_briefing_card.dart';
import 'widgets/quick_actions_row.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentTabIndex.value,
            children: [
              _HomeTab(controller: controller),
              _ChatListTab(),
              _TodoTab(),
              _MoreTab(),
            ],
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.currentTabIndex.value,
            onTap: controller.changeTab,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                activeIcon: Icon(Icons.check_circle),
                label: 'Todo',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                activeIcon: Icon(Icons.more_horiz),
                label: 'More',
              ),
            ],
          )),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final HomeController controller;
  const _HomeTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Obx(() => Text(
                  '${controller.greeting.value}, ${controller.userName.value.isNotEmpty ? controller.userName.value : 'there'}!',
                  style: AppTextStyles.heading1.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )),
            const SizedBox(height: 24),
            const MorningBriefingCard(),
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: AppTextStyles.heading3.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            const QuickActionsRow(),
            const SizedBox(height: 24),
            Text(
              'Get Started',
              style: AppTextStyles.heading3.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context,
              icon: Icons.auto_awesome,
              title: 'Ask AI Anything',
              subtitle: 'Start a conversation with Claw',
              color: AppColors.primary,
              onTap: () => Get.toNamed(AppRoutes.chat),
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context,
              icon: Icons.edit_note,
              title: 'Writing Assistant',
              subtitle: 'Improve, rewrite, or translate text',
              color: AppColors.accent,
              onTap: () => Get.toNamed(AppRoutes.writing),
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context,
              icon: Icons.note_add_outlined,
              title: 'Smart Notes',
              subtitle: 'Take notes with AI summarization',
              color: AppColors.accentWarm,
              onTap: () => Get.toNamed(AppRoutes.notes),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading3.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppColors.textMuted, size: 24),
          ],
        ),
      ),
    );
  }
}

class _ChatListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Conversations',
                  style: AppTextStyles.heading1.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.toNamed(AppRoutes.chat),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      'No conversations yet',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start a new chat with Claw',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.chat),
                      icon: const Icon(Icons.add),
                      label: const Text('New Chat'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'My Todos',
              style: AppTextStyles.heading1.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      'No todos yet',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.todo),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Todo'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'More',
              style: AppTextStyles.heading1.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            _buildMenuItem(
              context,
              icon: Icons.edit_note,
              title: 'Writing Assistant',
              onTap: () => Get.toNamed(AppRoutes.writing),
            ),
            _buildMenuItem(
              context,
              icon: Icons.note_outlined,
              title: 'Notes',
              onTap: () => Get.toNamed(AppRoutes.notes),
            ),
            _buildMenuItem(
              context,
              icon: Icons.person_outline,
              title: 'AI Personas',
              onTap: () => Get.toNamed(AppRoutes.personas),
            ),
            const Divider(height: 32),
            _buildMenuItem(
              context,
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () => Get.toNamed(AppRoutes.settings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing:
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
