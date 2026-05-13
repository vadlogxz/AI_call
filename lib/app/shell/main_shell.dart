import 'package:elia/app/router/app_routes.dart';
import 'package:elia/core/assets/app_assets.dart';
import 'package:elia/core/theme/app_colors.dart';
import 'package:elia/shared/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabItem {
  final String icon;
  final String activeIcon;
  final String label;
  final String routePath;

  const TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.routePath,
  });
}

abstract final class AppTabs {
  static const items = [
    TabItem(
      icon: AppAssets.homeBrokenIcon,
      activeIcon: AppAssets.homeOutlineIcon,
      label: 'Home',
      routePath: AppRoutes.homePath,
    ),
    TabItem(
      icon: AppAssets.bookBrokenIcon,
      activeIcon: AppAssets.bookOutlineIcon,
      label: 'Dictionary',
      routePath: AppRoutes.dictionaryPath,
    ),
    TabItem(
      icon: AppAssets.userBrokenIcon,
      activeIcon: AppAssets.userOutlineIcon,
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
      body: child,
      bottomNavigationBar: _BottomNav(
        currentIndex: currentTab,
        onTap: (value) => context.go(AppTabs.items[value].routePath),
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.surfaceBorder, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(AppTabs.items.length, (i) {
              final item = AppTabs.items[i];
              final selected = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selected ? AppColors.surface : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppIcon(
                            path: selected ? item.activeIcon : item.icon,
                            color: selected ? AppColors.textPrimary : AppColors.textMuted,
                            size: 20,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: selected ? AppColors.textPrimary : AppColors.textMuted,
                              fontSize: 10,
                              fontWeight:
                                  selected ? FontWeight.w600 : FontWeight.w400,
                              letterSpacing: selected ? 0.2 : 0,
                            ),
                          ),
                        ],
                      ),
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
