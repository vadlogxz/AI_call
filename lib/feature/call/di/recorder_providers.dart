import 'package:elia/core/config/audio_config.dart';
import 'package:elia/core/network/client/api_client.dart';
import 'package:elia/feature/call/data/services/audio_playback_service.dart';
import 'package:elia/feature/call/data/services/conversation_api_service.dart';
import 'package:elia/feature/call/data/services/speech_api_service.dart';
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

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final speechApiServiceProvider = Provider<SpeechApiService>((ref) {
  return SpeechApiService(ref.watch(apiClientProvider));
});

final conversationApiServiceProvider = Provider<ConversationApiService>((ref) {
  return ConversationApiService(ref.watch(apiClientProvider));
});

final audioPlaybackServiceProvider = Provider<AudioPlaybackService>((ref) {
  final svc = AudioPlaybackService();
  ref.onDispose(svc.dispose);
  return svc;
});
