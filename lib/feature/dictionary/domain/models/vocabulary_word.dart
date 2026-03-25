class VocabularyWord {
  const VocabularyWord({
    required this.id,
    required this.word,
    required this.translation,
    required this.partOfSpeech,
    required this.example,
    required this.addedAt,
    this.reviewLevel = 0,
  });

  final String id;
  final String word;
  final String translation;
  final String partOfSpeech;
  final String example;
  final DateTime addedAt;

  /// SRS level: 0 = new, 1-4 = learning, 5 = mastered.
  final int reviewLevel;

  WordStatus get status => switch (reviewLevel) {
        0 => WordStatus.fresh,
        >= 5 => WordStatus.mastered,
        _ => WordStatus.learning,
      };

  VocabularyWord copyWith({int? reviewLevel}) {
    return VocabularyWord(
      id: id,
      word: word,
      translation: translation,
      partOfSpeech: partOfSpeech,
      example: example,
      addedAt: addedAt,
      reviewLevel: reviewLevel ?? this.reviewLevel,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'translation': translation,
        'part_of_speech': partOfSpeech,
        'example': example,
        'added_at': addedAt.toIso8601String(),
        'review_level': reviewLevel,
      };

  factory VocabularyWord.fromJson(Map<String, dynamic> json) {
    return VocabularyWord(
      id: json['id'] as String,
      word: json['word'] as String,
      translation: json['translation'] as String,
      partOfSpeech: json['part_of_speech'] as String? ?? '',
      example: json['example'] as String? ?? '',
      addedAt: DateTime.parse(json['added_at'] as String),
      reviewLevel: json['review_level'] as int? ?? 0,
    );
  }
}

enum WordStatus { fresh, learning, mastered }
