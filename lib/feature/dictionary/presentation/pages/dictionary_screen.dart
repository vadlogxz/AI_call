import 'package:elia/feature/dictionary/domain/models/vocabulary_word.dart';
import 'package:elia/feature/dictionary/presentation/state/vocabulary_notifier.dart';
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
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = ref.watch(vocabularyProvider);
    final filtered = _query.isEmpty
        ? words
        : words
            .where(
              (w) =>
                  w.word.toLowerCase().contains(_query) ||
                  w.translation.toLowerCase().contains(_query),
            )
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dictionary',
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Words learned during sessions',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  _SearchBar(controller: _searchController),
                  const SizedBox(height: 8),
                  Text(
                    '${filtered.length} word${filtered.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                        color: Color(0xFF475569), fontSize: 12),
                  ),
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
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
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
                              child: const Icon(Icons.delete_outline,
                                  color: Color(0xFFEF4444), size: 22),
                            ),
                            onDismissed: (_) {
                              ref
                                  .read(vocabularyProvider.notifier)
                                  .removeWord(filtered[i].id);
                            },
                            child: _WordCard(word: filtered[i]),
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
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6366F1).withValues(alpha: 0.08),
              border: Border.all(
                color: const Color(0xFF6366F1).withValues(alpha: 0.15),
              ),
            ),
            child: const Icon(
              Icons.book_outlined,
              color: Color(0xFF6366F1),
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No words yet',
            style: TextStyle(
              color: Color(0xFFF1F5F9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Words from conversations\nwill appear here',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Text(
        'No results for "$_query"',
        style: const TextStyle(color: Color(0xFF334155), fontSize: 14),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Color(0xFF475569), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Color(0xFFF8FAFC), fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search words...',
                hintStyle: TextStyle(color: Color(0xFF475569)),
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

class _WordCard extends StatelessWidget {
  const _WordCard({required this.word});
  final VocabularyWord word;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 3,
              decoration: const BoxDecoration(
                color: Color(0xFF6366F1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            word.word,
                            style: const TextStyle(
                              color: Color(0xFFF1F5F9),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                        if (word.partOfSpeech.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              word.partOfSpeech,
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      word.translation,
                      style: const TextStyle(
                          color: Color(0xFF64748B), fontSize: 13),
                    ),
                    if (word.example.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '"${word.example}"',
                        style: const TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
