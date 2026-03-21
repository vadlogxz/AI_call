class AppSettings {
  const AppSettings({
    this.speakingLanguage = 'uk',
    this.autoSend = true,
    this.hapticFeedback = true,
    this.saveHistory = false,
  });

  final String speakingLanguage;
  final bool autoSend;
  final bool hapticFeedback;
  final bool saveHistory;

  AppSettings copyWith({
    String? speakingLanguage,
    bool? autoSend,
    bool? hapticFeedback,
    bool? saveHistory,
  }) {
    return AppSettings(
      speakingLanguage: speakingLanguage ?? this.speakingLanguage,
      autoSend: autoSend ?? this.autoSend,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      saveHistory: saveHistory ?? this.saveHistory,
    );
  }
}
