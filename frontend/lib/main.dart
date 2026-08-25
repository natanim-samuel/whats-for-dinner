import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/home/screens/home_screen.dart';
import 'features/kitchen/screens/kitchen_screen.dart';

void main() {
  runApp(const ProviderScope(child: WhatsForDinnerApp()));
}

class WhatsForDinnerApp extends StatelessWidget {
  const WhatsForDinnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "What's for Dinner?",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const RootShell(),
    );
  }
}

/// Bottom-nav shell for the Phase 1 MVP: Home and My Kitchen.
/// Fully offline — everything runs from in-memory mock data, no backend.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    KitchenScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.kitchen_outlined), activeIcon: Icon(Icons.kitchen), label: 'Kitchen'),
        ],
      ),
    );
  }
}