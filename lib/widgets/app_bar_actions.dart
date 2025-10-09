import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  IconData _iconFor(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
      return Icons.brightness_auto;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<AppState, ThemeMode>((a) => a.themeMode);
    return IconButton(
      tooltip: 'Toggle theme',
      onPressed: () => context.read<AppState>().toggleThemeMode(),
      icon: Icon(_iconFor(themeMode)),
    );
  }
}
