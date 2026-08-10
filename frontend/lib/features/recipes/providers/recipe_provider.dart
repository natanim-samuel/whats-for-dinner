import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../kitchen/providers/kitchen_provider.dart';
import '../models/recipe.dart';

/// Fetches recipe matches for the current kitchen contents on demand
/// (triggered by the "Find Dinner" button).
class DinnerMatchNotifier extends StateNotifier<AsyncValue<List<RecipeMatch>>> {
  final ApiClient _api;
  DinnerMatchNotifier(this._api) : super(const AsyncValue.data([]));

  Future<void> findDinner(List<int> ingredientIds) async {
    if (ingredientIds.isEmpty) {
      state = AsyncValue.error('Add some ingredients to your kitchen first.', StackTrace.current);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final response = await _api.post('/recipes/match', {'ingredientIds': ingredientIds});
      final matches = (response['recipes'] as List)
          .map((e) => RecipeMatch.fromJson(e as Map<String, dynamic>))
          .toList();
      state = AsyncValue.data(matches);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final dinnerMatchProvider =
    StateNotifierProvider<DinnerMatchNotifier, AsyncValue<List<RecipeMatch>>>(
  (ref) => DinnerMatchNotifier(ref.watch(apiClientProvider)),
);

/// Fetches a single recipe's full detail (ingredients + instructions) by id.
final recipeDetailProvider = FutureProvider.family<RecipeDetail, int>((ref, id) async {
  final api = ref.watch(apiClientProvider);
  final response = await api.get('/recipes/$id');
  return RecipeDetail.fromJson(response['recipe'] as Map<String, dynamic>);
});
