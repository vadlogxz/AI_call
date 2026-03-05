import 'dart:async';

import 'package:elia/core/config/vad_config.dart';
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

  bool _initialized = false;
  Timer? _timer;
  StreamSubscription<RecordState>? _recordSub;
  StreamSubscription<Amplitude>? _amplitudeSub;
  StreamSubscription<Uint8List>? _audioStreamSub;

  StreamSubscription? _realStartSub;
  StreamSubscription? _speechStartSub;
  StreamSubscription? _speechEndSub;

  final VadConfig _vadConfig = VadConfig.getDefault();

  @override
  RecordingState build() {
    _audioRecorder = ref.watch(audioRecorderProvider);
    _startRecording = ref.watch(startRecordingProvider);
    _stopRecording = ref.watch(stopRecordingProvider);
    _vadHandler = VadHandler.create();

    if (!_initialized) {
      state = const RecordingState();
      _recordSub = _audioRecorder.onStateChanged().listen(_handleRecordState);
      _amplitudeSub = _audioRecorder
          .onAmplitudeChanged(const Duration(milliseconds: 300))
          .listen((amp) {
            if (amp.current.isFinite && amp.max.isFinite) {
              state = state.copyWith(amplitude: amp);
            } else {
              debugPrint(
                'Amplitude is not finite: current=${amp.current}, max=${amp.max}',
              );
            }
          });

      _realStartSub = _vadHandler.onRealSpeechStart.listen((_) {
        debugPrint('✅ REAL SPEECH START');
      });

      _speechStartSub = _vadHandler.onSpeechStart.listen((_) {
        debugPrint('🟡 SPEECH START (may include noise)');
      });

      _speechEndSub = _vadHandler.onSpeechEnd.listen((_) {
        debugPrint('🛑 SPEECH END');
      });

      ref.onDispose(_disposeResources);
      _initialized = true;
    }
    return state;
  }

  Future<void> start() async {
    debugPrint('before start: recordState=${state.recordState}');
    try {
      final stream = await _startRecording();
      debugPrint('startRecording returned null? ${stream == null}');
      if (stream == null) {
        return;
      }

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
    _amplitudeSub?.cancel();
    _audioStreamSub?.cancel();
    _realStartSub?.cancel();
    _speechStartSub?.cancel();
    _speechEndSub?.cancel();
    _vadHandler.dispose();
  }
}
