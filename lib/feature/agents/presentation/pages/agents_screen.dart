import 'package:elia/core/presentation/pages/main_shell.dart';
import 'package:elia/core/theme/elia_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/agent_config.dart';

class AgentsScreen extends ConsumerWidget {
  const AgentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(agentProvider);
    final colors = context.eliaColors;

    return Scaffold(
      backgroundColor: colors.surfacePrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agents',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pick a tutor and start speaking',
                    style: TextStyle(color: colors.textMuted, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.82,
                ),
                itemCount: kAgents.length,
                itemBuilder: (context, index) {
                  final agent = kAgents[index];
                  final isSelected = state.selectedAgentId == agent.id;
                  return _AgentCard(
                    agent: agent,
                    isSelected: isSelected,
                    onTap:
                        () => ref
                            .read(agentProvider.notifier)
                            .selectAgent(agent.id),
                  );
                },
              ),
            ),
            AnimatedSlide(
              duration: const Duration(milliseconds: 320),
              offset:
                  state.selectedAgent != null
                      ? Offset.zero
                      : const Offset(0, 1),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: state.selectedAgent != null ? 1.0 : 0.0,
                child: _ActionBar(agent: state.selectedAgent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgentCard extends StatelessWidget {
  const _AgentCard({
    required this.agent,
    required this.isSelected,
    required this.onTap,
  });

  final BotAgent agent;
  final bool isSelected;
  final VoidCallback onTap;

  Color get _lightColor => Color.lerp(agent.avatarColor, Colors.white, 0.35)!;

  @override
  Widget build(BuildContext context) {
    final colors = context.eliaColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected
                    ? agent.avatarColor.withValues(alpha: 0.7)
                    : colors.borderPrimary,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: agent.avatarColor.withValues(alpha: 0.18),
                      blurRadius: 20,
                      spreadRadius: -2,
                    ),
                  ]
                  : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        center: const Alignment(-0.3, -0.4),
                        radius: 1.1,
                        colors: [
                          _lightColor.withValues(alpha: 0.55),
                          agent.avatarColor.withValues(alpha: 0.25),
                        ],
                      ),
                      border: Border.all(
                        color: agent.avatarColor.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        agent.initials,
                        style: TextStyle(
                          color: _lightColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: colors.surfaceSecondary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.borderPrimary,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          agent.flag,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                agent.name,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                agent.specialty,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: 5,
                width: isSelected ? 28 : 4,
                decoration: BoxDecoration(
                  color: isSelected ? agent.avatarColor : colors.borderPrimary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBar extends ConsumerWidget {
  const _ActionBar({required this.agent});

  final BotAgent? agent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = agent;
    if (a == null) return const SizedBox.shrink();
    final colors = context.eliaColors;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: a.avatarColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  a.avatarColor.withValues(alpha: 0.4),
                  a.avatarColor.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: Center(
              child: Text(a.flag, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.name,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  a.languageName,
                  style: TextStyle(color: colors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(currentTabProvider.notifier).setTab(0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    a.avatarColor,
                    Color.lerp(a.avatarColor, Colors.white, 0.2)!,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: a.avatarColor.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Start',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
