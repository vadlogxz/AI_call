import 'package:flutter/material.dart';
import 'package:record/record.dart';

class StopRecording {
  StopRecording({required AudioRecorder audioRecorder})
      : _audioRecorder = audioRecorder;

  final AudioRecorder _audioRecorder;

  Future<void> call() async {
    try {
      await _audioRecorder.stop();
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }
}