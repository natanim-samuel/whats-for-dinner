class RecipeMatch {
  final int id;
  final String name;
  final String? imageUrl;
  final int cookingTime;
  final String difficulty;
  final num rating;
  final int matchPercentage;
  final int haveCount;
  final int totalCount;

  RecipeMatch({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.cookingTime,
    required this.difficulty,
    required this.rating,
    required this.matchPercentage,
    required this.haveCount,
    required this.totalCount,
  });

  factory RecipeMatch.fromJson(Map<String, dynamic> json) {
    return RecipeMatch(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      cookingTime: json['cooking_time'] as int? ?? 0,
      difficulty: json['difficulty'] as String? ?? 'Easy',
      rating: json['rating'] ?? 0,
      matchPercentage: json['matchPercentage'] as int? ?? 0,
      haveCount: json['haveCount'] as int? ?? 0,
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }
}

class RecipeIngredientDetail {
  final int ingredientId;
  final String name;
  final num quantity;
  final String unit;
  final bool required;

  RecipeIngredientDetail({
    required this.ingredientId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.required,
  });

  factory RecipeIngredientDetail.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientDetail(
      ingredientId: json['ingredient_id'] as int,
      name: json['name'] as String,
      quantity: json['quantity'] ?? 1,
      unit: json['unit'] as String? ?? 'pieces',
      required: json['required'] as bool? ?? true,
    );
  }
}

class RecipeDetail {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int cookingTime;
  final String difficulty;
  final int servings;
  final num rating;
  final List<String> instructions;
  final List<RecipeIngredientDetail> ingredients;

  RecipeDetail({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.cookingTime,
    required this.difficulty,
    required this.servings,
    required this.rating,
    required this.instructions,
    required this.ingredients,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    return RecipeDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      cookingTime: json['cooking_time'] as int? ?? 0,
      difficulty: json['difficulty'] as String? ?? 'Easy',
      servings: json['servings'] as int? ?? 2,
      rating: json['rating'] ?? 0,
      instructions: (json['instructions'] as List).map((e) => e.toString()).toList(),
      ingredients: (json['ingredients'] as List)
          .map((e) => RecipeIngredientDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
