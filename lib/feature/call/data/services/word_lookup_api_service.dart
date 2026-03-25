import 'package:dio/dio.dart';
import 'package:elia/core/network/client/api_client.dart';
import 'package:elia/core/network/config/api_endpoints.dart';
import 'package:elia/feature/call/domain/models/word_lookup_result.dart';

class WordLookupApiService {
  const WordLookupApiService(this._apiClient);

  final ApiClient _apiClient;

  Future<WordLookupResult> lookup({
    required String word,
    required String context,
    required String targetLanguage,
    required String nativeLanguage,
  }) async {
    try {
      final response = await _apiClient.postJson(
        ApiEndpoints.wordLookupEndpoint,
        data: {
          'word': word,
          'context': context,
          'target_language': targetLanguage,
          'native_language': nativeLanguage,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return WordLookupResult(
          word: data['word'] as String? ?? word,
          translation: data['translation'] as String? ?? '',
          partOfSpeech: data['part_of_speech'] as String? ?? '',
          example: data['example'] as String? ?? '',
        );
      }

      throw FormatException('Unexpected word lookup response format: $data');
    } on DioException catch (e) {
      throw Exception(
        'Word lookup failed [${e.response?.statusCode}]: ${e.message}',
      );
    }
  }
}
