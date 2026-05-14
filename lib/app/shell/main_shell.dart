import 'dart:ui';

import 'package:elia/app/router/app_routes.dart';
import 'package:elia/core/assets/app_assets.dart';
import 'package:elia/core/logging/app_logger.dart';
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
  static const List<TabItem> items = [
    TabItem(
      icon: AppAssets.homeIcon,
      label: 'Home',
      routePath: AppRoutes.homePath,
    ),
    TabItem(
      icon: AppAssets.bookOutlineIcon,
      label: 'Vocabulary',
      routePath: AppRoutes.vocabularyPath,
    ),
    TabItem(
      icon: AppAssets.userOutlineIcon,
      label: 'Profile',
      routePath: AppRoutes.profilePath,
    ),
  ];

  static int indexFromLocation(String location) {
    if (location.startsWith(AppRoutes.homePath)) return 0;
    if (location.startsWith(AppRoutes.vocabularyPath)) return 1;
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
                    AppSpacing.lg,
              ),
            ),
            child: child,
          ),
          Positioned(
            right: AppSpacing.md,
            left: AppSpacing.md,
            bottom:
                MediaQuery.of(context).padding.bottom +
                AppSpacing.lg,
            child: _BottomNav(
              currentIndex: currentTab,
              onTap: (value) {
                if(value < 0 || value >= AppTabs.items.length){
                  AppLogger.warning('Invalid tab index: $value');
                  return;
                }
                final routePath = AppTabs.items[value].routePath;
                if (routePath != location) {
                  context.go(routePath);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatefulWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  State<_BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<_BottomNav>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _widthAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 24.0, end: 48.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 48.0, end: 24.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _BottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controller.forward(from: 0);
    }
  }

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tabWidth = constraints.maxWidth / AppTabs.items.length;
              final indicatorX = widget.currentIndex * tabWidth;

              return Stack(
                children: [
                  Row(
                    children: List.generate(AppTabs.items.length, (i) {
                      final item = AppTabs.items[i];
                      final selected = i == widget.currentIndex;
                      return Expanded(
                        child: Semantics(
                          button: true,
                          label: item.label,
                          child: GestureDetector(
                            onTap: () => widget.onTap(i),
                            behavior: HitTestBehavior.opaque,
                            child: Center(
                              child: AppIcon(
                                path: item.icon,
                                color:
                                    selected
                                        ? AppColors.primary
                                        : AppColors.textMuted,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  AnimatedBuilder(
                    animation: _widthAnimation,
                    builder:
                        (context, _) => AnimatedPositioned(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          left:
                              indicatorX +
                              (tabWidth / 2) -
                              (_widthAnimation.value / 2),
                          bottom: 8,
                          child: Container(
                            width: _widthAnimation.value,
                            height: 3,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
