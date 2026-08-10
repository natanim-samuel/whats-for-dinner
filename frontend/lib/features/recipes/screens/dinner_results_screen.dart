import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../kitchen/providers/kitchen_provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import 'recipe_detail_screen.dart';

class DinnerResultsScreen extends ConsumerStatefulWidget {
  const DinnerResultsScreen({super.key});

  @override
  ConsumerState<DinnerResultsScreen> createState() => _DinnerResultsScreenState();
}

class _DinnerResultsScreenState extends ConsumerState<DinnerResultsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ids = ref.read(kitchenProvider.notifier).ingredientIds;
      ref.read(dinnerMatchProvider.notifier).findDinner(ids);
    });
  }

  @override
  Widget build(BuildContext context) {
    final matchesAsync = ref.watch(dinnerMatchProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dinner Ideas 🍽️')),
      body: matchesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('$err', textAlign: TextAlign.center),
          ),
        ),
        data: (matches) {
          if (matches.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final match = matches[index];
              final isBest = index == 0;
              return _RecipeMatchCard(match: match, isBest: isBest);
            },
          );
        },
      ),
    );
  }
}

class _RecipeMatchCard extends StatelessWidget {
  final RecipeMatch match;
  final bool isBest;
  const _RecipeMatchCard({required this.match, required this.isBest});

  Color get _matchColor {
    if (match.matchPercentage >= 80) return AppColors.success;
    if (match.matchPercentage >= 50) return AppColors.warning;
    return AppColors.missing;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: match.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: match.imageUrl != null
                    ? Image.network(
                        '${match.imageUrl}?w=160&q=60',
                        width: 80, height: 80, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isBest)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text('🎯 BEST MATCH',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    Text(match.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: match.matchPercentage / 100,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFEFEFEF),
                        color: _matchColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${match.matchPercentage}% match · ${match.haveCount}/${match.totalCount} ingredients',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text('${match.cookingTime} min', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        const SizedBox(width: 12),
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text('${match.rating}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 80, height: 80,
        color: const Color(0xFFF1E7DB),
        child: const Icon(Icons.restaurant, color: AppColors.primary),
      );
}
