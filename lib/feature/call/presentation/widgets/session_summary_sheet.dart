import 'package:elia/core/presentation/widgets/elia_mascot.dart';
import 'package:flutter/material.dart';

/// Bottom sheet shown after a conversation session ends.
class SessionSummarySheet extends StatelessWidget {
  const SessionSummarySheet({
    super.key,
    required this.duration,
    required this.newWords,
    required this.grammarCorrections,
    required this.messageCount,
    required this.streak,
    required this.onContinue,
  });

  final Duration duration;
  final List<String> newWords;
  final int grammarCorrections;
  final int messageCount;
  final int streak;
  final VoidCallback onContinue;

  static Future<void> show({
    required BuildContext context,
    required Duration duration,
    required List<String> newWords,
    required int grammarCorrections,
    required int messageCount,
    required int streak,
    required VoidCallback onContinue,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0c1020),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SessionSummarySheet(
        duration: duration,
        newWords: newWords,
        grammarCorrections: grammarCorrections,
        messageCount: messageCount,
        streak: streak,
        onContinue: onContinue,
      ),
    );
  }

  String get _durationLabel {
    final m = duration.inMinutes.toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  int get _fluencyPercent {
    if (messageCount == 0) return 0;
    final userMessages = (messageCount / 2).ceil();
    if (userMessages == 0) return 100;
    final errors = grammarCorrections.clamp(0, userMessages);
    return ((1.0 - errors / userMessages) * 100).round().clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (context, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF2a3050),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Mascot + headline
          Center(
            child: Column(
              children: [
                EliaMascot(
                  state: MascotState.speaking,
                  size: 72,
                  showRings: false,
                ),
                const SizedBox(height: 6),
                Text(
                  _fluencyPercent >= 80
                      ? 'Great session!'
                      : _fluencyPercent >= 50
                          ? 'Good effort!'
                          : 'Keep practising!',
                  style: const TextStyle(
                    color: Color(0xFF5bd47b),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '+${newWords.length * 10 + messageCount * 5} XP earned',
                  style: const TextStyle(
                    color: Color(0xFF4a5680),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.2,
            children: [
              _StatCard(value: _durationLabel, label: 'duration'),
              _StatCard(
                value: '${newWords.length}',
                label: 'new words',
                accent: true,
              ),
              _StatCard(
                value: '$_fluencyPercent%',
                label: 'fluency score',
              ),
              _StatCard(
                value: '🔥 $streak',
                label: 'day streak',
                accent: true,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Words from session
          if (newWords.isNotEmpty) ...[
            const _SectionTitle('words from this session'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: newWords
                  .map((w) => _WordPill(word: w))
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Skills
          const _SectionTitle('skills'),
          const SizedBox(height: 8),
          _SkillBar(
            label: 'Fluency',
            percent: _fluencyPercent / 100,
            color: const Color(0xFF5b78d4),
          ),
          const SizedBox(height: 6),
          _SkillBar(
            label: 'Vocabulary',
            percent: (newWords.length * 0.2).clamp(0, 1),
            color: const Color(0xFF3cb56a),
          ),
          const SizedBox(height: 6),
          _SkillBar(
            label: 'Grammar',
            percent: grammarCorrections == 0
                ? 1.0
                : (1.0 - grammarCorrections * 0.15).clamp(0.2, 1.0),
            color: const Color(0xFFd4a020),
          ),

          const SizedBox(height: 24),

          // Continue button
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              onContinue();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFF5b78d4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Continue learning →',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    this.accent = false,
  });
  final String value;
  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0e1422),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1a2240)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: accent ? const Color(0xFF5b78d4) : const Color(0xFFe8eaf5),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF4a5680), fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF4a5680),
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _WordPill extends StatelessWidget {
  const _WordPill({required this.word});
  final String word;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1e2a4a)),
      ),
      child: Text(
        word,
        style: const TextStyle(color: Color(0xFF8aaaf5), fontSize: 12),
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  const _SkillBar({
    required this.label,
    required this.percent,
    required this.color,
  });
  final String label;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final pct = percent.clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF4a5680), fontSize: 11),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: const Color(0xFF141928),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 30,
          child: Text(
            '${(pct * 100).round()}%',
            style: TextStyle(color: color, fontSize: 10),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
