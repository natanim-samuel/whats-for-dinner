import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/models.dart';
import '../../../core/data/mock_recipes.dart';
import '../../kitchen/providers/kitchen_provider.dart';

/// Ingredient matching, computed locally — no network round trip.
///
/// Required ingredients are weighted 3x an optional one, so a recipe
/// missing only a garnish still scores well, but one missing a core
/// ingredient never outranks a recipe that's just short on optional items.
RecipeMatchResult _matchRecipe(Recipe recipe, Set<String> haveKeys) {
  const requiredWeight = 3;
  const optionalWeight = 1;

  int totalWeight = 0;
  int matchedWeight = 0;
  int haveCount = 0;
  final missing = <RecipeIngredient>[];

  for (final ingredient in recipe.ingredients) {
    final weight = ingredient.required ? requiredWeight : optionalWeight;
    totalWeight += weight;
    final key = ingredient.name.toLowerCase().trim();

    if (haveKeys.contains(key)) {
      matchedWeight += weight;
      haveCount++;
    } else {
      missing.add(ingredient);
    }
  }

  final percentage = totalWeight == 0 ? 0 : ((matchedWeight / totalWeight) * 100).round();

  return RecipeMatchResult(
    recipe: recipe,
    matchPercentage: percentage,
    haveCount: haveCount,
    totalCount: recipe.ingredients.length,
    missing: missing,
  );
}

/// All recipes, ranked by match against the current kitchen — recomputes
/// automatically whenever the kitchen changes.
final dinnerMatchesProvider = Provider<List<RecipeMatchResult>>((ref) {
  final kitchen = ref.watch(kitchenProvider);
  final haveKeys = kitchen.map((i) => i.key).toSet();

  final results = mockRecipes.map((r) => _matchRecipe(r, haveKeys)).toList();
  results.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));
  return results;
});

/// Single recipe lookup by id, for the detail screen.
final recipeByIdProvider = Provider.family<Recipe, int>((ref, id) {
  return mockRecipes.firstWhere((r) => r.id == id);
});