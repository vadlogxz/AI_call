import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:elia/core/network/client/api_client.dart';
import 'package:elia/core/network/config/api_endpoints.dart';

class SpeechApiService {
  SpeechApiService(this._apiClient);

  final ApiClient _apiClient;

  Future<String> transcribeBytes(Uint8List bytes) async {
    try {
      final response = await _apiClient.postMultipart(
        ApiEndpoints.sttEndpoint,
        data: FormData.fromMap({
          'audio': MultipartFile.fromBytes(
            bytes,
            filename: 'audio.pcm',
            contentType: DioMediaType('audio', 'pcm'),
          ),
        }),
      );

      final data = response.data;
      if (data is Map && data.containsKey('text')) {
        return data['text'] as String;
      }

      throw FormatException('Unexpected STT response format: $data');
    } on DioException catch (e) {
      throw Exception('STT request failed [${e.response?.statusCode}]: ${e.message}');
    }
  }
}
