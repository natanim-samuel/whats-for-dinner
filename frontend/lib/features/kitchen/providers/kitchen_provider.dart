import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/models.dart';

/// The user's kitchen, held entirely in memory. No backend, no persistence
/// (yet) — this is deliberately simple for the offline MVP.
class KitchenNotifier extends StateNotifier<List<KitchenItem>> {
  KitchenNotifier() : super(_starterItems);

  static const _starterItems = <KitchenItem>[
    KitchenItem(name: 'Egg', icon: '🥚', category: 'Protein', quantity: 6, unit: 'pcs'),
    KitchenItem(name: 'Onion', icon: '🧅', category: 'Vegetables', quantity: 2, unit: 'pcs'),
    KitchenItem(name: 'Garlic', icon: '🧄', category: 'Vegetables', quantity: 1, unit: 'head'),
    KitchenItem(name: 'Rice', icon: '🍚', category: 'Grains', quantity: 1, unit: 'kg'),
  ];

  void addItem(KitchenItem item) {
    final existingIndex = state.indexWhere((i) => i.key == item.key);
    if (existingIndex >= 0) {
      final updated = [...state];
      updated[existingIndex] = item;
      state = updated;
    } else {
      state = [...state, item];
    }
  }

  void removeItem(String name) {
    state = state.where((i) => i.key != name.toLowerCase().trim()).toList();
  }

  Set<String> get keys => state.map((i) => i.key).toSet();
}

final kitchenProvider = StateNotifierProvider<KitchenNotifier, List<KitchenItem>>(
      (ref) => KitchenNotifier(),
);

/// Just the set of ingredient keys currently in the kitchen — handy for
/// screens (like recipe detail) that only need fast lookups, not the full list.
final kitchenProviderKeysProvider = Provider<Set<String>>((ref) {
  return ref.watch(kitchenProvider).map((i) => i.key).toSet();
});