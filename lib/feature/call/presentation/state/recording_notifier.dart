import 'dart:async';
import 'dart:collection';

import 'package:elia/feature/agents/presentation/state/agent_config.dart';
import 'package:elia/feature/call/data/services/audio_playback_service.dart';
import 'package:elia/feature/settings/presentation/state/settings_notifier.dart';
import 'package:elia/feature/call/domain/audio/audio_session_coordinator.dart';
import 'package:elia/feature/call/domain/audio/audio_session_event.dart';
import 'package:elia/feature/call/domain/models/recording_status.dart';
import 'package:elia/feature/call/domain/usecases/process_conversation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/recorder_providers.dart';
import 'conversation_state_reducer.dart';
import 'recording_state.dart';

final recordingNotifierProvider =
    NotifierProvider<RecordingNotifier, RecordingState>(RecordingNotifier.new);

class RecordingNotifier extends Notifier<RecordingState> {
  late final AudioSessionCoordinator _audioSessionCoordinator;
  late final ConversationStateReducer _stateReducer;
  late final ProcessConversation _processConversation;
  late final AudioPlaybackService _audioPlaybackService;

  bool _initialized = false;
  bool _isProcessing = false;
  Timer? _timer;
  StreamSubscription<AudioSessionEvent>? _sessionEventSub;
  final Queue<Uint8List> _pendingSegments = Queue();

  @override
  RecordingState build() {
    _audioSessionCoordinator = ref.read(audioSessionCoordinatorProvider);
    _stateReducer = const ConversationStateReducer();
    _processConversation = ref.read(processConversationProvider);
    _audioPlaybackService = ref.read(audioPlaybackServiceProvider);

    if (!_initialized) {
      state = const RecordingState();
      unawaited(_audioSessionCoordinator.initialize());
      _sessionEventSub = _audioSessionCoordinator.events.listen(
        _handleAudioSessionEvent,
      );
      ref.onDispose(_disposeResources);
      _initialized = true;
    }

    return state;
  }

  Future<void> start() async {
    debugPrint('before start: recordStatus=${state.recordingStatus}');
    try {
      state = _stateReducer.resetForStart(state);
      await _audioSessionCoordinator.start();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> stop() async {
    try {
      await _audioSessionCoordinator.stop();
      _isProcessing = false;
      _pendingSegments.clear();
      state = _stateReducer.stopSession(state);
      debugPrint('Recording stopped');
    } catch (e, st) {
      debugPrint('Stop error: $e\n$st');
    }
  }

  Future<void> pause() => _audioSessionCoordinator.pause();

  Future<void> resume() => _audioSessionCoordinator.resume();

  Future<void> stopPlayback() async {
    await _audioPlaybackService.stop();
    _audioSessionCoordinator.setSpeechDetectionSuppressed(false);
    state = _stateReducer.setPlaybackState(state, playing: false);
  }

  void clearGrammarFeedback() {
    state = _stateReducer.clearGrammarFeedback(state);
  }

  void clearPendingVocabulary() {
    state = _stateReducer.clearPendingVocabulary(state);
  }

  void savePendingVocabulary(Set<int> selectedIndices) {
    state = _stateReducer.savePendingVocabulary(state, selectedIndices);
  }

  Future<void> _processSegment(Uint8List bytes) async {
    _isProcessing = true;
    debugPrint('Sending speech segment: ${bytes.length} bytes');

    try {
      state = _stateReducer.setProcessing(state);

      final agentState = ref.read(agentProvider);
      final agent = agentState.selectedAgent ?? kAgents.first;
      final nativeLanguage = ref.read(settingsProvider).speakingLanguage;

      final result = await _processConversation(
        audioBytes: bytes,
        agentId: agent.id,
        targetLanguage: agent.languageCode,
        nativeLanguage: nativeLanguage,
        history: state.history,
      );

      debugPrint('Conversation result: ${result.replyText}');
      state = _stateReducer.applyConversationResult(state, result);

      if (result.replyAudioB64.isNotEmpty) {
        state = _stateReducer.setPlaybackState(state, playing: true);
        _audioSessionCoordinator.setSpeechDetectionSuppressed(true);
        try {
          await _audioPlaybackService.playBase64Wav(result.replyAudioB64);
        } finally {
          _audioSessionCoordinator.setSpeechDetectionSuppressed(false);
        }
      }
    } catch (e, st) {
      debugPrint('Conversation error: $e\n$st');
    } finally {
      state = _stateReducer.setPlaybackState(state, playing: false);
      _isProcessing = false;

      if (_pendingSegments.isNotEmpty) {
        final next = _pendingSegments.removeFirst();
        debugPrint('Processing queued segment (${next.length} bytes)');
        await _processSegment(next);
      }
    }
  }

  void _handleAudioSessionEvent(AudioSessionEvent event) {
    switch (event) {
      case RecordingStatusChanged(:final status):
        _handleRecordingStatus(status);
      case AudioChunkCaptured(:final bytesLength, :final level):
        state = _stateReducer.applyAudioChunk(
          state,
          bytesLength: bytesLength,
          level: level,
        );
      case SpeechSegmentReady(:final bytes):
        if (_isProcessing) {
          _pendingSegments.addLast(bytes);
          return;
        }
        unawaited(_processSegment(bytes));
    }
  }

  void _handleRecordingStatus(RecordingStatus status) {
    state = _stateReducer.applyRecordingStatus(state, status);

    switch (status) {
      case RecordingStatus.paused:
        _timer?.cancel();
        break;
      case RecordingStatus.recording:
        _startTimer();
        break;
      case RecordingStatus.stopped:
        _timer?.cancel();
        state = _stateReducer.resetDuration(state);
        break;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer _) {
      state = _stateReducer.tickDuration(state);
    });
  }

  Future<void> _disposeResources() async {
    _timer?.cancel();
    await _sessionEventSub?.cancel();
    _pendingSegments.clear();
    await _audioPlaybackService.dispose();
  }
}
