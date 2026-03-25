class WordLookupResult {
  const WordLookupResult({
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
