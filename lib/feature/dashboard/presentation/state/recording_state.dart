

class RecordingState {
  final RecorderState recorderState;
  final Duration duration;
  final double decibel;

  RecordingState({
    this.recorderState = RecorderState.stopped,
    this.duration = Duration.zero,
    this.decibel = 0.0,
  });

  RecordingState copyWith({
    RecorderState? recorderState,
    Duration? duration,
    double? decibel,
  }) {
    return RecordingState(
      recorderState: recorderState ?? this.recorderState,
      duration: duration ?? this.duration,
      decibel: decibel ?? this.decibel,
    );
  }
}

enum RecorderState { stopped, recording, paused }