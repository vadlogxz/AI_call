class ConversationVocabulary {
  const ConversationVocabulary({
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

class ConversationResult {
  const ConversationResult({
    required this.userText,
    required this.replyText,
    required this.replyAudioB64,
    required this.corrected,
    required this.hasError,
    required this.vocabulary,
  });

  final String userText;
  final String replyText;
  final String replyAudioB64;
  final String? corrected;
  final bool hasError;
  final List<ConversationVocabulary> vocabulary;
}
