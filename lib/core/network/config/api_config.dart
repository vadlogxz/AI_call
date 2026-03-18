import 'package:elia/core/config/app_config.dart';

class ApiConfig {
  static const String baseUrl = AppConfig.apiBaseUrl;
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
