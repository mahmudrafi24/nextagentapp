import 'package:get_storage/get_storage.dart';
import '../../../core/constants/storage_keys.dart';

class StorageService {
  final GetStorage _storage = GetStorage();

  // API Key
  void saveApiKey(String key) => _storage.write(StorageKeys.apiKey, key);
  String? getApiKey() => _storage.read<String>(StorageKeys.apiKey);
  bool get hasApiKey {
    final key = getApiKey();
    return key != null && key.isNotEmpty;
  }

  // User Name
  void saveUserName(String name) => _storage.write(StorageKeys.userName, name);
  String? getUserName() => _storage.read<String>(StorageKeys.userName);

  // Onboarding
  void setOnboardingComplete() =>
      _storage.write(StorageKeys.onboardingComplete, true);
  bool get isOnboardingComplete =>
      _storage.read<bool>(StorageKeys.onboardingComplete) ?? false;

  // Persona
  void saveCurrentPersona(String persona) =>
      _storage.write(StorageKeys.currentPersona, persona);
  String getCurrentPersona() =>
      _storage.read<String>(StorageKeys.currentPersona) ?? 'assistant';

  // Selected Model
  void saveSelectedModel(String model) =>
      _storage.write(StorageKeys.selectedModel, model);
  String getSelectedModel() =>
      _storage.read<String>(StorageKeys.selectedModel) ?? 'claude';

  // Theme
  void saveThemeMode(String mode) =>
      _storage.write(StorageKeys.themeMode, mode);
  String getThemeMode() =>
      _storage.read<String>(StorageKeys.themeMode) ?? 'dark';

  // Clear all
  Future<void> clearAll() async {
    await _storage.erase();
  }
}
