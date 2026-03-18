import 'package:elia/feature/agents/presentation/pages/agents_screen.dart';
import 'package:elia/feature/call/presentation/pages/call_screen.dart';
import 'package:elia/feature/dictionary/presentation/pages/dictionary_screen.dart';
import 'package:elia/feature/settings/presentation/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _currentTabProvider =
    NotifierProvider<_TabNotifier, int>(_TabNotifier.new);

class _TabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int index) => state = index;
}

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(_currentTabProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF020817),
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
        onTap: ref.read(_currentTabProvider.notifier).setTab,
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
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final selected = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        selected ? item.$2 : item.$1,
                        color: selected
                            ? const Color(0xFFF8FAFC)
                            : const Color(0xFF475569),
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.$3,
                        style: TextStyle(
                          color: selected
                              ? const Color(0xFFF8FAFC)
                              : const Color(0xFF475569),
                          fontSize: 10,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
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
