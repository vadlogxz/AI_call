import 'package:elia/feature/settings/presentation/state/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Language catalogue ────────────────────────────────────────────────────────

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

// ── Bot agent model ───────────────────────────────────────────────────────────

class BotAgent {
  const BotAgent({
    required this.id,
    required this.name,
    required this.languageCode,
    required this.specialty,
    required this.avatarColor,
  });

  final String id;
  final String name;
  final String languageCode;
  final String specialty;
  final Color avatarColor;

  String get flag => langByCode(languageCode).$2;
  String get languageName => langByCode(languageCode).$3;
  String get initials => name.substring(0, 1).toUpperCase();
}

const kAgents = [
  BotAgent(
    id: 'emma-en',
    name: 'Emma',
    languageCode: 'en',
    specialty: 'English tutor',
    avatarColor: Color(0xFF6366F1),
  ),
  BotAgent(
    id: 'olena-uk',
    name: 'Olena',
    languageCode: 'uk',
    specialty: 'Ukrainian assistant',
    avatarColor: Color(0xFF22C55E),
  ),
  BotAgent(
    id: 'sofia-es',
    name: 'Sofia',
    languageCode: 'es',
    specialty: 'Spanish teacher',
    avatarColor: Color(0xFFF59E0B),
  ),
  BotAgent(
    id: 'amelie-fr',
    name: 'Amélie',
    languageCode: 'fr',
    specialty: 'French conversation',
    avatarColor: Color(0xFFEC4899),
  ),
  BotAgent(
    id: 'max-de',
    name: 'Max',
    languageCode: 'de',
    specialty: 'German practice',
    avatarColor: Color(0xFF3B82F6),
  ),
  BotAgent(
    id: 'luisa-pt',
    name: 'Luisa',
    languageCode: 'pt',
    specialty: 'Portuguese tutor',
    avatarColor: Color(0xFF14B8A6),
  ),
];

// ── State ─────────────────────────────────────────────────────────────────────

class AgentState {
  const AgentState({
    this.selectedAgentId,
    this.speakingLanguage = 'uk',
  });

  final String? selectedAgentId;
  final String speakingLanguage;

  BotAgent? get selectedAgent =>
      selectedAgentId == null
          ? null
          : kAgents.firstWhere(
              (a) => a.id == selectedAgentId,
              orElse: () => kAgents.first,
            );

  AgentState copyWith({
    String? selectedAgentId,
    String? speakingLanguage,
    bool clearAgent = false,
  }) {
    return AgentState(
      selectedAgentId: clearAgent ? null : selectedAgentId ?? this.selectedAgentId,
      speakingLanguage: speakingLanguage ?? this.speakingLanguage,
    );
  }
}

class AgentNotifier extends Notifier<AgentState> {
  @override
  AgentState build() {
    final speakingLanguage =
        ref.watch(settingsProvider).speakingLanguage;
    return AgentState(speakingLanguage: speakingLanguage);
  }

  void selectAgent(String id) =>
      state = state.copyWith(selectedAgentId: id);

  void setSpeakingLanguage(String code) =>
      state = state.copyWith(speakingLanguage: code);
}

final agentProvider =
    NotifierProvider<AgentNotifier, AgentState>(AgentNotifier.new);
