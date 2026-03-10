import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class RecentChatsList extends StatelessWidget {
  const RecentChatsList({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder for recent chats
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline,
              size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(
            'No recent chats',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
