import 'dart:typed_data';

import 'package:elia/feature/call/domain/models/audio_level.dart';
import 'package:elia/feature/call/domain/models/recording_status.dart';

sealed class AudioSessionEvent {
  const AudioSessionEvent();
}

class RecordingStatusChanged extends AudioSessionEvent {
  const RecordingStatusChanged(this.status);

  final RecordingStatus status;
}

class AudioChunkCaptured extends AudioSessionEvent {
  const AudioChunkCaptured({required this.bytesLength, required this.level});

  final int bytesLength;
  final AudioLevel level;
}

class SpeechSegmentReady extends AudioSessionEvent {
  const SpeechSegmentReady(this.bytes);

  final Uint8List bytes;
}
