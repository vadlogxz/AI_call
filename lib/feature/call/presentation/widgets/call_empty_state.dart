import 'package:elia/core/presentation/widgets/elia_mascot.dart';
import 'package:elia/core/theme/elia_theme_extension.dart';
import 'package:elia/feature/call/domain/models/recording_status.dart';
import 'package:elia/feature/call/presentation/state/recording_state.dart';
import 'package:flutter/material.dart';

class CallEmptyState extends StatelessWidget {
  const CallEmptyState({super.key, required this.state});

  final RecordingState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.eliaColors;
    final phase = state.phase;
    final isRecording = state.recordingStatus == RecordingStatus.recording;

    final mascotState = switch (phase) {
      ConversationPhase.processing => MascotState.thinking,
      ConversationPhase.playing => MascotState.speaking,
      ConversationPhase.listening when isRecording => MascotState.speaking,
      _ => MascotState.idle,
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EliaMascot(
            state: mascotState,
            size: 110,
            showRings: isRecording || phase == ConversationPhase.playing,
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              key: ValueKey(phase),
              switch (phase) {
                ConversationPhase.processing => 'Thinking...',
                ConversationPhase.playing => 'Speaking...',
                ConversationPhase.listening when isRecording => 'Listening...',
                _ => 'Tap the mic to start',
              },
              style: TextStyle(
                color:
                    isRecording || phase != ConversationPhase.idle
                        ? colors.success
                        : colors.textMuted,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (phase == ConversationPhase.idle) ...[
            const SizedBox(height: 6),
            Text(
              'Your conversation will appear here',
              style: TextStyle(color: colors.textSecondary, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
