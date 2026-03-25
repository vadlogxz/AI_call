import 'package:elia/feature/dictionary/domain/models/vocabulary_word.dart';
import 'package:elia/feature/dictionary/presentation/state/vocabulary_notifier.dart';
import 'package:elia/feature/settings/presentation/state/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DictionaryScreen extends ConsumerStatefulWidget {
  const DictionaryScreen({super.key});

  @override
  ConsumerState<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends ConsumerState<DictionaryScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () => setState(() => _query = _searchController.text.toLowerCase()),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = ref.watch(vocabularyProvider);
    final streak = ref.watch(settingsProvider).streak;
    final filtered = _query.isEmpty
        ? words
        : words
            .where(
              (w) =>
                  w.word.toLowerCase().contains(_query) ||
                  w.translation.toLowerCase().contains(_query),
            )
            .toList();

    final dueCount =
        words.where((w) => w.status != WordStatus.mastered).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0a0d14),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vocabulary',
                              style: TextStyle(
                                color: Color(0xFFe8eaf5),
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (streak > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1a1200),
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: const Color(0xFF3a2800)),
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
                  const SizedBox(height: 2),
                  Text(
                    '${words.length} word${words.length == 1 ? '' : 's'}'
                    '${dueCount > 0 ? ' · $dueCount to review' : ''}',
                    style: const TextStyle(
                      color: Color(0xFF4a5680),
                      fontSize: 11,
                    ),
                  ),

                  // XP progress bar
                  if (words.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _XpBar(wordCount: words.length),
                  ],

                  const SizedBox(height: 12),
                  _SearchBar(controller: _searchController),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: words.isEmpty
                  ? _buildEmptyState()
                  : filtered.isEmpty
                      ? _buildNoResults()
                      : ListView.separated(
                          padding:
                              const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, i) => Dismissible(
                            key: ValueKey(filtered[i].id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7F1D1D),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Color(0xFFEF4444),
                                size: 20,
                              ),
                            ),
                            onDismissed: (_) {
                              ref
                                  .read(vocabularyProvider.notifier)
                                  .removeWord(filtered[i].id);
                            },
                            child: _WordCard(
                              word: filtered[i],
                              onReview: () => ref
                                  .read(vocabularyProvider.notifier)
                                  .incrementReviewLevel(filtered[i].id),
                            ),
                          ),
                        ),
            ),

            // Quick quiz CTA
            if (dueCount > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: GestureDetector(
                  onTap: () {/* TODO: quiz */},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2a3a6a)),
                    ),
                    child: Text(
                      '⚡ Quick Quiz · $dueCount word${dueCount == 1 ? '' : 's'} to review',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF8aaaf5),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF5b78d4).withValues(alpha: 0.08),
              border: Border.all(
                color: const Color(0xFF5b78d4).withValues(alpha: 0.15),
              ),
            ),
            child: const Icon(
              Icons.menu_book_outlined,
              color: Color(0xFF5b78d4),
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No words yet',
            style: TextStyle(
              color: Color(0xFFe8eaf5),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Words from conversations\nwill appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF4a5680),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Text(
        'No results for "$_query"',
        style: const TextStyle(color: Color(0xFF2e3858), fontSize: 14),
      ),
    );
  }
}

// ── XP bar ───────────────────────────────────────────────────────────────────

class _XpBar extends StatelessWidget {
  const _XpBar({required this.wordCount});
  final int wordCount;

  static int _xp(int words) => words * 20;
  static int _level(int xp) => (xp ~/ 160) + 1;
  static int _xpForLevel(int level) => (level - 1) * 160;
  static int _xpForNextLevel(int level) => level * 160;

  @override
  Widget build(BuildContext context) {
    final xp = _xp(wordCount);
    final level = _level(xp);
    final levelStart = _xpForLevel(level);
    final levelEnd = _xpForNextLevel(level);
    final progress = (xp - levelStart) / (levelEnd - levelStart);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level $level · $xp XP',
              style: const TextStyle(color: Color(0xFF4a5680), fontSize: 10),
            ),
            Text(
              '$levelEnd XP → Lv.${level + 1}',
              style: const TextStyle(color: Color(0xFF5b78d4), fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: const Color(0xFF141928),
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFF5b78d4)),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1e2535)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Color(0xFF3a4a70), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              style:
                  const TextStyle(color: Color(0xFFe8eaf5), fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Search words...',
                hintStyle: TextStyle(color: Color(0xFF2a3560), fontSize: 13),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

// ── Word card ─────────────────────────────────────────────────────────────────

class _WordCard extends StatelessWidget {
  const _WordCard({required this.word, required this.onReview});
  final VocabularyWord word;
  final VoidCallback onReview;

  Color get _borderColor => switch (word.status) {
        WordStatus.mastered => const Color(0xFF3cb56a),
        WordStatus.learning => const Color(0xFF5b78d4),
        WordStatus.fresh => const Color(0xFFd46a20),
      };

  String get _statusLabel => switch (word.status) {
        WordStatus.mastered => '✓ mastered',
        WordStatus.learning => '↻ review soon',
        WordStatus.fresh => 'new',
      };

  Color get _statusColor => switch (word.status) {
        WordStatus.mastered => const Color(0xFF3cb56a),
        WordStatus.learning => const Color(0xFF8b78e4),
        WordStatus.fresh => const Color(0xFF5a6a9a),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0e1422),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1a2240)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Status stripe
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: _borderColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Word + badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            word.word,
                            style: const TextStyle(
                              color: Color(0xFFc8d0e8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF141928),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _statusColor.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            _statusLabel,
                            style: TextStyle(
                              color: _statusColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    // Translation + part of speech
                    Text(
                      word.partOfSpeech.isNotEmpty
                          ? '${word.translation} · ${word.partOfSpeech}'
                          : word.translation,
                      style: const TextStyle(
                        color: Color(0xFF4a5680),
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // SRS dots
                    Row(
                      children: List.generate(5, (i) {
                        final filled = i < word.reviewLevel;
                        return Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: filled
                                ? (word.status == WordStatus.mastered
                                    ? const Color(0xFF3cb56a)
                                    : const Color(0xFF5b78d4))
                                : const Color(0xFF1e2a50),
                          ),
                        );
                      }),
                    ),

                    // Example sentence
                    if (word.example.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        '"${word.example}"',
                        style: const TextStyle(
                          color: Color(0xFF3a4560),
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Review tap area (for non-mastered words)
            if (word.status != WordStatus.mastered)
              GestureDetector(
                onTap: onReview,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 36,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: _borderColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
