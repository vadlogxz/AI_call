import 'package:elia/feature/agents/presentation/pages/agents_screen.dart';
import 'package:elia/feature/call/presentation/pages/call_screen.dart';
import 'package:elia/feature/dictionary/presentation/pages/dictionary_screen.dart';
import 'package:elia/feature/settings/presentation/pages/settings_screen.dart';
import 'package:elia/core/theme/elia_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentTabProvider = NotifierProvider<_TabNotifier, int>(
  _TabNotifier.new,
);

class _TabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int index) => state = index;
}

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(
        index: currentTab,
        children: const [
          CallScreen(),
          DictionaryScreen(),
          AgentsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: currentTab,
        onTap: ref.read(currentTabProvider.notifier).setTab,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.mic_none, Icons.mic, 'Call'),
    (Icons.menu_book_outlined, Icons.menu_book, 'Dictionary'),
    (Icons.smart_toy_outlined, Icons.smart_toy, 'Agents'),
    (Icons.settings_outlined, Icons.settings, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.eliaColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.navBackground,
        border: Border(
          top: BorderSide(color: colors.borderPrimary, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
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
                            selected
                                ? colors.navSelectedBackground
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            selected ? item.$2 : item.$1,
                            color:
                                selected
                                    ? colors.navSelectedForeground
                                    : colors.navIdleForeground,
                            size: 20,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.$3,
                            style: TextStyle(
                              color:
                                  selected
                                      ? colors.navSelectedForeground
                                      : colors.navIdleForeground,
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
