import 'package:elia/feature/agents/presentation/state/agent_config.dart';
import 'package:elia/feature/call/domain/models/recording_status.dart';
import 'package:elia/feature/call/presentation/state/recording_state.dart';
import 'package:flutter/material.dart';

class CallHeader extends StatelessWidget {
  const CallHeader({
    super.key,
    required this.state,
    required this.selectedAgent,
    required this.streak,
  });

  final RecordingState state;
  final BotAgent? selectedAgent;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final phase = state.phase;
    final isRecording = state.recordingStatus == RecordingStatus.recording;

    final (statusLabel, statusColor) = switch (phase) {
      ConversationPhase.processing => ('thinking', const Color(0xFF5b78d4)),
      ConversationPhase.playing => ('speaking', const Color(0xFF5bd47b)),
      ConversationPhase.listening when isRecording => (
        'live',
        const Color(0xFF5bd47b),
      ),
      _ => ('idle', const Color(0xFF4a5680)),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const Text(
            'Elia',
            style: TextStyle(
              color: Color(0xFFe8eaf5),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF12192b),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (streak > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1200),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF3a2800)),
              ),
              child: Text(
                '🔥 $streak',
                style: const TextStyle(
                  color: Color(0xFFe8a030),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
