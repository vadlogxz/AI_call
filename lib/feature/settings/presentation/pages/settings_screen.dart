import 'package:elia/feature/agents/presentation/state/agent_config.dart';
import 'package:elia/feature/settings/presentation/state/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Settings',
                style: TextStyle(
                  color: Color(0xFFF8FAFC),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 32),

              // ── Language ──────────────────────────────────────────────────
              _SectionLabel('My Language'),
              const SizedBox(height: 10),
              _SettingsGroup(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'I speak in',
                          style: TextStyle(
                            color: Color(0xFFF8FAFC),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Used to configure the agent on the backend',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ShadSelect<String>(
                          initialValue: settings.speakingLanguage,
                          placeholder: const Text('Select your language'),
                          onChanged: (v) {
                            if (v != null) {
                              settingsNotifier.setSpeakingLanguage(v);
                              ref
                                  .read(agentProvider.notifier)
                                  .setSpeakingLanguage(v);
                            }
                          },
                          selectedOptionBuilder: (_, value) {
                            final lang = langByCode(value);
                            return Row(
                              children: [
                                Text(lang.$2,
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 8),
                                Text(lang.$3),
                              ],
                            );
                          },
                          options: kLanguages.map(
                            (l) => ShadOption<String>(
                              value: l.$1,
                              child: Row(
                                children: [
                                  Text(l.$2,
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: 10),
                                  Text(l.$3),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Audio ──────────────────────────────────────────────────────
              _SectionLabel('Audio'),
              const SizedBox(height: 10),
              _SettingsGroup(
                children: [
                  ShadSwitch(
                    value: settings.autoSend,
                    onChanged: settingsNotifier.setAutoSend,
                    label: const Text('Auto-send on silence'),
                    sublabel: const Text('Send to STT when speech ends'),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  const Divider(color: Color(0xFF1E293B), height: 1),
                  ShadSwitch(
                    value: settings.hapticFeedback,
                    onChanged: settingsNotifier.setHapticFeedback,
                    label: const Text('Haptic feedback'),
                    sublabel: const Text('Vibrate on speech detection'),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Privacy ────────────────────────────────────────────────────
              _SectionLabel('Privacy'),
              const SizedBox(height: 10),
              _SettingsGroup(
                children: [
                  ShadSwitch(
                    value: settings.saveHistory,
                    onChanged: settingsNotifier.setSaveHistory,
                    label: const Text('Save session history'),
                    sublabel: const Text('Store transcriptions locally'),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── About ──────────────────────────────────────────────────────
              _SectionLabel('About'),
              const SizedBox(height: 10),
              _SettingsGroup(
                children: [
                  _InfoRow('Version', '1.0.0'),
                  const Divider(color: Color(0xFF1E293B), height: 1),
                  _InfoRow('VAD Model', 'Silero v5'),
                  const Divider(color: Color(0xFF1E293B), height: 1),
                  _InfoRow('Sample Rate', '16 000 Hz'),
                  const Divider(color: Color(0xFF1E293B), height: 1),
                  _InfoRow('Encoder', 'PCM 16-bit'),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF475569),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(color: Color(0xFFF8FAFC), fontSize: 14)),
          const Spacer(),
          Text(value,
              style:
                  const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
        ],
      ),
    );
  }
}
