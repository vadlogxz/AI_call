import 'package:elia/feature/call/data/models/conversation_response.dart';
import 'package:record/record.dart';

enum ConversationPhase { idle, listening, processing, playing }

class HistoryMessage {
  const HistoryMessage({required this.role, required this.content});

  final String role; // 'user' | 'assistant'
  final String content;

  Map<String, String> toJson() => {'role': role, 'content': content};
}

class ConversationMessage {
  const ConversationMessage({
    required this.isUser,
    required this.text,
    this.corrected,
    this.hasError = false,
    required this.timestamp,
  });

  final bool isUser;
  final String text;
  final String? corrected;
  final bool hasError;
  final DateTime timestamp;
}

class RecordingState {
  const RecordingState({
    this.recordState = RecordState.stop,
    this.recordDuration = Duration.zero,
    this.bytesSent = 0,
    this.amplitude,
    this.volume = 0.5,
    this.lastTranscription,
    this.phase = ConversationPhase.idle,
    this.messages = const [],
    this.history = const [],
    this.currentGrammarCorrection,
    this.isPlayingTts = false,
    this.pendingVocabulary = const [],
  });

  final RecordState recordState;
  final Duration recordDuration;
  final int bytesSent;
  final Amplitude? amplitude;
  final double volume;
  final String? lastTranscription;

  // Conversation
  final ConversationPhase phase;
  final List<ConversationMessage> messages;
  final List<HistoryMessage> history;
  final String? currentGrammarCorrection;
  final bool isPlayingTts;
  final List<VocabWord> pendingVocabulary;

  RecordingState copyWith({
    RecordState? recordState,
    Duration? recordDuration,
    int? bytesSent,
    Amplitude? amplitude,
    double? volume,
    String? lastTranscription,
    ConversationPhase? phase,
    List<ConversationMessage>? messages,
    List<HistoryMessage>? history,
    String? currentGrammarCorrection,
    bool clearGrammarCorrection = false,
    bool? isPlayingTts,
    List<VocabWord>? pendingVocabulary,
  }) {
    return RecordingState(
      recordState: recordState ?? this.recordState,
      recordDuration: recordDuration ?? this.recordDuration,
      bytesSent: bytesSent ?? this.bytesSent,
      amplitude: amplitude ?? this.amplitude,
      volume: volume ?? this.volume,
      lastTranscription: lastTranscription ?? this.lastTranscription,
      phase: phase ?? this.phase,
      messages: messages ?? this.messages,
      history: history ?? this.history,
      currentGrammarCorrection: clearGrammarCorrection
          ? null
          : currentGrammarCorrection ?? this.currentGrammarCorrection,
      isPlayingTts: isPlayingTts ?? this.isPlayingTts,
      pendingVocabulary: pendingVocabulary ?? this.pendingVocabulary,
    );
  }
}
