import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/recipe_provider.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final int recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsync = ref.watch(recipeDetailProvider(recipeId));

    return Scaffold(
      body: recipeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Could not load recipe.\n$err', textAlign: TextAlign.center)),
        data: (recipe) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 240,
                backgroundColor: AppColors.background,
                foregroundColor: AppColors.textDark,
                flexibleSpace: FlexibleSpaceBar(
                  background: recipe.imageUrl != null
                      ? Image.network(recipe.imageUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF1E7DB)))
                      : Container(color: const Color(0xFFF1E7DB)),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('${recipe.rating}'),
                          const SizedBox(width: 16),
                          const Icon(Icons.access_time, size: 16, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text('${recipe.cookingTime} min'),
                          const SizedBox(width: 16),
                          const Icon(Icons.restaurant, size: 16, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text('${recipe.servings} servings'),
                        ],
                      ),
                      if (recipe.description != null) ...[
                        const SizedBox(height: 12),
                        Text(recipe.description!, style: const TextStyle(color: AppColors.textMuted)),
                      ],
                      const SizedBox(height: 24),
                      const Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...recipe.ingredients.map((ing) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Text(ing.required ? '•' : '◦', style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${ing.quantity} ${ing.unit} ${_capitalize(ing.name)}'
                                    '${ing.required ? '' : '  (optional)'}',
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 24),
                      const Text('Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...recipe.instructions.asMap().entries.map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 13,
                                  backgroundColor: AppColors.primary,
                                  child: Text('${entry.key + 1}',
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: Text(entry.value)),
                              ],
                            ),
                          )),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
