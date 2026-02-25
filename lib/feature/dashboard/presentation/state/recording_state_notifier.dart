import 'dart:async';

import 'package:elia/feature/dashboard/presentation/state/recording_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final recordingNotifierProvider = AsyncNotifierProvider.family<RecordingNotifier, RecordingState, FlutterSoundRecorder>(
  RecordingNotifier.new,
);

class RecordingNotifier extends AsyncNotifier<RecordingState> {
    final FlutterSoundRecorder _recorder;
    StreamSubscription? _recorderSubscription;
    RecordingNotifier(this._recorder);


  @override
  Future<RecordingState> build() async {
    bool perm = await _handlePermission();
    if (!perm) {
      throw Exception('Microphone permission denied');
    }
    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));
    return RecordingState(recorderState: RecorderState.stopped, duration: Duration.zero, decibel: 0.0);
  }

Future<String> getFilePath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/audio.wav';
}

Future<void> start() async {
  if (!_recorder.isStopped && _recorder.isPaused) {
    // optional
  }

  final path = await getFilePath();

  await _recorder.startRecorder(
    toFile: path,
    codec: Codec.pcm16WAV,
    audioSource: AudioSource.microphone,

  );

  _recorderSubscription?.cancel();
  final progressStream = _recorder.onProgress;
  if (progressStream == null) {
    debugPrint('onProgress is null (subscriptionDuration not set?)');
  } else {
    _recorderSubscription = progressStream.listen((event) {
      debugPrint('Recording progress: ${event.duration}, decibels: ${event.decibels}');
      final decibel = event.decibels ?? 0.0;
      state = AsyncData(state.value!.copyWith(duration: event.duration, decibel: decibel));
    });
  }

  _updateRecorderState(_recorder);
}

  Future<void> stop() async {
  final path = await _recorder.stopRecorder();
  debugPrint('File saved at: $path');
      _recorderSubscription?.cancel();

    _updateRecorderState(_recorder);
  }

  Future<void> pause() async {
    await _recorder.pauseRecorder();
    _updateRecorderState(_recorder);
  }

  Future<void> resume() async {
    await _recorder.resumeRecorder();
    _updateRecorderState(_recorder);
  }

  Future<bool> _handlePermission() async {
    if (await Permission.microphone.request().isGranted) {
      return true;
    }
    return false;
  }

  void _updateRecorderState(FlutterSoundRecorder recorder){
    if (recorder.isRecording) {
      state = AsyncData(state.value!.copyWith(recorderState: RecorderState.recording));
    } else if (recorder.isPaused) {
      state = AsyncData(state.value!.copyWith(recorderState: RecorderState.paused));
    } else {
      state = AsyncData(state.value!.copyWith(recorderState: RecorderState.stopped));
    }
  }
}
