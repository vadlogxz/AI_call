import 'package:elia/core/theme/app_colors.dart';
import 'package:elia/feature/auth/di/auth_provider.dart';
import 'package:elia/feature/auth/domain/models/auth_state.dart';
import 'package:elia/feature/profile/presentation/pages/settings_screen.dart';
import 'package:elia/feature/profile/presentation/state/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final settings = ref.watch(settingsProvider);
    final authRepo = ref.read(authRepositoryProvider);

    final user = switch (authState.asData?.value) {
      Authenticated(:final user) => user,
      _ => null,
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Profile',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    _Avatar(
                      initials: _initials(user?.name, user?.email ?? ''),
                    ),
                    const SizedBox(height: 14),
                    if (user?.name != null) ...[
                      Text(
                        user!.name!,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      user?.email ?? '',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _StreakCard(streak: settings.streak),
              const SizedBox(height: 32),
              _SectionLabel('Preferences', color: AppColors.textMuted),
              const SizedBox(height: 10),
              _Group(
                children: [
                  _Tile(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionLabel('Account', color: AppColors.textMuted),
              const SizedBox(height: 10),
              _Group(
                children: [
                  _Tile(
                    icon: Icons.logout_rounded,
                    label: 'Sign Out',
                    isDestructive: true,
                    onTap: () => authRepo.signOut(),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  static String _initials(String? name, String email) {
    if (name != null && name.trim().isNotEmpty) {
      final parts = name.trim().split(' ');
      if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      return parts[0][0].toUpperCase();
    }
    return email.isNotEmpty ? email[0].toUpperCase() : '?';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surfaceBorder, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.streakBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.streakBorder),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$streak day streak',
                style: TextStyle(
                  color: AppColors.warning,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                streak == 0
                    ? 'Start your first session today'
                    : 'Keep it up — come back tomorrow!',
                style: TextStyle(color: AppColors.warning.withValues(alpha: 0.7), fontSize: 12),
              ),
            ],
          ),
        ],
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

class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(children: children),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (!isDestructive)
                Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
