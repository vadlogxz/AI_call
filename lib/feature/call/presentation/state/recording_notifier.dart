import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:elia/core/config/vad_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:vad/vad.dart';

import '../../data/services/speech_api_service.dart';
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
  late final SpeechApiService _speechApiService;

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
  bool _isSendingSegment = false;

  final VadConfig _vadConfig = VadConfig.getDefault();

  @override
  RecordingState build() {
    _audioRecorder = ref.watch(audioRecorderProvider);
    _startRecording = ref.watch(startRecordingProvider);
    _stopRecording = ref.watch(stopRecordingProvider);
    _vadHandler = VadHandler.create();
    _speechApiService = ref.watch(speechApiServiceProvider);

    if (!_initialized) {
      _preBufferMaxBytes =
          (_vadConfig.minSpeechFrames + _vadConfig.preSpeechPadFrames) *
          _vadConfig.frameSamples *
          2; // 2 bytes per PCM16 sample
      state = const RecordingState();
      _recordSub = _audioRecorder.onStateChanged().listen(_handleRecordState);

      _realStartSub = _vadHandler.onRealSpeechStart.listen((_) {
        debugPrint('✅ REAL SPEECH START');
        // Seed the buffer with pre-speech audio so the beginning isn't cut off
        _currentSpeechBuffer.clear();
        for (final chunk in _preBuffer) {
          _currentSpeechBuffer.addAll(chunk);
        }
        _isSpeechActive = true;
      });

      _speechStartSub = _vadHandler.onSpeechStart.listen((_) {
        debugPrint('🟡 SPEECH START (may include noise)');
      });

      _speechEndSub = _vadHandler.onSpeechEnd.listen((_) async {
        debugPrint('🛑 SPEECH END');

        if (!_isSpeechActive) return;
        if (_isSendingSegment) return;

        _isSpeechActive = false;

        if (_currentSpeechBuffer.isEmpty) {
          debugPrint('Speech buffer is empty');
          return;
        }

        _isSendingSegment = true;

        try {
          final bytes = Uint8List.fromList(
            List<int>.from(_currentSpeechBuffer),
          );
          _currentSpeechBuffer.clear();

          debugPrint('Sending speech segment: ${bytes.length} bytes');

          final text = await _speechApiService.transcribeBytes(bytes);
          debugPrint('STT result: $text');
          state = state.copyWith(lastTranscription: text);
        } catch (e, st) {
          debugPrint('Segment send error: $e\n$st');
        } finally {
          _isSendingSegment = false;
        }
      });

      ref.onDispose(_disposeResources);
      _initialized = true;
    }
    return state;
  }

  Future<void> start() async {
    debugPrint('before start: recordState=${state.recordState}');
    try {
      final rawStream = await _startRecording();
      debugPrint('startRecording returned null? ${rawStream == null}');
      if (rawStream == null) {
        return;
      }

      final stream = rawStream.asBroadcastStream();

      debugPrint('Recording started');

      state = state.copyWith(bytesSent: 0, recordDuration: Duration.zero);

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

      _audioStreamSub = stream.listen(
        (data) {
          state = state.copyWith(bytesSent: state.bytesSent + data.length);
          _updateAmplitudeFromPcm(data);

          // Always maintain rolling pre-buffer for speech-start recovery
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
      await _stopRecording();
      await _vadHandler.stopListening();
      debugPrint('Recording stopped');
    } catch (e, st) {
      debugPrint('Stop error: $e\n$st');
    }
  }

  Future<void> pause() => _audioRecorder.pause();

  Future<void> resume() => _audioRecorder.resume();

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

  void _disposeResources() {
    _timer?.cancel();
    _recordSub?.cancel();
    _audioStreamSub?.cancel();
    _realStartSub?.cancel();
    _speechStartSub?.cancel();
    _speechEndSub?.cancel();
    _vadHandler.dispose();
    _preBuffer.clear();
    _preBufferBytes = 0;
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
