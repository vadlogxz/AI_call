import 'package:record/record.dart';

class RecordingState {
  const RecordingState({
    this.recordState = RecordState.stop,
    this.recordDuration = Duration.zero,
    this.bytesSent = 0,
    this.amplitude,
    this.volume = 0.5,
  });

  final RecordState recordState;
  final Duration recordDuration;
  final int bytesSent;
  final Amplitude? amplitude;
  final double volume;

  RecordingState copyWith({
    RecordState? recordState,
    Duration? recordDuration,
    int? bytesSent,
    Amplitude? amplitude,
    double? volume,
  }) {
    return RecordingState(
      recordState: recordState ?? this.recordState,
      recordDuration: recordDuration ?? this.recordDuration,
      bytesSent: bytesSent ?? this.bytesSent,
      amplitude: amplitude ?? this.amplitude,
      volume: volume ?? this.volume,
    );
  }
}