import 'package:elia/core/theme/elia_theme_extension.dart';
import 'package:elia/feature/agents/presentation/state/agent_config.dart';
import 'package:elia/feature/settings/domain/models/theme_preference.dart';
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
    final theme = Theme.of(context);
    final colors = context.eliaColors;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Settings',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 32),
              _SectionLabel('Appearance', color: colors.textMuted),
              const SizedBox(height: 10),
              _SettingsGroup(
                backgroundColor: colors.surfaceSecondary,
                borderColor: colors.borderPrimary,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Choose how Elia looks across the app',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SegmentedButton<ThemePreference>(
                          segments: const [
                            ButtonSegment(
                              value: ThemePreference.system,
                              icon: Icon(Icons.brightness_auto_rounded),
                              label: Text('System'),
                            ),
                            ButtonSegment(
                              value: ThemePreference.light,
                              icon: Icon(Icons.light_mode_rounded),
                              label: Text('Light'),
                            ),
                            ButtonSegment(
                              value: ThemePreference.dark,
                              icon: Icon(Icons.dark_mode_rounded),
                              label: Text('Dark'),
                            ),
                          ],
                          selected: {settings.themePreference},
                          onSelectionChanged: (selection) {
                            settingsNotifier.setThemePreference(
                              selection.first,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionLabel('My Language', color: colors.textMuted),
              const SizedBox(height: 10),
              _SettingsGroup(
                backgroundColor: colors.surfaceSecondary,
                borderColor: colors.borderPrimary,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'I speak in',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Used to configure the agent on the backend',
                          style: TextStyle(
                            color: colors.textMuted,
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
                                Text(
                                  lang.$2,
                                  style: const TextStyle(fontSize: 16),
                                ),
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
                                  Text(
                                    l.$2,
                                    style: const TextStyle(fontSize: 16),
                                  ),
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
              _SectionLabel('Audio', color: colors.textMuted),
              const SizedBox(height: 10),
              _SettingsGroup(
                backgroundColor: colors.surfaceSecondary,
                borderColor: colors.borderPrimary,
                children: [
                  ShadSwitch(
                    value: settings.autoSend,
                    onChanged: settingsNotifier.setAutoSend,
                    label: const Text('Auto-send on silence'),
                    sublabel: const Text('Send to STT when speech ends'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  Divider(color: colors.borderPrimary, height: 1),
                  ShadSwitch(
                    value: settings.hapticFeedback,
                    onChanged: settingsNotifier.setHapticFeedback,
                    label: const Text('Haptic feedback'),
                    sublabel: const Text('Vibrate on speech detection'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionLabel('Privacy', color: colors.textMuted),
              const SizedBox(height: 10),
              _SettingsGroup(
                backgroundColor: colors.surfaceSecondary,
                borderColor: colors.borderPrimary,
                children: [
                  ShadSwitch(
                    value: settings.saveHistory,
                    onChanged: settingsNotifier.setSaveHistory,
                    label: const Text('Save session history'),
                    sublabel: const Text('Store transcriptions locally'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionLabel('About', color: colors.textMuted),
              const SizedBox(height: 10),
              _SettingsGroup(
                backgroundColor: colors.surfaceSecondary,
                borderColor: colors.borderPrimary,
                children: [
                  const _InfoRow('Version', '1.0.0'),
                  Divider(color: colors.borderPrimary, height: 1),
                  const _InfoRow('VAD Model', 'Silero v5'),
                  Divider(color: colors.borderPrimary, height: 1),
                  const _InfoRow('Sample Rate', '16 000 Hz'),
                  Divider(color: colors.borderPrimary, height: 1),
                  const _InfoRow('Encoder', 'PCM 16-bit'),
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
  const _SectionLabel(this.title, {required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({
    required this.children,
    required this.backgroundColor,
    required this.borderColor,
  });

  final List<Widget> children;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
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
    final colors = context.eliaColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(color: colors.textPrimary, fontSize: 14),
          ),
          const Spacer(),
          Text(value, style: TextStyle(color: colors.textMuted, fontSize: 14)),
        ],
      ),
    );
  }
}
