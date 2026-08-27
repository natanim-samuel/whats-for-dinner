import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stores the IDs of recipes bookmarked by the user.
///
/// This is currently kept in memory.
/// Later we can connect this to SharedPreferences or a backend
/// so bookmarks survive app restarts.
class FavoritesNotifier extends StateNotifier<Set<int>> {
  FavoritesNotifier() : super(<int>{});

  /// Check whether a recipe is bookmarked.
  bool isFavorite(int recipeId) {
    return state.contains(recipeId);
  }

  /// Toggle bookmark status.
  void toggleFavorite(int recipeId) {
    final updated = Set<int>.from(state);

    if (updated.contains(recipeId)) {
      updated.remove(recipeId);
    } else {
      updated.add(recipeId);
    }

    state = updated;
  }

  /// Add a recipe to bookmarks.
  void addFavorite(int recipeId) {
    if (!state.contains(recipeId)) {
      state = {...state, recipeId};
    }
  }

  /// Remove a recipe from bookmarks.
  void removeFavorite(int recipeId) {
    if (state.contains(recipeId)) {
      final updated = Set<int>.from(state);
      updated.remove(recipeId);
      state = updated;
    }
  }

  /// Remove all bookmarks.
  void clearFavorites() {
    state = <int>{};
  }
}

final favoritesProvider =
StateNotifierProvider<FavoritesNotifier, Set<int>>(
      (ref) => FavoritesNotifier(),
);

/// Number of bookmarked recipes.
final favoriteCountProvider = Provider<int>((ref) {
  return ref.watch(favoritesProvider).length;
});