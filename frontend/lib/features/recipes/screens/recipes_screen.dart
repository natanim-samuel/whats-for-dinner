import 'package:flutter/material.dart';

import '../../../core/data/mock_recipes.dart';
import '../../../core/data/models.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipes = mockRecipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Recipes 🍽️'),
      ),
      body: recipes.isEmpty
          ? const Center(
        child: Text('No recipes available'),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final Recipe recipe = recipes[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),

              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  recipe.imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      width: 70,
                      height: 70,
                      child: Icon(Icons.restaurant),
                    );
                  },
                ),
              ),

              title: Text(recipe.name),

              subtitle: Text(
                '${recipe.category} • '
                    '${recipe.cookingTimeMinutes} min • '
                    '⭐ ${recipe.rating}',
              ),

              trailing: const Icon(
                Icons.chevron_right,
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(recipeId: recipe.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
