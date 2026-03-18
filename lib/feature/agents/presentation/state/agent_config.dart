import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<(String, String, String)> kLanguages = [
  ('en', '🇬🇧', 'English'),
  ('uk', '🇺🇦', 'Ukrainian'),
  ('es', '🇪🇸', 'Spanish'),
  ('fr', '🇫🇷', 'French'),
  ('de', '🇩🇪', 'German'),
  ('pl', '🇵🇱', 'Polish'),
  ('it', '🇮🇹', 'Italian'),
  ('pt', '🇵🇹', 'Portuguese'),
];

(String, String, String) langByCode(String code) =>
    kLanguages.firstWhere((l) => l.$1 == code, orElse: () => kLanguages.first);

class AgentConfig {
  const AgentConfig({
    this.agentLanguage = 'en',
    this.speakingLanguage = 'uk',
  });

  final String agentLanguage;
  final String speakingLanguage;

  AgentConfig copyWith({String? agentLanguage, String? speakingLanguage}) {
    return AgentConfig(
      agentLanguage: agentLanguage ?? this.agentLanguage,
      speakingLanguage: speakingLanguage ?? this.speakingLanguage,
    );
  }
}

class AgentConfigNotifier extends Notifier<AgentConfig> {
  @override
  AgentConfig build() => const AgentConfig();

  void setAgentLanguage(String code) =>
      state = state.copyWith(agentLanguage: code);

  void setSpeakingLanguage(String code) =>
      state = state.copyWith(speakingLanguage: code);
}

final agentConfigProvider =
    NotifierProvider<AgentConfigNotifier, AgentConfig>(AgentConfigNotifier.new);
