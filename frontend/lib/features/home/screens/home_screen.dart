import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../kitchen/providers/kitchen_provider.dart';
import '../../recipes/screens/dinner_results_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kitchenAsync = ref.watch(kitchenProvider);
    final ingredientCount = kitchenAsync.value?.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text("What's for Dinner? 🍳")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Good evening 👋', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                ingredientCount > 0
                    ? 'You have $ingredientCount ingredients in your kitchen.'
                    : 'Add ingredients to your kitchen to get started.',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 15),
              ),
              const SizedBox(height: 28),
              Card(
                color: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🍳 Cook With My Ingredients',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                      const SizedBox(height: 6),
                      const Text(
                        "We'll find recipes ranked by how much of your kitchen they use.",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const DinnerResultsScreen()),
                            );
                          },
                          child: const Text('Find Dinner →'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
