import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models.dart';
import '../../../core/data/mock_recipes.dart';
import '../../kitchen/providers/kitchen_provider.dart';
import '../../favorites/providers/favorites_provider.dart';

/// Ingredient matching, computed locally.
///
/// Required ingredients are weighted more heavily than optional
/// ingredients so that missing an optional garnish does not hurt
/// the recipe's score too much.
RecipeMatchResult _matchRecipe(
    Recipe recipe,
    Set<String> haveKeys,
    ) {
  const requiredWeight = 3;
  const optionalWeight = 1;

  int totalWeight = 0;
  int matchedWeight = 0;
  int haveCount = 0;

  final missing = <RecipeIngredient>[];

  for (final ingredient in recipe.ingredients) {
    final weight =
    ingredient.required ? requiredWeight : optionalWeight;

    totalWeight += weight;

    final key = ingredient.name.toLowerCase().trim();

    if (haveKeys.contains(key)) {
      matchedWeight += weight;
      haveCount++;
    } else {
      missing.add(ingredient);
    }
  }

  final percentage = totalWeight == 0
      ? 0
      : ((matchedWeight / totalWeight) * 100).round();

  return RecipeMatchResult(
    recipe: recipe,
    matchPercentage: percentage,
    haveCount: haveCount,
    totalCount: recipe.ingredients.length,
    missing: missing,
  );
}

/// All recipes ranked according to the ingredients
/// currently available in the kitchen.
final dinnerMatchesProvider =
Provider<List<RecipeMatchResult>>((ref) {
  final kitchen = ref.watch(kitchenProvider);

  final haveKeys = kitchen
      .map((item) => item.key)
      .toSet();

  final results = mockRecipes
      .map((recipe) => _matchRecipe(recipe, haveKeys))
      .toList();

  results.sort(
        (a, b) =>
        b.matchPercentage.compareTo(a.matchPercentage),
  );

  return results;
});

/// Returns a recipe by ID.
final recipeByIdProvider =
Provider.family<Recipe, int>((ref, id) {
  return mockRecipes.firstWhere(
        (recipe) => recipe.id == id,
  );
});

/// All bookmarked recipes.
///
/// The list follows the same order as mockRecipes.
final favoriteRecipesProvider =
Provider<List<Recipe>>((ref) {
  final favoriteIds = ref.watch(favoritesProvider);

  return mockRecipes
      .where((recipe) => favoriteIds.contains(recipe.id))
      .toList();
});

/// Bookmarked dinner matches.
///
/// This is useful for the "Find Dinner → Bookmarked Only"
/// mode.
final favoriteDinnerMatchesProvider =
Provider<List<RecipeMatchResult>>((ref) {
  final favoriteIds = ref.watch(favoritesProvider);

  final matches = ref.watch(dinnerMatchesProvider);

  return matches
      .where(
        (match) => favoriteIds.contains(match.recipe.id),
  )
      .toList();
});