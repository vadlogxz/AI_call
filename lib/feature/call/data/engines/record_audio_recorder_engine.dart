import 'package:elia/feature/call/domain/engines/audio_recorder_engine.dart';
import 'package:elia/feature/call/domain/models/recording_status.dart';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

class RecordAudioRecorderEngine implements AudioRecorderEngine {
  RecordAudioRecorderEngine({
    required AudioRecorder audioRecorder,
    required RecordConfig config,
  }) : _audioRecorder = audioRecorder,
       _config = config;

  final AudioRecorder _audioRecorder;
  final RecordConfig _config;

  @override
  Stream<RecordingStatus> onStatusChanged() {
    return _audioRecorder.onStateChanged().map(_mapStatus);
  }

  @override
  Future<Stream<Uint8List>?> startStream() async {
    try {
      if (!await _audioRecorder.hasPermission()) {
        debugPrint('Microphone permission is required to start recording.');
        return null;
      }

      if (!await _audioRecorder.isEncoderSupported(_config.encoder)) {
        debugPrint(
          'Selected encoder is not supported. Cannot start recording.',
        );
        return null;
      }

      return _audioRecorder.startStream(_config);
    } catch (e) {
      debugPrint('Error starting recording: $e');
      return null;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _audioRecorder.stop();
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  @override
  Future<void> pause() => _audioRecorder.pause();

  @override
  Future<void> resume() => _audioRecorder.resume();

  RecordingStatus _mapStatus(RecordState state) {
    return switch (state) {
      RecordState.record => RecordingStatus.recording,
      RecordState.pause => RecordingStatus.paused,
      RecordState.stop => RecordingStatus.stopped,
    };
  }
}
