import 'package:elia/feature/call/presentation/state/recording_notifier.dart';
import 'package:elia/feature/call/presentation/state/recording_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({super.key});

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  @override
  Widget build(BuildContext context) {
    final RecordingState recordingState = ref.watch(recordingNotifierProvider);
    final RecordingNotifier recordingNotifier = ref.read(
      recordingNotifierProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Call Screen")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShadIconButton(
                width: 64,
                height: 64,
                icon: Icon(
                  Icons.mic_none,
                  size: 32,
                  color:
                      recordingState.recordState == RecordState.record
                          ? Colors.red
                          : Colors.blue,
                ),
                decoration: ShadDecoration(shape: BoxShape.circle),
                onLongPress: () {
                  recordingNotifier.start();
                },
                onLongPressUp: () {
                  recordingNotifier.stop();
                },
              ),
              const SizedBox(height: 20),
              Text('Current State: ${recordingState.recordState}'),
              const SizedBox(height: 20),
              Text(
                'Amplitude: ${recordingState.amplitude?.current.toStringAsFixed(2)} / ${recordingState.amplitude?.max.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 20),
              Text('Bytes Sent: ${recordingState.bytesSent}'),
              const SizedBox(height: 20),
              Text(
                'Record Duration: ${recordingState.recordDuration.inMinutes}:${(recordingState.recordDuration.inSeconds % 60).toString().padLeft(2, '0')}  ',
              ),
              SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );
  }
}
