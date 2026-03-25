import 'package:elia/feature/call/domain/models/audio_level.dart';
import 'package:elia/feature/call/domain/models/conversation_history_entry.dart';
import 'package:elia/feature/call/domain/models/conversation_result.dart';
import 'package:elia/feature/call/domain/models/recording_status.dart';

import 'recording_state.dart';

class ConversationStateReducer {
  const ConversationStateReducer();

  RecordingState resetForStart(RecordingState state) {
    return state.copyWith(
      bytesSent: 0,
      recordDuration: Duration.zero,
      phase: ConversationPhase.listening,
      clearGrammarCorrection: true,
      clearSessionSavedWords: true,
      amplitude: const AudioLevel(current: 0, max: 0),
    );
  }

  RecordingState setProcessing(RecordingState state) {
    return state.copyWith(
      phase: ConversationPhase.processing,
      clearGrammarCorrection: true,
    );
  }

  RecordingState applyConversationResult(
    RecordingState state,
    ConversationResult result,
  ) {
    final userMsg = ConversationMessage(
      isUser: true,
      text: result.userText.isNotEmpty ? result.userText : '...',
      corrected: result.hasError ? result.corrected : null,
      hasError: result.hasError,
      timestamp: DateTime.now(),
    );

    final aiMsg = ConversationMessage(
      isUser: false,
      text: result.replyText,
      timestamp: DateTime.now(),
    );

    return state.copyWith(
      lastTranscription: result.userText,
      messages: [...state.messages, userMsg, aiMsg],
      history: [
        ...state.history,
        ConversationHistoryEntry(role: 'user', content: result.userText),
        ConversationHistoryEntry(role: 'assistant', content: result.replyText),
      ],
      currentGrammarCorrection: result.hasError ? result.corrected : null,
      pendingVocabulary: result.vocabulary,
    );
  }

  RecordingState setPlaybackState(
    RecordingState state, {
    required bool playing,
  }) {
    return state.copyWith(
      phase: playing ? ConversationPhase.playing : ConversationPhase.listening,
      isPlayingTts: playing,
    );
  }

  RecordingState clearGrammarFeedback(RecordingState state) {
    return state.copyWith(clearGrammarCorrection: true);
  }

  RecordingState clearPendingVocabulary(RecordingState state) {
    return state.copyWith(pendingVocabulary: []);
  }

  RecordingState savePendingVocabulary(
    RecordingState state,
    Set<int> selectedIndices,
  ) {
    final saved = [
      for (final i in selectedIndices)
        if (i < state.pendingVocabulary.length) state.pendingVocabulary[i],
    ];
    return state.copyWith(
      pendingVocabulary: [],
      sessionSavedWords: [
        ...state.sessionSavedWords,
        ...saved.map((w) => w.word),
      ],
    );
  }

  RecordingState applyAudioChunk(
    RecordingState state, {
    required int bytesLength,
    required AudioLevel level,
  }) {
    final prevMax = state.amplitude?.max ?? 0.0;
    final nextMax = level.current > prevMax ? level.current : prevMax;

    return state.copyWith(
      bytesSent: state.bytesSent + bytesLength,
      amplitude: AudioLevel(current: level.current, max: nextMax),
    );
  }

  RecordingState applyRecordingStatus(
    RecordingState state,
    RecordingStatus status,
  ) {
    return state.copyWith(recordingStatus: status);
  }

  RecordingState tickDuration(RecordingState state) {
    return state.copyWith(
      recordDuration: state.recordDuration + const Duration(seconds: 1),
    );
  }

  RecordingState stopSession(RecordingState state) {
    return state.copyWith(
      phase: ConversationPhase.idle,
      isPlayingTts: false,
      amplitude: const AudioLevel(current: 0, max: 0),
    );
  }

  RecordingState resetDuration(RecordingState state) {
    return state.copyWith(recordDuration: Duration.zero);
  }
}
