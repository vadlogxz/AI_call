import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:record/record.dart';

class StartRecording {
  StartRecording({required AudioRecorder audioRecorder, required RecordConfig config})
    : _audioRecorder = audioRecorder,
      _recordConfig = config;

  final AudioRecorder _audioRecorder;
  final RecordConfig _recordConfig;

  Future<Stream<Uint8List>?> call() async {
  
    try {
      if (!await _hasMicrophonePermission()) {
        debugPrint('Microphone permission is required to start recording.');
        return null;
      }

      if (!await _isEncoderSupported(_recordConfig.encoder)) {
        debugPrint('Selected encoder is not supported. Cannot start recording.');
        return null;
      }

      final s = _audioRecorder.startStream(_recordConfig);
      debugPrint('AudioRecorder.startStream called, got stream=$s');
      return s;
    } catch (e) {
      debugPrint('Error starting recording: $e');
      return null;
    }
  }

  Future<bool> _hasMicrophonePermission() async {
    final perm = await _audioRecorder.hasPermission();
    if (!perm) {
      debugPrint('Microphone permission denied.');
    }
    return perm;
  }

  Future<bool> _isEncoderSupported(AudioEncoder encoder) async {
    final isSupported = await _audioRecorder.isEncoderSupported(encoder);

    if (!isSupported) {
      debugPrint('${encoder.name} is not supported on this platform.');
      debugPrint('Supported encoders are:');
      for (final e in AudioEncoder.values) {
        if (await _audioRecorder.isEncoderSupported(e)) {
          debugPrint('- ${e.name}');
        }
      }
    }

    return isSupported;
  }
}
