import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'state/app_state.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const KazokuApp());
}

class KazokuApp extends StatelessWidget {
  const KazokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, app, _) {
          return MaterialApp(
            title: 'Kazoku Pet Store',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: app.themeMode,
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
