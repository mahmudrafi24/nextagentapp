import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

void showErrorSnackbar(String message) {
  Get.snackbar(
    'Error',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.error.withValues(alpha: 0.9),
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
    borderRadius: 8,
    duration: const Duration(seconds: 3),
  );
}

void showSuccessSnackbar(String message) {
  Get.snackbar(
    'Success',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.success.withValues(alpha: 0.9),
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
    borderRadius: 8,
    duration: const Duration(seconds: 2),
  );
}

void showInfoSnackbar(String message) {
  Get.snackbar(
    'Info',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.primary.withValues(alpha: 0.9),
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
    borderRadius: 8,
    duration: const Duration(seconds: 2),
  );
}
