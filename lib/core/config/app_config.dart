class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    // defaultValue: 'http://127.0.0.1:8787',
    defaultValue: 'http://10.0.2.2:8787',
  );
}
