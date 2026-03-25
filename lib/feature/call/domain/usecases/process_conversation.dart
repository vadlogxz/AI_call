import 'dart:typed_data';

import 'package:elia/feature/call/data/services/conversation_api_service.dart';
import 'package:elia/feature/call/domain/models/conversation_history_entry.dart';
import 'package:elia/feature/call/domain/models/conversation_result.dart';

class ProcessConversation {
  const ProcessConversation(this._conversationApiService);

  final ConversationApiService _conversationApiService;

  Future<ConversationResult> call({
    required Uint8List audioBytes,
    required String agentId,
    required String targetLanguage,
    List<ConversationHistoryEntry> history = const [],
  }) {
    return _conversationApiService.process(
      audioBytes: audioBytes,
      agentId: agentId,
      targetLanguage: targetLanguage,
      history: history,
    );
  }
}
