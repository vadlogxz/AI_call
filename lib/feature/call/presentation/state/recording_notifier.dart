import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:elia/core/config/vad_config.dart';
import 'package:elia/feature/agents/presentation/state/agent_config.dart';
import 'package:elia/feature/call/data/services/audio_playback_service.dart';
import 'package:elia/feature/call/data/services/conversation_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:vad/vad.dart';

import '../../di/recorder_providers.dart';
import '../../domain/usecases/start_recording.dart';
import '../../domain/usecases/stop_recording.dart';
import 'recording_state.dart';

final recordingNotifierProvider =
    NotifierProvider<RecordingNotifier, RecordingState>(RecordingNotifier.new);

class RecordingNotifier extends Notifier<RecordingState> {
  late final AudioRecorder _audioRecorder;
  late final StartRecording _startRecording;
  late final StopRecording _stopRecording;
  late final VadHandler _vadHandler;
  late final ConversationApiService _conversationApiService;
  late final AudioPlaybackService _audioPlaybackService;

  bool _initialized = false;
  Timer? _timer;
  StreamSubscription<RecordState>? _recordSub;
  StreamSubscription<Uint8List>? _audioStreamSub;

  StreamSubscription? _realStartSub;
  StreamSubscription? _speechStartSub;
  StreamSubscription? _speechEndSub;

  final List<int> _currentSpeechBuffer = [];
  final ListQueue<Uint8List> _preBuffer = ListQueue();
  int _preBufferBytes = 0;
  late final int _preBufferMaxBytes;

  bool _isSpeechActive = false;
  bool _isProcessing = false;
  bool _suppressVad = false; // true while TTS is playing → ignore mic input

  // After onSpeechEnd we wait this long before actually sending.
  // If the user resumes speaking within this window the buffer keeps growing.
  static const _speechDebounceMs = 1200;
  Timer? _speechDebounceTimer;

  // Segments captured while _isProcessing was true
  final Queue<Uint8List> _pendingSegments = Queue();

  final VadConfig _vadConfig = VadConfig.getDefault();

  @override
  RecordingState build() {
    // Use ref.read for stable dependencies to avoid spurious build() calls
    // that would recreate _vadHandler and break speech detection.
    _audioRecorder = ref.read(audioRecorderProvider);
    _startRecording = ref.read(startRecordingProvider);
    _stopRecording = ref.read(stopRecordingProvider);
    _conversationApiService = ref.read(conversationApiServiceProvider);
    _audioPlaybackService = ref.read(audioPlaybackServiceProvider);

    if (!_initialized) {
      // VadHandler MUST be created once — subscriptions are bound to this instance.
      _vadHandler = VadHandler.create();

      _preBufferMaxBytes =
          (_vadConfig.minSpeechFrames + _vadConfig.preSpeechPadFrames) *
          _vadConfig.frameSamples *
          2; // 2 bytes per PCM16 sample

      state = const RecordingState();
      _recordSub = _audioRecorder.onStateChanged().listen(_handleRecordState);

      _realStartSub = _vadHandler.onRealSpeechStart.listen((_) {
        if (_suppressVad) return;

        if (_speechDebounceTimer?.isActive == true) {
          // User resumed mid-debounce — cancel flush, keep accumulating
          _speechDebounceTimer!.cancel();
          debugPrint('↩️ Speech resumed — merging into same segment');
          _isSpeechActive = true;
          return;
        }

        debugPrint('✅ REAL SPEECH START');
        _currentSpeechBuffer.clear();
        for (final chunk in _preBuffer) {
          _currentSpeechBuffer.addAll(chunk);
        }
        _isSpeechActive = true;
      });

      _speechStartSub = _vadHandler.onSpeechStart.listen((_) {
        debugPrint('🟡 SPEECH START (may include noise)');
      });

      _speechEndSub = _vadHandler.onSpeechEnd.listen((_) {
        debugPrint('🛑 SPEECH END — debouncing');

        if (!_isSpeechActive) return;
        if (_suppressVad) return;

        // Keep _isSpeechActive = true during debounce so audio keeps buffering
        _speechDebounceTimer?.cancel();
        _speechDebounceTimer = Timer(
          const Duration(milliseconds: _speechDebounceMs),
          _flushSpeechBuffer,
        );
      });

      ref.onDispose(_disposeResources);
      _initialized = true;
    }
    return state;
  }

