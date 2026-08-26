import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/models.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/recipe_provider.dart';
import 'recipe_detail_screen.dart';

class DinnerResultsScreen extends ConsumerWidget {
  const DinnerResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matches = ref.watch(dinnerMatchesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dinner Ideas 🍽️')),
      body: matches.isEmpty
          ? const Center(child: Text('No recipes found.', style: TextStyle(color: AppColors.textLight)))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: matches.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _RecipeMatchCard(match: matches[index], isBest: index == 0);
        },
      ),
    );
  }
}

class _RecipeMatchCard extends StatelessWidget {
  final RecipeMatchResult match;
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
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: match.recipe.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  '${match.recipe.imageUrl}?w=160&q=60',
                  width: 80, height: 80, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                ),
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
                            style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    Text(match.recipe.name,
                        style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: match.matchPercentage / 100,
                        minHeight: 8,
                        backgroundColor: AppColors.background,
                        color: _matchColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${match.matchPercentage}% match · ${match.haveCount}/${match.totalCount} ingredients',
                      style: const TextStyle(color: AppColors.textLightMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: AppColors.textLightMuted),
                        const SizedBox(width: 4),
                        Text('${match.recipe.cookingTimeMinutes} min',
                            style: const TextStyle(fontSize: 12, color: AppColors.textLightMuted)),
                        const SizedBox(width: 12),
                        const Icon(Icons.star, size: 14, color: AppColors.accent),
                        const SizedBox(width: 4),
                        Text('${match.recipe.rating}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textLightMuted)),
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
    color: AppColors.backgroundElevated,
    child: const Icon(Icons.restaurant, color: AppColors.accent),
  );
}