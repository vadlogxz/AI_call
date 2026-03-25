import 'dart:typed_data';

import 'package:elia/feature/call/domain/models/recording_status.dart';

abstract class AudioRecorderEngine {
  Stream<RecordingStatus> onStatusChanged();

  Future<Stream<Uint8List>?> startStream();

  Future<void> stop();

  Future<void> pause();

  Future<void> resume();
}
