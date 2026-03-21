import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';

class AudioPlaybackService {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    await _player.openPlayer();
    _isInitialized = true;
  }

  Future<void> playBase64Wav(String base64Audio) async {
    if (base64Audio.isEmpty) return;
    await init();
    final raw = base64Decode(base64Audio);
    final bytes = _fixWavHeader(raw);
    await _playAndWait(bytes);
  }

  Future<void> playBytes(Uint8List bytes) async {
    await init();
    final fixed = _fixWavHeader(bytes);
    await _playAndWait(fixed);
  }

  Future<void> _playAndWait(Uint8List bytes) async {
    final completer = Completer<void>();
    await _player.startPlayer(
      fromDataBuffer: bytes,
      codec: Codec.pcm16WAV,
      whenFinished: () {
        if (!completer.isCompleted) completer.complete();
      },
    );
    await completer.future;
  }

  /// Patches RIFF WAV streaming headers where size fields are -1 (0xFFFFFFFF).
  /// Android MediaPlayer requires valid size fields.
  Uint8List _fixWavHeader(Uint8List bytes) {
    if (bytes.length < 44) { return bytes; }
    // Verify RIFF signature
    if (bytes[0] != 0x52 ||
        bytes[1] != 0x49 ||
        bytes[2] != 0x46 ||
        bytes[3] != 0x46) { return bytes; }

    final out = Uint8List.fromList(bytes);

    // Fix RIFF chunk size: total file size - 8
    final riffSize = bytes.length - 8;
    out[4] = riffSize & 0xFF;
    out[5] = (riffSize >> 8) & 0xFF;
    out[6] = (riffSize >> 16) & 0xFF;
    out[7] = (riffSize >> 24) & 0xFF;

    // Find 'data' chunk (usually at offset 36 for standard PCM WAV)
    for (var i = 12; i < bytes.length - 8; i++) {
      if (bytes[i] == 0x64 &&
          bytes[i + 1] == 0x61 &&
          bytes[i + 2] == 0x74 &&
          bytes[i + 3] == 0x61) {
        final dataSize = bytes.length - (i + 8);
        out[i + 4] = dataSize & 0xFF;
        out[i + 5] = (dataSize >> 8) & 0xFF;
        out[i + 6] = (dataSize >> 16) & 0xFF;
        out[i + 7] = (dataSize >> 24) & 0xFF;
        break;
      }
    }

    return out;
  }

  Future<void> stop() async {
    if (_player.isPlaying) {
      await _player.stopPlayer();
    }
  }

  Future<void> dispose() async {
    await stop();
    if (_isInitialized) {
      await _player.closePlayer();
      _isInitialized = false;
    }
  }
}
