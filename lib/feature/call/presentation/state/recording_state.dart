import 'package:elia/feature/call/domain/models/audio_level.dart';
import 'package:elia/feature/call/domain/models/conversation_history_entry.dart';
import 'package:elia/feature/call/domain/models/conversation_result.dart';
import 'package:elia/feature/call/domain/models/recording_status.dart';

enum ConversationPhase { idle, listening, processing, playing }

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
    this.recordingStatus = RecordingStatus.stopped,
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
    this.sessionSavedWords = const [],
  });

  final RecordingStatus recordingStatus;
  final Duration recordDuration;
  final int bytesSent;
  final AudioLevel? amplitude;
  final double volume;
  final String? lastTranscription;

  // Conversation
  final ConversationPhase phase;
  final List<ConversationMessage> messages;
  final List<ConversationHistoryEntry> history;
  final String? currentGrammarCorrection;
  final bool isPlayingTts;
  final List<ConversationVocabulary> pendingVocabulary;

  /// Words saved to dictionary during the current session (word strings only).
  final List<String> sessionSavedWords;

  RecordingState copyWith({
    RecordingStatus? recordingStatus,
    Duration? recordDuration,
    int? bytesSent,
    AudioLevel? amplitude,
    double? volume,
    String? lastTranscription,
    ConversationPhase? phase,
    List<ConversationMessage>? messages,
    List<ConversationHistoryEntry>? history,
    String? currentGrammarCorrection,
    bool clearGrammarCorrection = false,
    bool? isPlayingTts,
    List<ConversationVocabulary>? pendingVocabulary,
    List<String>? sessionSavedWords,
    bool clearSessionSavedWords = false,
  }) {
    return RecordingState(
      recordingStatus: recordingStatus ?? this.recordingStatus,
      recordDuration: recordDuration ?? this.recordDuration,
      bytesSent: bytesSent ?? this.bytesSent,
      amplitude: amplitude ?? this.amplitude,
      volume: volume ?? this.volume,
      lastTranscription: lastTranscription ?? this.lastTranscription,
      phase: phase ?? this.phase,
      messages: messages ?? this.messages,
      history: history ?? this.history,
      currentGrammarCorrection:
          clearGrammarCorrection
              ? null
              : currentGrammarCorrection ?? this.currentGrammarCorrection,
      isPlayingTts: isPlayingTts ?? this.isPlayingTts,
      pendingVocabulary: pendingVocabulary ?? this.pendingVocabulary,
      sessionSavedWords:
          clearSessionSavedWords
              ? []
              : sessionSavedWords ?? this.sessionSavedWords,
    );
  }
}
