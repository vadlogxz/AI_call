import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:record/record.dart';

class StartRecording {
  StartRecording({required AudioRecorder audioRecorder})
      : _audioRecorder = audioRecorder;

  final AudioRecorder _audioRecorder;

  Future<Stream<Uint8List>?> call(AudioEncoder encoder) async {
    try {
      if (!await _hasMicrophonePermission()) {
        return null;
      }

      if (!await _isEncoderSupported(encoder)) {
        return null;
      }

      final config = _buildConfig(encoder);
      return _audioRecorder.startStream(config);
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


  RecordConfig _buildConfig(AudioEncoder encoder) {
    return RecordConfig(
      encoder: encoder,
      numChannels: 1,
      sampleRate: 16000,
      autoGain: true,
      noiseSuppress: true,
      echoCancel: true,
      androidConfig: const AndroidRecordConfig(
        audioSource: AndroidAudioSource.voiceCommunication,
      ),
    );
  }
}
