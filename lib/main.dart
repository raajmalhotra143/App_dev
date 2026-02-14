import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/game_state_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/game_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => GameStateProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Chess Master',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            home: const GameScreen(),
          );
        },
      ),
    );
  }
}
