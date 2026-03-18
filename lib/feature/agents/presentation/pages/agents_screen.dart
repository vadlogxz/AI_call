import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../state/agent_config.dart';

class AgentsScreen extends ConsumerWidget {
  const AgentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(agentConfigProvider);
    final notifier = ref.read(agentConfigProvider.notifier);
    final agentLang = langByCode(config.agentLanguage);
    final speakLang = langByCode(config.speakingLanguage);

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
                'Agents',
                style: TextStyle(
                  color: Color(0xFFF8FAFC),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Configure your AI conversation agent',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
              ),
              const SizedBox(height: 32),

              // Config card
              _Section(
                title: 'Language Settings',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('Agent responds in'),
                    const SizedBox(height: 8),
                    ShadSelect<String>(
                      initialValue: config.agentLanguage,
                      placeholder: const Text('Select language'),
                      onChanged: (v) {
                        if (v != null) notifier.setAgentLanguage(v);
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
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFF1E293B), height: 1),
                    const SizedBox(height: 20),
                    _Label('I speak in'),
                    const SizedBox(height: 8),
                    ShadSelect<String>(
                      initialValue: config.speakingLanguage,
                      placeholder: const Text('Select language'),
                      onChanged: (v) {
                        if (v != null) notifier.setSpeakingLanguage(v);
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

              const SizedBox(height: 16),

              // Active agent preview
              _Section(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.smart_toy_outlined,
                        color: Color(0xFF94A3B8),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Active Configuration',
                            style: TextStyle(
                              color: Color(0xFFF8FAFC),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${speakLang.$2} ${speakLang.$3}  →  ${agentLang.$2} ${agentLang.$3}',
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusBadge('Ready'),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.child, this.title});
  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF94A3B8),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF14532D).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: const Color(0xFF22C55E).withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF22C55E),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
