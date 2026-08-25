/// One ingredient a recipe needs.
class RecipeIngredient {
  final String name;
  final String icon; // emoji shown in the round icon chip
  final num quantity;
  final String unit;
  final bool required;

  const RecipeIngredient({
    required this.name,
    required this.icon,
    required this.quantity,
    required this.unit,
    this.required = true,
  });
}

/// A full recipe, including everything needed for both the results list
/// and the detail screen. All data lives in memory — no backend.
class Recipe {
  final int id;
  final String name;
  final String imageUrl;
  final String category;
  final int cookingTimeMinutes;
  final int calories;
  final int servings;
  final String difficulty;
  final double rating;
  final List<RecipeIngredient> ingredients;
  final List<String> instructions;

  const Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.cookingTimeMinutes,
    required this.calories,
    required this.servings,
    required this.difficulty,
    required this.rating,
    required this.ingredients,
    required this.instructions,
  });
}

/// One ingredient sitting in the user's kitchen.
class KitchenItem {
  final String name; // matched against Recipe ingredient names, case-insensitive
  final String icon;
  final String category;
  final num quantity;
  final String unit;

  const KitchenItem({
    required this.name,
    required this.icon,
    required this.category,
    this.quantity = 1,
    this.unit = 'pieces',
  });

  String get key => name.toLowerCase().trim();
}

/// Result of matching one recipe against the current kitchen.
class RecipeMatchResult {
  final Recipe recipe;
  final int matchPercentage;
  final int haveCount;
  final int totalCount;
  final List<RecipeIngredient> missing;

  const RecipeMatchResult({
    required this.recipe,
    required this.matchPercentage,
    required this.haveCount,
    required this.totalCount,
    required this.missing,
  });
}