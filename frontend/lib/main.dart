import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/navigation/screens/main_navigation_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: WhatsForDinnerApp(),
    ),
  );
}

class WhatsForDinnerApp extends ConsumerWidget {
  const WhatsForDinnerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: "What's for Dinner?",
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      home: const MainNavigationScreen(),
    );
  }
}