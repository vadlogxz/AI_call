class VocabularyWord {
  const VocabularyWord({
    required this.id,
    required this.word,
    required this.translation,
    required this.partOfSpeech,
    required this.example,
    required this.addedAt,
  });

  final String id;
  final String word;
  final String translation;
  final String partOfSpeech;
  final String example;
  final DateTime addedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'translation': translation,
        'part_of_speech': partOfSpeech,
        'example': example,
        'added_at': addedAt.toIso8601String(),
      };

  factory VocabularyWord.fromJson(Map<String, dynamic> json) {
    return VocabularyWord(
      id: json['id'] as String,
      word: json['word'] as String,
      translation: json['translation'] as String,
      partOfSpeech: json['part_of_speech'] as String? ?? '',
      example: json['example'] as String? ?? '',
      addedAt: DateTime.parse(json['added_at'] as String),
    );
  }
}
