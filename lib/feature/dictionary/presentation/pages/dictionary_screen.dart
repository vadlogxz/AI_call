import 'package:elia/core/theme/app_colors.dart';
import 'package:elia/feature/dictionary/domain/models/vocabulary_word.dart';
import 'package:elia/feature/dictionary/presentation/state/vocabulary_notifier.dart';
import 'package:elia/feature/profile/presentation/state/settings_notifier.dart';
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

    final filtered =
        _query.isEmpty
            ? words
            : words
                .where(
                  (w) =>
                      w.word.toLowerCase().contains(_query) ||
                      w.translation.toLowerCase().contains(_query),
                )
                .toList();
    final dueCount = words.where((w) => w.status != WordStatus.mastered).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          'Vocabulary',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      if (streak > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
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
                  const SizedBox(height: 2),
                  Text(
                    '${words.length} word${words.length == 1 ? '' : 's'}'
                    '${dueCount > 0 ? ' · $dueCount to review' : ''}',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
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
                  ? _buildEmptyState(context)
                  : filtered.isEmpty
                  ? _buildNoResults(context)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => Dismissible(
                        key: ValueKey(filtered[i].id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDanger,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
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
            if (dueCount > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: GestureDetector(
                  onTap: () {/* TODO: quiz */},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderAccent),
                    ),
                    child: Text(
                      'Quick Quiz · $dueCount word${dueCount == 1 ? '' : 's'} to review',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryLight,
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.08),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Icon(
              Icons.menu_book_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No words yet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Words from conversations\nwill appear here',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(BuildContext context) {
    return Center(
      child: Text(
        'No results for "$_query"',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
    );
  }
}

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
              style: TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
            Text(
              '$levelEnd XP -> Lv.${level + 1}',
              style: TextStyle(color: AppColors.primary, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: AppColors.surfaceLight,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.search, color: AppColors.textMuted, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search words...',
                hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                filled: false,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _WordCard extends StatelessWidget {
  const _WordCard({required this.word, required this.onReview});

  final VocabularyWord word;
  final VoidCallback onReview;

  Color get _borderColor => switch (word.status) {
    WordStatus.mastered => const Color(0xFF3CB56A),
    WordStatus.learning => const Color(0xFF5B78D4),
    WordStatus.fresh => const Color(0xFFD46A20),
  };

  String get _statusLabel => switch (word.status) {
    WordStatus.mastered => 'mastered',
    WordStatus.learning => 'review soon',
    WordStatus.fresh => 'new',
  };

  Color get _statusColor => switch (word.status) {
    WordStatus.mastered => const Color(0xFF3CB56A),
    WordStatus.learning => const Color(0xFF8B78E4),
    WordStatus.fresh => const Color(0xFF5A6A9A),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            word.word,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
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
                    Text(
                      word.partOfSpeech.isNotEmpty
                          ? '${word.translation} · ${word.partOfSpeech}'
                          : word.translation,
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                    const SizedBox(height: 6),
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
                                    ? const Color(0xFF3CB56A)
                                    : const Color(0xFF5B78D4))
                                : AppColors.borderAccent,
                          ),
                        );
                      }),
                    ),
                    if (word.example.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        '"${word.example}"',
                        style: TextStyle(
                          color: AppColors.textMuted.withValues(alpha: 0.8),
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
