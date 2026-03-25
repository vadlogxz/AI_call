import 'dart:typed_data';

abstract class SpeechDetectorEngine {
  Stream<void> get onSpeechStart;

  Stream<void> get onRealSpeechStart;

  Stream<void> get onSpeechEnd;

  Future<void> startListening(Stream<Uint8List> audioStream);

  Future<void> stopListening();

  void dispose();
}
