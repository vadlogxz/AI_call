import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
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
  static const int _playChunkSize = 512;

  late final AudioRecorder _audioRecorder;
  late final StartRecording _startRecording;
  late final StopRecording _stopRecording;
  late final FlutterSoundPlayer _player;
  late final VadHandler _vadHandler;

  bool _playerReady = false;
  bool _initialized = false;
  Timer? _timer;
  StreamSubscription<RecordState>? _recordSub;
  StreamSubscription<Amplitude>? _amplitudeSub;
  StreamSubscription<Uint8List>? _audioStreamSub;

  @override
  RecordingState build() {
    _audioRecorder = ref.watch(audioRecorderProvider);
    _startRecording = ref.watch(startRecordingProvider);
    _stopRecording = ref.watch(stopRecordingProvider);
    _vadHandler = ref.watch(vadHandlerProvider);

    state = const RecordingState();
    if (!_initialized) {
      _player = FlutterSoundPlayer();
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
      ref.onDispose(_disposeResources);
      _initialized = true;
    }
    return state;
  }

  Future<void> start() async {
    debugPrint('before start: recordState=${state.recordState}');
    try {
      if (!_playerReady) {
        await _player.openPlayer();
        _playerReady = true;
      }

      debugPrint('Player opened: isOpen=${_player.isOpen()}');

      const encoder = AudioEncoder.pcm16bits;
      _player.setVolume(state.volume);
      await _player.startPlayerFromStream(
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 16000,
        interleaved: true,
        bufferSize: _playChunkSize,
      );

      debugPrint('Player started with PCM 16-bit, 1 channel, 16kHz');
      final stream = await _startRecording(encoder);
      debugPrint('startRecording returned null? ${stream == null}');
      if (stream == null) {
        await _player.stopPlayer();
        return;
      }

      debugPrint('Recording started with encoder: ${encoder.name}');

      await _audioStreamSub?.cancel();
      state = state.copyWith(bytesSent: 0, recordDuration: Duration.zero);

      await _vadHandler.startListening(audioStream: stream);

      _audioStreamSub = stream.listen(
        (data) {
          debugPrint('Received audio chunk: ${data.length} bytes');
          debugPrint(
            'Current state before update: bytesSent=${state.bytesSent}, recordDuration=${state.recordDuration}',
          );
          debugPrint(
            'Amplitude: ${state.amplitude?.current.toStringAsFixed(2)} / ${state.amplitude?.max.toStringAsFixed(2)}',
          );
          state = state.copyWith(bytesSent: state.bytesSent + data.length);
          _feedToPlayer(data);
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
      await _player.stopPlayer();
    } catch (e, st) {
      debugPrint('Stop error: $e\n$st');
    }
  }

  Future<void> pause() => _audioRecorder.pause();

  Future<void> resume() => _audioRecorder.resume();

  void setVolume(double volume) {
    state = state.copyWith(volume: volume);
    if (_playerReady) {
      _player.setVolume(volume);
    }
  }

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

  void _feedToPlayer(Uint8List data) {
    final sink = _player.uint8ListSink;
    if (sink == null) return;

    var offset = 0;
    while (offset < data.length) {
      final end =
          (offset + _playChunkSize <= data.length)
              ? offset + _playChunkSize
              : data.length;
      sink.add(data.sublist(offset, end));
      offset = end;
    }
  }

  void _disposeResources() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioStreamSub?.cancel();
    _player.closePlayer();
    _vadHandler.dispose();
  }
}
