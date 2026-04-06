import 'package:elia/core/presentation/widgets/elia_mascot.dart';
import 'package:elia/core/theme/elia_theme_extension.dart';
import 'package:flutter/material.dart';

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
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (_) => SessionSummarySheet(
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
    final colors = context.eliaColors;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder:
          (context, scroll) => ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colors.borderAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
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
                      style: TextStyle(
                        color: colors.success,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '+${newWords.length * 10 + messageCount * 5} XP earned',
                      style: TextStyle(color: colors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                  _StatCard(value: '$_fluencyPercent%', label: 'fluency score'),
                  _StatCard(
                    value: 'Streak $streak',
                    label: 'day streak',
                    accent: true,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (newWords.isNotEmpty) ...[
                const _SectionTitle('words from this session'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: newWords.map((w) => _WordPill(word: w)).toList(),
                ),
                const SizedBox(height: 20),
              ],
              const _SectionTitle('skills'),
              const SizedBox(height: 8),
              _SkillBar(
                label: 'Fluency',
                percent: _fluencyPercent / 100,
                color: colors.accentPrimary,
              ),
              const SizedBox(height: 6),
              _SkillBar(
                label: 'Vocabulary',
                percent: (newWords.length * 0.2).clamp(0, 1),
                color: colors.success,
              ),
              const SizedBox(height: 6),
              _SkillBar(
                label: 'Grammar',
                percent:
                    grammarCorrections == 0
                        ? 1.0
                        : (1.0 - grammarCorrections * 0.15).clamp(0.2, 1.0),
                color: colors.warning,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  onContinue();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: colors.accentPrimary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Continue learning',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.textOnAccent,
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
    final colors = context.eliaColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.borderPrimary),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: accent ? colors.accentPrimary : colors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: colors.textMuted, fontSize: 9)),
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
    final colors = context.eliaColors;

    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: colors.textMuted,
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
    final colors = context.eliaColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderPrimary),
      ),
      child: Text(
        word,
        style: TextStyle(color: colors.accentSecondary, fontSize: 12),
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
    final colors = context.eliaColors;
    final pct = percent.clamp(0.0, 1.0);

    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: TextStyle(color: colors.textMuted, fontSize: 11),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: colors.surfaceTertiary,
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
