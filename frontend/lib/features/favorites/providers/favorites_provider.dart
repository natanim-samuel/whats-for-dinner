import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _favoritesKey = 'favorite_recipe_ids';

class FavoritesNotifier extends StateNotifier<Set<int>> {
  FavoritesNotifier() : super(<int>{}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final savedIds = prefs.getStringList(_favoritesKey) ?? <String>[];

    state = savedIds
        .map(int.tryParse)
        .whereType<int>()
        .toSet();
  }

  Future<void> toggleFavorite(int recipeId) async {
    final updated = Set<int>.from(state);

    if (updated.contains(recipeId)) {
      updated.remove(recipeId);
    } else {
      updated.add(recipeId);
    }

    // Update UI immediately.
    state = updated;

    // Save permanently.
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      _favoritesKey,
      updated.map((id) => id.toString()).toList(),
    );
  }

  bool isFavorite(int recipeId) {
    return state.contains(recipeId);
  }

  Future<void> clearFavorites() async {
    state = <int>{};

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_favoritesKey);
  }
}

final favoritesProvider =
StateNotifierProvider<FavoritesNotifier, Set<int>>(
      (ref) => FavoritesNotifier(),
);

final favoriteCountProvider = Provider<int>((ref) {
  return ref.watch(favoritesProvider).length;
});