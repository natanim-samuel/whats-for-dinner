import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models.dart';
import '../../../core/theme/app_theme.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../providers/recipe_provider.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<RecipesScreen> createState() =>
      _RecipesScreenState();
}

class _RecipesScreenState
    extends ConsumerState<RecipesScreen> {
  bool _showBookmarkedOnly = false;

  @override
  Widget build(BuildContext context) {
    final allRecipes = mockRecipes;
    final bookmarkedRecipes =
    ref.watch(favoriteRecipesProvider);

    final recipes = _showBookmarkedOnly
        ? bookmarkedRecipes
        : allRecipes;

    final favoriteCount =
    ref.watch(favoriteCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes 🍽️'),
      ),

      body: Column(
        children: [
          // ------------------------------------------------------
          // FILTER TABS
          // ------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              12,
              16,
              4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _RecipeFilterButton(
                    icon: Icons.restaurant_menu,
                    label: 'All Recipes',
                    selected: !_showBookmarkedOnly,
                    onTap: () {
                      setState(() {
                        _showBookmarkedOnly = false;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _RecipeFilterButton(
                    icon: Icons.bookmark,
                    label: 'Bookmarked',
                    count: favoriteCount,
                    selected: _showBookmarkedOnly,
                    onTap: () {
                      setState(() {
                        _showBookmarkedOnly = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // ------------------------------------------------------
          // CONTENT
          // ------------------------------------------------------
          Expanded(
            child: recipes.isEmpty
                ? const _EmptyFavorites()
                : ListView.builder(
              padding:
              const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                24,
              ),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return _RecipeCard(
                  recipe: recipes[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FILTER BUTTON
// ============================================================

class _RecipeFilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? count;
  final bool selected;
  final VoidCallback onTap;

  const _RecipeFilterButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent
              : AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? AppColors.textDark
                  : AppColors.textLightMuted,
            ),

            const SizedBox(width: 7),

            Text(
              label,
              style: TextStyle(
                color: selected
                    ? AppColors.textDark
                    : AppColors.textLight,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),

            if (count != null) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.textDark
                      : AppColors.accent,
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: selected
                        ? AppColors.accent
                        : AppColors.textDark,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// RECIPE CARD
// ============================================================

class _RecipeCard extends ConsumerWidget {
  final Recipe recipe;

  const _RecipeCard({
    required this.recipe,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(
      favoritesProvider.select(
            (favorites) => favorites.contains(recipe.id),
      ),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding:
        const EdgeInsets.all(10),

        // IMAGE
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            recipe.imageUrl,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) {
              return Container(
                width: 70,
                height: 70,
                color:
                AppColors.backgroundElevated,
                child: const Icon(
                  Icons.restaurant,
                  color: AppColors.accent,
                ),
              );
            },
          ),
        ),

        // TEXT
        title: Text(
          recipe.name,
          style: const TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Padding(
          padding:
          const EdgeInsets.only(top: 5),
          child: Text(
            '${recipe.category} • '
                '${recipe.cookingTimeMinutes} min • '
                '⭐ ${recipe.rating}',
            style: const TextStyle(
              color: AppColors.textLightMuted,
              fontSize: 12,
            ),
          ),
        ),

        // BOOKMARK + ARROW
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color: isFavorite
                    ? AppColors.accent
                    : AppColors.textLightMuted,
              ),
              onPressed: () {
                ref
                    .read(
                  favoritesProvider.notifier,
                )
                    .toggleFavorite(recipe.id);
              },
            ),

            const Icon(
              Icons.chevron_right,
              color: AppColors.textLightMuted,
            ),
          ],
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  RecipeDetailScreen(
                    recipeId: recipe.id,
                  ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// EMPTY FAVORITES
// ============================================================

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 70,
              color: AppColors.accent,
            ),

            const SizedBox(height: 18),

            const Text(
              'No bookmarked recipes',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Save recipes you love and they will '
                  'appear here for easy access.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textLightMuted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}