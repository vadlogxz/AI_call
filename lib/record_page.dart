import 'package:elia/feature/dashboard/di/flutter_sound_recorder_provider.dart';
import 'package:elia/feature/dashboard/presentation/state/recording_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'feature/dashboard/presentation/state/recording_state.dart';


class Recorder extends ConsumerWidget {
  const Recorder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorder = ref.read(flutterSoundRecorderProvider);
    final state = ref.watch(recordingNotifierProvider(recorder)).value;
    final notifier = ref.read(recordingNotifierProvider(recorder).notifier);

    if (state == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildRecordStopControl(context, state, notifier),
              const SizedBox(width: 20),
              _buildPauseResumeControl(context, state, notifier),
              const SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ShadProgress(
              value: state.decibel / 120,
            ),
          ),
          SizedBox(height: 20,),
          _buildTimer(state.duration.inSeconds),
        ],
      ),
    );
  }

  Widget _buildRecordStopControl(
    BuildContext context,
    RecordingState state,
    RecordingNotifier notifier,
  ) {
    late Icon icon;
    late Color color;

    if (state.recorderState != RecorderState.stopped) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withValues(alpha: 0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withValues(alpha: 0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: ShadIconButton(
          icon: icon,
          onPressed: () {
            (state.recorderState != RecorderState.stopped)
                ? notifier.stop()
                : notifier.start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl(
    BuildContext context,
    RecordingState state,
    RecordingNotifier notifier,
  ) {
    if (state.recorderState == RecorderState.stopped) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (state.recorderState == RecorderState.recording) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withValues(alpha: 0.1);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
      color = theme.primaryColor.withValues(alpha: 0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: ShadIconButton(
          icon: icon,
          onPressed: () {
            (state.recorderState == RecorderState.paused)
                ? notifier.resume()
                : notifier.pause();
          },
        ),
      ),
    );
  }

  Widget _buildTimer(int recordDuration) {
    final String minutes = _formatNumber(recordDuration ~/ 60);
    final String seconds = _formatNumber(recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }
}