  // ── Core processing loop ──────────────────────────────────────────────────

  void _flushSpeechBuffer() {
    _isSpeechActive = false;

    if (_currentSpeechBuffer.isEmpty) {
      debugPrint('Speech buffer empty, nothing to flush');
      return;
    }

    final bytes = Uint8List.fromList(List<int>.from(_currentSpeechBuffer));
    _currentSpeechBuffer.clear();
    debugPrint('Flushing speech segment: ${bytes.length} bytes');

    if (_isProcessing) {
      _pendingSegments.addLast(bytes);
      debugPrint('Queued (processing in progress)');
      return;
    }

    _processSegment(bytes);
  }

  Future<void> _processSegment(Uint8List bytes) async {
    _isProcessing = true;
    debugPrint('Sending speech segment: ${bytes.length} bytes');

    try {
      state = state.copyWith(
        phase: ConversationPhase.processing,
        clearGrammarCorrection: true,
      );

      final agentState = ref.read(agentProvider);
      final agent = agentState.selectedAgent ?? kAgents.first;

      final result = await _conversationApiService.process(
        audioBytes: bytes,
        agentId: agent.id,
        targetLanguage: agent.languageCode,
        history: state.history,
      );

      debugPrint('Conversation result: ${result.replyText}');

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

      state = state.copyWith(
        lastTranscription: result.userText,
        messages: [...state.messages, userMsg, aiMsg],
        history: [
          ...state.history,
          HistoryMessage(role: 'user', content: result.userText),
          HistoryMessage(role: 'assistant', content: result.replyText),
        ],
        currentGrammarCorrection: result.hasError ? result.corrected : null,
        pendingVocabulary: result.vocabulary,
      );

      if (result.replyAudioB64.isNotEmpty) {
        state = state.copyWith(
          phase: ConversationPhase.playing,
          isPlayingTts: true,
        );
        _suppressVad = true; // mute mic echo during playback
        try {
          await _audioPlaybackService.playBase64Wav(result.replyAudioB64);
        } finally {
          _suppressVad = false;
        }
      }
    } catch (e, st) {
      debugPrint('Conversation error: $e\n$st');
    } finally {
      state = state.copyWith(
        phase: ConversationPhase.listening,
        isPlayingTts: false,
      );
      _isProcessing = false;

      // Drain queued segments one at a time
      if (_pendingSegments.isNotEmpty) {
        final next = _pendingSegments.removeFirst();
        debugPrint('Processing queued segment (${next.length} bytes)');
        await _processSegment(next);
      }
    }
  }

  // ── Public controls ───────────────────────────────────────────────────────

