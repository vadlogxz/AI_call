import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:elia/core/network/client/api_client.dart';
import 'package:elia/core/network/config/api_endpoints.dart';
import 'package:elia/feature/call/data/models/conversation_response.dart';
import 'package:elia/feature/call/presentation/state/recording_state.dart';

class ConversationApiService {
  ConversationApiService(this._apiClient);

  final ApiClient _apiClient;

  Future<ConversationResponse> process({
    required Uint8List audioBytes,
    required String agentId,
    required String targetLanguage,
    List<HistoryMessage> history = const [],
  }) async {
    try {
      final settings = jsonEncode({
        'agent_id': agentId,
        'target_language': targetLanguage,
        if (history.isNotEmpty) 'history': history.map((m) => m.toJson()).toList(),
      });

      final response = await _apiClient.postMultipart(
        ApiEndpoints.conversationEndpoint,
        data: FormData.fromMap({
          'settings': settings,
          'audio': MultipartFile.fromBytes(
            audioBytes,
            filename: 'audio.pcm',
            contentType: DioMediaType('audio', 'pcm'),
          ),
        }),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ConversationResponse.fromJson(data);
      }

      throw FormatException('Unexpected conversation response format: $data');
    } on DioException catch (e) {
      throw Exception(
        'Conversation request failed [${e.response?.statusCode}]: ${e.message}',
      );
    }
  }
}
