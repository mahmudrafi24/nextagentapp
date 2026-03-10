import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../controllers/home_controller.dart';

class MorningBriefingCard extends StatelessWidget {
  const MorningBriefingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny_outlined,
                  color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                'Daily Briefing',
                style: AppTextStyles.label.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingBriefing.value) {
              return const Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white70),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Text(
              controller.morningBriefing.value,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                height: 1.6,
              ),
            );
          }),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: controller.fetchMorningBriefing,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh, color: Colors.white60, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Refresh',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
