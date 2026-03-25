import 'dart:typed_data';

import 'package:elia/core/config/vad_config.dart';
import 'package:elia/feature/call/domain/engines/speech_detector_engine.dart';
import 'package:vad/vad.dart';

class VadSpeechDetectorEngine implements SpeechDetectorEngine {
  VadSpeechDetectorEngine({VadHandler? handler, VadConfig? config})
    : _handler = handler ?? VadHandler.create(),
      _config = config ?? VadConfig.getDefault();

  final VadHandler _handler;
  final VadConfig _config;

  @override
  Stream<void> get onSpeechStart => _handler.onSpeechStart;

  @override
  Stream<void> get onRealSpeechStart => _handler.onRealSpeechStart;

  @override
  Stream<void> get onSpeechEnd => _handler.onSpeechEnd;

  @override
  Future<void> startListening(Stream<Uint8List> audioStream) {
    return _handler.startListening(
      audioStream: audioStream,
      model: _config.model.name,
      frameSamples: _config.frameSamples,
      positiveSpeechThreshold: _config.positiveSpeechThreshold,
      negativeSpeechThreshold: _config.negativeSpeechThreshold,
      minSpeechFrames: _config.minSpeechFrames,
      preSpeechPadFrames: _config.preSpeechPadFrames,
      endSpeechPadFrames: _config.endSpeechPadFrames,
      redemptionFrames: _config.redemptionFrames,
      numFramesToEmit: _config.numFramesToEmit,
    );
  }

  @override
  Future<void> stopListening() => _handler.stopListening();

  @override
  void dispose() => _handler.dispose();
}
