import 'package:flutter/material.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  static const _words = [
    _WordData(
      word: 'Serendipity',
      translation: 'Щасливий випадок',
      partOfSpeech: 'noun',
      example: 'Finding this book was pure serendipity.',
    ),
    _WordData(
      word: 'Ephemeral',
      translation: 'Скороминущий',
      partOfSpeech: 'adj',
      example: 'The beauty of cherry blossoms is ephemeral.',
    ),
    _WordData(
      word: 'Ubiquitous',
      translation: 'Всюдисущий',
      partOfSpeech: 'adj',
      example: 'Smartphones have become ubiquitous.',
    ),
    _WordData(
      word: 'Melancholy',
      translation: 'Меланхолія',
      partOfSpeech: 'noun',
      example: 'A deep melancholy settled over him.',
    ),
    _WordData(
      word: 'Resilience',
      translation: 'Стійкість',
      partOfSpeech: 'noun',
      example: 'Her resilience in the face of adversity was admirable.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                  _SearchBar(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${_words.length} words',
                        style: const TextStyle(
                            color: Color(0xFF475569), fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                itemCount: _words.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _WordCard(data: _words[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
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

class _WordData {
  const _WordData({
    required this.word,
    required this.translation,
    required this.partOfSpeech,
    required this.example,
  });

  final String word;
  final String translation;
  final String partOfSpeech;
  final String example;
}

class _WordCard extends StatelessWidget {
  const _WordCard({required this.data});
  final _WordData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.word,
                  style: const TextStyle(
                    color: Color(0xFFF8FAFC),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  data.partOfSpeech,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            data.translation,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
          const SizedBox(height: 10),
          Text(
            '"${data.example}"',
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 12,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
