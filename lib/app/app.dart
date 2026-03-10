import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../presentation/controllers/settings_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class OpenClawApp extends StatelessWidget {
  const OpenClawApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Obx(() => GetMaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settingsController.themeMode.value,
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
          defaultTransition: Transition.cupertino,
        ));
  }
}
