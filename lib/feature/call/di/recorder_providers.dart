import 'package:elia/core/config/audio_config.dart';
import 'package:elia/core/network/client/api_client.dart';
import 'package:elia/feature/call/data/engines/record_audio_recorder_engine.dart';
import 'package:elia/feature/call/data/engines/vad_speech_detector_engine.dart';
import 'package:elia/feature/call/data/services/audio_playback_service.dart';
import 'package:elia/feature/call/data/services/conversation_api_service.dart';
import 'package:elia/feature/call/data/services/speech_api_service.dart';
import 'package:elia/feature/call/domain/audio/audio_session_coordinator.dart';
import 'package:elia/feature/call/domain/engines/audio_recorder_engine.dart';
import 'package:elia/feature/call/domain/engines/speech_detector_engine.dart';
import 'package:elia/feature/call/domain/usecases/process_conversation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

final recordPackageAudioRecorderProvider = Provider<AudioRecorder>((ref) {
  final recorder = AudioRecorder();
  ref.onDispose(recorder.dispose);
  return recorder;
});

final audioRecorderEngineProvider = Provider<AudioRecorderEngine>((ref) {
  return RecordAudioRecorderEngine(
    audioRecorder: ref.watch(recordPackageAudioRecorderProvider),
    config: recordConfig,
  );
});

final speechDetectorEngineProvider = Provider<SpeechDetectorEngine>((ref) {
  final engine = VadSpeechDetectorEngine();
  ref.onDispose(engine.dispose);
  return engine;
});

final audioSessionCoordinatorProvider = Provider<AudioSessionCoordinator>((
  ref,
) {
  final coordinator = AudioSessionCoordinator(
    recorderEngine: ref.watch(audioRecorderEngineProvider),
    speechDetectorEngine: ref.watch(speechDetectorEngineProvider),
  );
  ref.onDispose(coordinator.dispose);
  return coordinator;
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

final processConversationProvider = Provider<ProcessConversation>((ref) {
  return ProcessConversation(ref.watch(conversationApiServiceProvider));
});

final audioPlaybackServiceProvider = Provider<AudioPlaybackService>((ref) {
  final svc = AudioPlaybackService();
  ref.onDispose(svc.dispose);
  return svc;
});
