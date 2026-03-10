class Validators {
  Validators._();

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateApiKey(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your API key';
    }
    if (value.trim().length < 10) {
      return 'API key seems too short';
    }
    return null;
  }

  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}
