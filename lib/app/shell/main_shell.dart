import 'dart:ui';

import 'package:elia/app/router/app_routes.dart';
import 'package:elia/core/assets/app_assets.dart';
import 'package:elia/core/theme/app_colors.dart';
import 'package:elia/core/theme/app_radius.dart';
import 'package:elia/core/theme/app_spacing.dart';
import 'package:elia/shared/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _navbarHeight = 60.0;

class TabItem {
  final String icon;
  final String label;
  final String routePath;

  const TabItem({
    required this.icon,
    required this.label,
    required this.routePath,
  });
}

abstract final class AppTabs {
  static const items = [
    TabItem(
      icon: AppAssets.homeIcon,
      label: 'Home',
      routePath: AppRoutes.homePath,
    ),
    TabItem(
      icon: AppAssets.bookOutlineIcon,
      label: 'Dictionary',
      routePath: AppRoutes.dictionaryPath,
    ),
    TabItem(
      icon: AppAssets.userOutlineIcon,
      label: 'Profile',
      routePath: AppRoutes.profilePath,
    ),
  ];

  static int indexFromLocation(String location) {
    if (location.startsWith(AppRoutes.homePath)) return 0;
    if (location.startsWith(AppRoutes.dictionaryPath)) return 1;
    if (location.startsWith(AppRoutes.profilePath)) return 2;
    return 0;
  }
}

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentTab = AppTabs.indexFromLocation(location);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          MediaQuery(
            data: MediaQuery.of(context).copyWith(
              padding: MediaQuery.of(context).padding.copyWith(
                bottom:
                    _navbarHeight +
                    MediaQuery.of(context).padding.bottom +
                    AppSpacing.bottomNavBottom,
              ),
            ),
            child: child,
          ),
          Positioned(
            left: AppSpacing.bottomNavLeft,
            right: AppSpacing.bottomNavRight,
            bottom:
                MediaQuery.of(context).padding.bottom +
                AppSpacing.bottomNavBottom,
            child: _BottomNav(
              currentIndex: currentTab,
              onTap: (value) => context.go(AppTabs.items[value].routePath),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: _navbarHeight,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
            border: Border.all(
              color: AppColors.surfaceBorder.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: List.generate(AppTabs.items.length, (i) {
              final item = AppTabs.items[i];
              final selected = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AppIcon(
                          path: item.icon,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textMuted,
                          size: 26,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: -8,
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutCubic,
                              width: selected ? 25.0 : 0.0,
                              height: 3,
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary.withValues(alpha: 0.7)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
