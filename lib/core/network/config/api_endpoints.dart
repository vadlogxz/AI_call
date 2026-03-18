import 'package:elia/core/network/config/api_config.dart';

class ApiEndpoints {
  static const String authEndpoint = '/auth';
  static const String sttEndpoint = '/stt';
  static const String ttsEndpoint = '/tts';

    static String url(String path) => '${ApiConfig.baseUrl}$path';
}