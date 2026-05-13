import 'package:elia/core/theme/app_colors.dart';
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
      ConversationPhase.processing => ('thinking', AppColors.primary),
      ConversationPhase.playing => ('speaking', AppColors.success),
      ConversationPhase.listening when isRecording => ('live', AppColors.success),
      _ => ('idle', AppColors.textMuted),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Text(
            'Elia',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.surface,
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
                color: AppColors.streakBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.streakBorder),
              ),
              child: Text(
                'Streak $streak',
                style: TextStyle(
                  color: AppColors.warning,
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
