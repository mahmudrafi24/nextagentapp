import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/local/hive_service.dart';
import '../../data/datasources/local/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storageService;
  final HiveService _hiveService;

  SettingsController({
    required StorageService storageService,
    required HiveService hiveService,
  })  : _storageService = storageService,
        _hiveService = hiveService;

  final Rx<ThemeMode> themeMode = ThemeMode.dark.obs;
  final RxString apiKey = ''.obs;
  final RxString userName = ''.obs;
  final RxString selectedModel = 'claude'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    final mode = _storageService.getThemeMode();
    themeMode.value = mode == 'light' ? ThemeMode.light : ThemeMode.dark;
    apiKey.value = _storageService.getApiKey() ?? '';
    userName.value = _storageService.getUserName() ?? '';
    selectedModel.value = _storageService.getSelectedModel();
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
      _storageService.saveThemeMode('light');
    } else {
      themeMode.value = ThemeMode.dark;
      _storageService.saveThemeMode('dark');
    }
  }

  void updateApiKey(String key) {
    apiKey.value = key;
    _storageService.saveApiKey(key);
  }

  void updateUserName(String name) {
    userName.value = name;
    _storageService.saveUserName(name);
  }

  Future<void> clearAllData() async {
    await _hiveService.clearAll();
    await _storageService.clearAll();
  }

  void updateSelectedModel(String model) {
    selectedModel.value = model;
    _storageService.saveSelectedModel(model);
  }

  bool get hasApiKey => apiKey.value.isNotEmpty;
}
