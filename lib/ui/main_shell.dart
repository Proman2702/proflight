import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proflight/etc/colors.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.currentPath, required this.child, super.key});

  final String currentPath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.mainDark,
      body: child,
      bottomNavigationBar: NavigationBar(
        height: 68,
        selectedIndex: _selectedIndex(currentPath),
        backgroundColor: const Color(0xFF101114),
        indicatorColor: CustomColors.accent1.withValues(alpha: 0.22),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          final path = switch (index) {
            0 => '/main/home',
            1 => '/main/flights',
            2 => '/main/flights/new',
            3 => '/main/export',
            _ => '/main/profile',
          };
          context.go(path);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'Журнал',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Добавить',
          ),
          NavigationDestination(
            icon: Icon(Icons.file_upload_outlined),
            selectedIcon: Icon(Icons.file_upload),
            label: 'Экспорт',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }

  int _selectedIndex(String path) {
    if (path.startsWith('/main/flights/new')) return 2;
    if (path.startsWith('/main/flights')) return 1;
    if (path.startsWith('/main/export')) return 3;
    if (path.startsWith('/main/profile')) return 4;
    return 0;
  }
}
