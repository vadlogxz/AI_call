class ConversationResponse {
  const ConversationResponse({
    required this.userText,
    required this.replyText,
    required this.replyAudioB64,
    this.corrected,
    required this.hasError,
    required this.vocabulary,
  });

  final String userText;
  final String replyText;
  final String replyAudioB64;
  final String? corrected;
  final bool hasError;
  final List<VocabWord> vocabulary;

  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    return ConversationResponse(
      userText: json['user_text'] as String? ?? '',
      replyText: json['reply_text'] as String? ?? '',
      replyAudioB64: json['reply_audio'] as String? ?? '',
      corrected: json['corrected'] as String?,
      hasError: json['has_error'] as bool? ?? false,
      vocabulary: (json['vocabulary'] as List<dynamic>? ?? [])
          .map((e) => VocabWord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class VocabWord {
  const VocabWord({
    required this.word,
    required this.translation,
    required this.partOfSpeech,
    required this.example,
  });

  final String word;
  final String translation;
  final String partOfSpeech;
  final String example;

  factory VocabWord.fromJson(Map<String, dynamic> json) {
    return VocabWord(
      word: json['word'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      partOfSpeech: json['part_of_speech'] as String? ?? '',
      example: json['example'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'translation': translation,
        'part_of_speech': partOfSpeech,
        'example': example,
      };
}