  Future<void> start() async {
    debugPrint('before start: recordState=${state.recordState}');
    try {
      final rawStream = await _startRecording();
      debugPrint('startRecording returned null? ${rawStream == null}');
      if (rawStream == null) return;

      final stream = rawStream.asBroadcastStream();
      debugPrint('Recording started');

      state = state.copyWith(
        bytesSent: 0,
        recordDuration: Duration.zero,
        phase: ConversationPhase.listening,
      );

      await _vadHandler.startListening(
        audioStream: stream,
        model: _vadConfig.model.name,
        frameSamples: _vadConfig.frameSamples,
        positiveSpeechThreshold: _vadConfig.positiveSpeechThreshold,
        negativeSpeechThreshold: _vadConfig.negativeSpeechThreshold,
        minSpeechFrames: _vadConfig.minSpeechFrames,
        preSpeechPadFrames: _vadConfig.preSpeechPadFrames,
        endSpeechPadFrames: _vadConfig.endSpeechPadFrames,
        redemptionFrames: _vadConfig.redemptionFrames,
        numFramesToEmit: _vadConfig.numFramesToEmit,
      );

      await _audioStreamSub?.cancel();
      _audioStreamSub = stream.listen(
        (data) {
          state = state.copyWith(bytesSent: state.bytesSent + data.length);
          _updateAmplitudeFromPcm(data);

          if (_suppressVad) return; // don't buffer speaker echo

          _preBuffer.addLast(data);
          _preBufferBytes += data.length;
          while (_preBufferBytes > _preBufferMaxBytes) {
            _preBufferBytes -= _preBuffer.removeFirst().length;
          }

          if (_isSpeechActive) {
            _currentSpeechBuffer.addAll(data);
          }
        },
        onError: (e, st) {
          debugPrint('audio stream error: $e');
        },
        onDone: () {
          debugPrint('audio stream done');
        },
        cancelOnError: true,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> stop() async {
    try {
      await _audioStreamSub?.cancel();
      _audioStreamSub = null;
      await _stopRecording();
      await _vadHandler.stopListening();
      _speechDebounceTimer?.cancel();
      _isSpeechActive = false;
      _isProcessing = false;
      _suppressVad = false;
      _currentSpeechBuffer.clear();
      _preBuffer.clear();
      _preBufferBytes = 0;
      _pendingSegments.clear();
      state = state.copyWith(phase: ConversationPhase.idle);
      debugPrint('Recording stopped');
    } catch (e, st) {
      debugPrint('Stop error: $e\n$st');
    }
  }

  Future<void> stopPlayback() async {
    await _audioPlaybackService.stop();
    _suppressVad = false;
    state = state.copyWith(
      phase: ConversationPhase.listening,
      isPlayingTts: false,
    );
  }

  void clearGrammarFeedback() {
    state = state.copyWith(clearGrammarCorrection: true);
  }

  void clearPendingVocabulary() {
    state = state.copyWith(pendingVocabulary: []);
  }

  Future<void> pause() => _audioRecorder.pause();
  Future<void> resume() => _audioRecorder.resume();

  // ── Internal ──────────────────────────────────────────────────────────────

  void _handleRecordState(RecordState recordState) {
    state = state.copyWith(recordState: recordState);
    switch (recordState) {
      case RecordState.pause:
        _timer?.cancel();
        break;
      case RecordState.record:
        _startTimer();
        break;
      case RecordState.stop:
        _timer?.cancel();
        state = state.copyWith(recordDuration: Duration.zero);
        break;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      state = state.copyWith(
        recordDuration: state.recordDuration + const Duration(seconds: 1),
      );
    });
  }

  Future<void> _disposeResources() async {
    _timer?.cancel();
    _speechDebounceTimer?.cancel();
    _recordSub?.cancel();
    _audioStreamSub?.cancel();
    _realStartSub?.cancel();
    _speechStartSub?.cancel();
    _speechEndSub?.cancel();
    _vadHandler.dispose();
    _preBuffer.clear();
    _preBufferBytes = 0;
    _pendingSegments.clear();
    await _audioPlaybackService.dispose();
  }

  void _updateAmplitudeFromPcm(Uint8List data) {
    if (data.isEmpty) return;
    final sampleCount = data.length ~/ 2;
    if (sampleCount == 0) return;

    double sumSquares = 0;
    for (var i = 0; i < data.length - 1; i += 2) {
      final lo = data[i];
      final hi = data[i + 1];
      var sample = (hi << 8) | lo;
      if (sample & 0x8000 != 0) {
        sample = sample - 0x10000;
      }
      final normalized = sample / 32768.0;
      sumSquares += normalized * normalized;
    }

    final rms = math.sqrt(sumSquares / sampleCount);
    if (!rms.isFinite) return;

    final prevMax = state.amplitude?.max ?? 0.0;
    final maxVal = rms > prevMax ? rms : prevMax;

    final amplitude = Amplitude(current: rms, max: maxVal);
    state = state.copyWith(amplitude: amplitude);
  }
}
