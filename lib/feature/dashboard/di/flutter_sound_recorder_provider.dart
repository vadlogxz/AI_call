import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';

final flutterSoundRecorderProvider = Provider<FlutterSoundRecorder>((ref) {
  final recorder = FlutterSoundRecorder();
  ref.onDispose(() {
    recorder.closeRecorder();
  });
  return recorder;
});