import 'package:elia/core/config/audio_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

import '../domain/usecases/start_recording.dart';
import '../domain/usecases/stop_recording.dart';

final audioRecorderProvider = Provider<AudioRecorder>((ref) {
  final recorder = AudioRecorder();
  ref.onDispose(recorder.dispose);
  return recorder;
});

final startRecordingProvider = Provider<StartRecording>((ref) {
  
  return StartRecording(audioRecorder: ref.watch(audioRecorderProvider), config: recordConfig);
});

final stopRecordingProvider = Provider<StopRecording>((ref) {
  return StopRecording(audioRecorder: ref.watch(audioRecorderProvider));
});

