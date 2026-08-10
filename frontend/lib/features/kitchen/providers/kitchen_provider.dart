import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../models/kitchen_ingredient.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

/// Holds the user's current kitchen contents and talks to the backend.
class KitchenNotifier extends StateNotifier<AsyncValue<List<KitchenIngredient>>> {
  final ApiClient _api;
  KitchenNotifier(this._api) : super(const AsyncValue.loading()) {
    fetchKitchen();
  }

  Future<void> fetchKitchen() async {
    state = const AsyncValue.loading();
    try {
      final response = await _api.get('/kitchen');
      final items = (response['kitchen'] as List)
          .map((e) => KitchenIngredient.fromJson(e as Map<String, dynamic>))
          .toList();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addIngredient({
    required String name,
    String category = 'Other',
    num quantity = 1,
    String unit = 'pieces',
    String? expirationDate,
  }) async {
    await _api.post('/kitchen', {
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      if (expirationDate != null) 'expirationDate': expirationDate,
    });
    await fetchKitchen();
  }

  Future<void> removeIngredient(int ingredientId) async {
    await _api.delete('/kitchen/$ingredientId');
    await fetchKitchen();
  }

  /// All ingredient IDs currently in the kitchen — used to request matches.
  List<int> get ingredientIds =>
      state.value?.map((e) => e.ingredientId).toList() ?? [];
}

final kitchenProvider =
    StateNotifierProvider<KitchenNotifier, AsyncValue<List<KitchenIngredient>>>(
  (ref) => KitchenNotifier(ref.watch(apiClientProvider)),
);
