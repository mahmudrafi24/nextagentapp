class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.openclaw.ai/v1';
  static const String chatEndpoint = '/messages';
  static const String model = 'claude-sonnet-4-20250514';
  static const int maxTokens = 1024;
  static const int timeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 60;
  static const String anthropicVersion = '2023-06-01';
}
