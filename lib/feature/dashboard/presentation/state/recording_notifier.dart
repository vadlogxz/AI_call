import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

import '../../di/recorder_providers.dart';
import '../../domain/usecases/start_recording.dart';
import '../../domain/usecases/stop_recording.dart';
import 'recording_state.dart';

final recordingNotifierProvider =
    NotifierProvider<RecordingNotifier, RecordingState>(RecordingNotifier.new);

class RecordingNotifier extends Notifier<RecordingState> {
  static const int _playChunkSize = 512;
  static const double _gain = 1.0;

  late final AudioRecorder _audioRecorder;
  late final StartRecording _startRecording;
  late final StopRecording _stopRecording;
  late final FlutterSoundPlayer _player;

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
              // Auto-restart recording if amplitude is not finite
              _restartRecordingOnAmplitudeError();
            }
          });
      ref.onDispose(_disposeResources);
      _initialized = true;
      return const RecordingState();
    }
    return state;
  }

  void _restartRecordingOnAmplitudeError() async {
    debugPrint('Restarting recording due to amplitude error...');
    await stop();
    await Future.delayed(const Duration(milliseconds: 500));
    await start();
  }

  Future<void> start() async {
    try {
      if (!_playerReady) {
        await _player.openPlayer();
        _playerReady = true;
      }

      const encoder = AudioEncoder.pcm16bits;
      _player.setVolume(state.volume);
      await _player.startPlayerFromStream(
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 16000,
        interleaved: true,
        bufferSize: _playChunkSize,
      );

      final stream = await _startRecording(encoder);
      if (stream == null) {
        await _player.stopPlayer();
        return;
      }

      await _audioStreamSub?.cancel();
      state = state.copyWith(bytesSent: 0, recordDuration: 0);
      _audioStreamSub = stream.listen(
        (data) {
          state = state.copyWith(bytesSent: state.bytesSent + data.length);
          final boosted = _applyGainPcm16(data, _gain);
          _feedToPlayer(boosted);
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
        state = state.copyWith(recordDuration: 0);
        break;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      state = state.copyWith(recordDuration: state.recordDuration + 1);
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

  Uint8List _applyGainPcm16(Uint8List bytes, double gain) {
    final out = Uint8List(bytes.length);
    for (int i = 0; i + 1 < bytes.length; i += 2) {
      final lo = bytes[i];
      final hi = bytes[i + 1];
      int v = (hi << 8) | lo;
      if (v & 0x8000 != 0) v -= 0x10000;

      int boosted = (v * gain).round();
      if (boosted > 32767) boosted = 32767;
      if (boosted < -32768) boosted = -32768;

      out[i] = boosted & 0xFF;
      out[i + 1] = (boosted >> 8) & 0xFF;
    }
    return out;
  }

  void _disposeResources() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioStreamSub?.cancel();
    _player.closePlayer();
  }
}
