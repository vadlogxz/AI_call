import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:elia/core/config/vad_config.dart';
import 'package:elia/feature/call/domain/audio/audio_session_event.dart';
import 'package:elia/feature/call/domain/engines/audio_recorder_engine.dart';
import 'package:elia/feature/call/domain/engines/speech_detector_engine.dart';
import 'package:elia/feature/call/domain/models/audio_level.dart';

class AudioSessionCoordinator {
  AudioSessionCoordinator({
    required AudioRecorderEngine recorderEngine,
    required SpeechDetectorEngine speechDetectorEngine,
    VadConfig? vadConfig,
  }) : _recorderEngine = recorderEngine,
       _speechDetectorEngine = speechDetectorEngine,
       _vadConfig = vadConfig ?? VadConfig.getDefault();

  final AudioRecorderEngine _recorderEngine;
  final SpeechDetectorEngine _speechDetectorEngine;
  final VadConfig _vadConfig;

  final StreamController<AudioSessionEvent> _events =
      StreamController<AudioSessionEvent>.broadcast();

  StreamSubscription? _recordStatusSub;
  StreamSubscription<Uint8List>? _audioStreamSub;
  StreamSubscription? _speechStartSub;
  StreamSubscription? _realSpeechStartSub;
  StreamSubscription? _speechEndSub;

  final List<int> _currentSpeechBuffer = [];
  final ListQueue<Uint8List> _preBuffer = ListQueue();
  final int _bytesPerSample = 2;
  late final int _preBufferMaxBytes =
      (_vadConfig.minSpeechFrames + _vadConfig.preSpeechPadFrames) *
      _vadConfig.frameSamples *
      _bytesPerSample;

  int _preBufferBytes = 0;
  bool _isSpeechActive = false;
  bool _suppressSpeechDetection = false;
  bool _initialized = false;

  static const _speechDebounceMs = 1200;
  Timer? _speechDebounceTimer;

  Stream<AudioSessionEvent> get events => _events.stream;

  Future<void> initialize() async {
    if (_initialized) return;

    _recordStatusSub = _recorderEngine.onStatusChanged().listen((status) {
      _events.add(RecordingStatusChanged(status));
    });

    _realSpeechStartSub = _speechDetectorEngine.onRealSpeechStart.listen((_) {
      if (_suppressSpeechDetection) return;

      if (_speechDebounceTimer?.isActive == true) {
        _speechDebounceTimer!.cancel();
        _isSpeechActive = true;
        return;
      }

      _currentSpeechBuffer.clear();
      for (final chunk in _preBuffer) {
        _currentSpeechBuffer.addAll(chunk);
      }
      _isSpeechActive = true;
    });

    _speechStartSub = _speechDetectorEngine.onSpeechStart.listen((_) {});

    _speechEndSub = _speechDetectorEngine.onSpeechEnd.listen((_) {
      if (!_isSpeechActive || _suppressSpeechDetection) return;

      _speechDebounceTimer?.cancel();
      _speechDebounceTimer = Timer(
        const Duration(milliseconds: _speechDebounceMs),
        _flushSpeechBuffer,
      );
    });

    _initialized = true;
  }

  Future<void> start() async {
    final rawStream = await _recorderEngine.startStream();
    if (rawStream == null) return;

    final stream = rawStream.asBroadcastStream();
    await _speechDetectorEngine.startListening(stream);

    await _audioStreamSub?.cancel();
    _audioStreamSub = stream.listen(
      _handleAudioChunk,
      onError: (_) {},
      cancelOnError: true,
    );
  }

  Future<void> stop() async {
    await _audioStreamSub?.cancel();
    _audioStreamSub = null;
    await _recorderEngine.stop();
    await _speechDetectorEngine.stopListening();
    _resetCaptureState();
  }

  Future<void> pause() => _recorderEngine.pause();

  Future<void> resume() => _recorderEngine.resume();

  void setSpeechDetectionSuppressed(bool value) {
    _suppressSpeechDetection = value;
  }

  Future<void> dispose() async {
    _speechDebounceTimer?.cancel();
    await _recordStatusSub?.cancel();
    await _audioStreamSub?.cancel();
    await _speechStartSub?.cancel();
    await _realSpeechStartSub?.cancel();
    await _speechEndSub?.cancel();
    _speechDetectorEngine.dispose();
    _resetCaptureState();
    await _events.close();
  }

  void _handleAudioChunk(Uint8List data) {
    final level = _calculateLevel(data);
    if (level != null) {
      _events.add(AudioChunkCaptured(bytesLength: data.length, level: level));
    }

    if (_suppressSpeechDetection) return;

    _preBuffer.addLast(data);
    _preBufferBytes += data.length;
    while (_preBufferBytes > _preBufferMaxBytes) {
      _preBufferBytes -= _preBuffer.removeFirst().length;
    }

    if (_isSpeechActive) {
      _currentSpeechBuffer.addAll(data);
    }
  }

  void _flushSpeechBuffer() {
    _isSpeechActive = false;
    if (_currentSpeechBuffer.isEmpty) return;

    final bytes = Uint8List.fromList(List<int>.from(_currentSpeechBuffer));
    _currentSpeechBuffer.clear();
    _events.add(SpeechSegmentReady(bytes));
  }

  AudioLevel? _calculateLevel(Uint8List data) {
    if (data.isEmpty) return null;
    final sampleCount = data.length ~/ 2;
    if (sampleCount == 0) return null;

    double sumSquares = 0;
    for (var i = 0; i < data.length - 1; i += 2) {
      final lo = data[i];
      final hi = data[i + 1];
      var sample = (hi << 8) | lo;
      if (sample & 0x8000 != 0) {
        sample -= 0x10000;
      }
      final normalized = sample / 32768.0;
      sumSquares += normalized * normalized;
    }

    final rms = math.sqrt(sumSquares / sampleCount);
    if (!rms.isFinite) return null;

    return AudioLevel(current: rms, max: rms);
  }

  void _resetCaptureState() {
    _speechDebounceTimer?.cancel();
    _isSpeechActive = false;
    _currentSpeechBuffer.clear();
    _preBuffer.clear();
    _preBufferBytes = 0;
    _suppressSpeechDetection = false;
  }
}
