import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:elia/feature/dashboard/presentation/state/recording_notifier.dart';
import 'package:elia/feature/dashboard/presentation/state/recording_state.dart';

class Recorder extends ConsumerWidget {
  const Recorder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordingNotifierProvider);
    final notifier = ref.read(recordingNotifierProvider.notifier);
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
              _buildText(state),
            ],
          ),
          if (state.amplitude != null) ...[
            const SizedBox(height: 40),
            Text('Current: ${state.amplitude?.current ?? 0.0}'),
            Text('Max: ${state.amplitude?.max ?? 0.0}'),
          ],
          const SizedBox(height: 12),
          Text('Bytes: ${state.bytesSent}'),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ShadProgress(
              value: _calculateProgress(
                state.amplitude ?? Amplitude(current: -160, max: -160),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ShadSlider(
            initialValue: state.volume,
            onChanged: notifier.setVolume,
          ),
        ],
      ),
    );
  }

  double _calculateProgress(Amplitude amp) {
    const double minDb = -160;
    const double maxDb = 0;
    final double v = ((amp.current - minDb) / (maxDb - minDb)).clamp(0.0, 1.0);
    return v;
  }

  Widget _buildRecordStopControl(
    BuildContext context,
    RecordingState state,
    RecordingNotifier notifier,
  ) {
    late Icon icon;
    late Color color;

    if (state.recordState != RecordState.stop) {
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
            (state.recordState != RecordState.stop)
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
    if (state.recordState == RecordState.stop) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (state.recordState == RecordState.record) {
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
            (state.recordState == RecordState.pause)
                ? notifier.resume()
                : notifier.pause();
          },
        ),
      ),
    );
  }

  Widget _buildText(RecordingState state) {
    if (state.recordState != RecordState.stop) {
      return _buildTimer(state.recordDuration);
    }

    return const Text("Waiting to record");
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
