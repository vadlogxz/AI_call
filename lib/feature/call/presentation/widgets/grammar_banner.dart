import 'package:elia/core/theme/elia_theme_extension.dart';
import 'package:elia/feature/call/presentation/state/recording_notifier.dart';
import 'package:flutter/material.dart';

class GrammarBanner extends StatelessWidget {
  const GrammarBanner({
    super.key,
    required this.notifier,
    required this.corrected,
    this.original,
  });

  final String corrected;
  final String? original;
  final RecordingNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final colors = context.eliaColors;

    return Container(
      key: const ValueKey('grammar-banner'),
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceWarning.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.edit_note_rounded, color: colors.warning, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grammar note',
                  style: TextStyle(
                    color: colors.warning,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                if (original != null && original!.isNotEmpty)
                  Text(
                    'You said: "$original"',
                    style: TextStyle(color: colors.textMuted, fontSize: 12),
                  ),
                const SizedBox(height: 2),
                Text(
                  'Correction: $corrected',
                  style: TextStyle(
                    color: colors.warning,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: notifier.clearGrammarFeedback,
            child: Icon(Icons.close_rounded, color: colors.textMuted, size: 18),
          ),
        ],
      ),
    );
  }
}
