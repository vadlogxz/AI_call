import 'package:elia/feature/call/presentation/state/recording_notifier.dart';
import 'package:flutter/material.dart';

class GrammarBanner extends StatelessWidget {
  const GrammarBanner({super.key, required this.notifier, required this.corrected, this.original});

  final String corrected;
  final String? original;
  final RecordingNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('grammar-banner'),
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF451A03).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.edit_note_rounded,
            color: Color(0xFFF59E0B),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Grammar note',
                  style: TextStyle(
                    color: Color(0xFFF59E0B),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                if (original != null && original!.isNotEmpty)
                  Text(
                    'You said: "$original"',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  '→ $corrected',
                  style: const TextStyle(
                    color: Color(0xFFFBBF24),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: notifier.clearGrammarFeedback,
            child: const Icon(
              Icons.close_rounded,
              color: Color(0xFF64748B),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
