import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/data/models.dart';

/// Common ingredients that the user can select from.
class IngredientOption {
  final String name;
  final String icon;
  final String category;
  final String defaultUnit;

  const IngredientOption({
    required this.name,
    required this.icon,
    required this.category,
    required this.defaultUnit,
  });
}

/// Standard ingredient list used by autocomplete.
const ingredientOptions = <IngredientOption>[
  // Protein
  IngredientOption(
    name: 'Chicken',
    icon: '🍗',
    category: 'Protein',
    defaultUnit: 'pieces',
  ),
  IngredientOption(
    name: 'Chicken breast',
    icon: '🍗',
    category: 'Protein',
    defaultUnit: 'pieces',
  ),
  IngredientOption(
    name: 'Beef',
    icon: '🥩',
    category: 'Protein',
    defaultUnit: 'kg',
  ),
  IngredientOption(
    name: 'Lamb',
    icon: '🍖',
    category: 'Protein',
    defaultUnit: 'kg',
  ),
  IngredientOption(
    name: 'Egg',
    icon: '🥚',
    category: 'Protein',
    defaultUnit: 'pieces',
  ),
  IngredientOption(
    name: 'Fish',
    icon: '🐟',
    category: 'Protein',
    defaultUnit: 'pieces',
  ),
  IngredientOption(
    name: 'Tuna',
    icon: '🐟',
    category: 'Protein',
    defaultUnit: 'can',
  ),
  IngredientOption(
    name: 'Chickpeas',
    icon: '🫘',
    category: 'Protein',
    defaultUnit: 'cup',
  ),

  // Vegetables
  IngredientOption(
    name: 'Tomato',
    icon: '🍅',
    category: 'Vegetables',
    defaultUnit: 'pieces',
  ),
  IngredientOption(
    name: 'Onion',
    icon: '🧅',
    category: 'Vegetables',
    defaultUnit: 'pieces',
  ),
  IngredientOption(
    name: 'Garlic',
    icon: '🧄',
    category: 'Vegetables',
    defaultUnit: 'cloves',
  ),
  IngredientOption(
    name: 'Potato',
    icon: '🥔',
    category: 'Vegetables',
    defaultUnit: 'pieces',
  ),
  IngredientOption(
    name: 'Carrot',
    icon: '🥕',
    category: 'Vegetables',
    defaultUnit: 'pieces',
  ),
  IngredientOption(
    name: 'Cabbage',
    icon: '🥬',
    category: 'Vegetables',
    defaultUnit: 'head',
  ),
  IngredientOption(
    name: 'Spinach',
    icon: '🥬',
    category: 'Vegetables',
    defaultUnit: 'g',
  ),
  IngredientOption(
    name: 'Lettuce',
    icon: '🥬',
    category: 'Vegetables',
    defaultUnit: 'head',
  ),
  IngredientOption(
    name: 'Romaine lettuce',
    icon: '🥬',
    category: 'Vegetables',
    defaultUnit: 'head',
  ),
  IngredientOption(
    name: 'Green pepper',
    icon: '🫑',
    category: 'Vegetables',
    defaultUnit: 'pieces',
  ),
  IngredientOption(
    name: 'Bell pepper',
    icon: '🫑',
    category: 'Vegetables',
    defaultUnit: 'pieces',
  ),
  IngredientOption(
    name: 'Green onion',
    icon: '🌱',
    category: 'Vegetables',
    defaultUnit: 'pieces',
  ),

  // Grains
  IngredientOption(
    name: 'Rice',
    icon: '🍚',
    category: 'Grains',
    defaultUnit: 'cup',
  ),
  IngredientOption(
    name: 'Pasta',
    icon: '🍝',
    category: 'Grains',
    defaultUnit: 'g',
  ),
  IngredientOption(
    name: 'Bread',
    icon: '🍞',
    category: 'Grains',
    defaultUnit: 'pieces',
  ),
  IngredientOption(
    name: 'Ciabatta loaf',
    icon: '🍞',
    category: 'Grains',
    defaultUnit: 'pieces',
  ),
  IngredientOption(
    name: 'Flour',
    icon: '🌾',
    category: 'Grains',
    defaultUnit: 'cup',
  ),
  IngredientOption(
    name: 'Oats',
    icon: '🌾',
    category: 'Grains',
    defaultUnit: 'cup',
  ),

  // Dairy
  IngredientOption(
    name: 'Milk',
    icon: '🥛',
    category: 'Dairy',
    defaultUnit: 'ml',
  ),
  IngredientOption(
    name: 'Butter',
    icon: '🧈',
    category: 'Dairy',
    defaultUnit: 'tbsp',
  ),
  IngredientOption(
    name: 'Cheese',
    icon: '🧀',
    category: 'Dairy',
    defaultUnit: 'g',
  ),
  IngredientOption(
    name: 'Parmesan cheese',
    icon: '🧀',
    category: 'Dairy',
    defaultUnit: 'cup',
  ),
  IngredientOption(
    name: 'Yogurt',
    icon: '🥛',
    category: 'Dairy',
    defaultUnit: 'cup',
  ),

  // Pantry
  IngredientOption(
    name: 'Olive oil',
    icon: '🫒',
    category: 'Other',
    defaultUnit: 'tbsp',
  ),
  IngredientOption(
    name: 'Vegetable oil',
    icon: '🫗',
    category: 'Other',
    defaultUnit: 'tbsp',
  ),
  IngredientOption(
    name: 'Soy sauce',
    icon: '🥢',
    category: 'Other',
    defaultUnit: 'tbsp',
  ),
  IngredientOption(
    name: 'Salt',
    icon: '🧂',
    category: 'Other',
    defaultUnit: 'tsp',
  ),
  IngredientOption(
    name: 'Black pepper',
    icon: '🌶️',
    category: 'Other',
    defaultUnit: 'tsp',
  ),
  IngredientOption(
    name: 'Berbere',
    icon: '🌶️',
    category: 'Spices',
    defaultUnit: 'tbsp',
  ),
];

class KitchenNotifier extends StateNotifier<List<KitchenItem>> {
  static const _storageKey = 'kitchen_items';

  KitchenNotifier() : super([]) {
    _loadItems();
  }

  // --------------------------------------------------------------
  // LOAD
  // --------------------------------------------------------------

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();

    final savedItems = prefs.getStringList(_storageKey);

    if (savedItems == null) {
      // First launch only.
      state = _starterItems;
      await _saveItems();
      return;
    }

    try {
      state = savedItems
          .map(
            (jsonString) => KitchenItem.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>,
        ),
      )
          .toList();
    } catch (_) {
      state = [];
    }
  }

  // --------------------------------------------------------------
  // SAVE
  // --------------------------------------------------------------

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = state
        .map(
          (item) => jsonEncode(item.toJson()),
    )
        .toList();

    await prefs.setStringList(
      _storageKey,
      encoded,
    );
  }

  // --------------------------------------------------------------
  // STARTER INGREDIENTS
  // --------------------------------------------------------------

  static const _starterItems = <KitchenItem>[
    KitchenItem(
      name: 'Chicken',
      icon: '🍗',
      category: 'Protein',
      quantity: 2,
      unit: 'pieces',
    ),
    KitchenItem(
      name: 'Egg',
      icon: '🥚',
      category: 'Protein',
      quantity: 6,
      unit: 'pieces',
    ),
    KitchenItem(
      name: 'Tomato',
      icon: '🍅',
      category: 'Vegetables',
      quantity: 3,
      unit: 'pieces',
    ),
    KitchenItem(
      name: 'Onion',
      icon: '🧅',
      category: 'Vegetables',
      quantity: 2,
      unit: 'pieces',
    ),
    KitchenItem(
      name: 'Rice',
      icon: '🍚',
      category: 'Grains',
      quantity: 2,
      unit: 'cup',
    ),
  ];

  // --------------------------------------------------------------
  // ADD
  // --------------------------------------------------------------

  Future<void> addItem(KitchenItem item) async {
    final index = state.indexWhere(
          (existing) =>
      existing.name.toLowerCase() ==
          item.name.toLowerCase(),
    );

    if (index == -1) {
      state = [...state, item];
      await _saveItems();
      return;
    }

    final existing = state[index];

    final updated = KitchenItem(
      name: existing.name,
      icon: existing.icon,
      category: existing.category,
      quantity: existing.quantity + item.quantity,
      unit: existing.unit,
    );

    final newState = [...state];
    newState[index] = updated;

    state = newState;

    await _saveItems();
  }

  // --------------------------------------------------------------
  // REMOVE
  // --------------------------------------------------------------

  Future<void> removeItem(String name) async {
    state = state
        .where(
          (item) =>
      item.name.toLowerCase() !=
          name.toLowerCase(),
    )
        .toList();

    await _saveItems();
  }

  // --------------------------------------------------------------
  // CLEAR
  // --------------------------------------------------------------

  Future<void> clearKitchen() async {
    state = [];
    await _saveItems();
  }
}

final kitchenProvider =
StateNotifierProvider<KitchenNotifier, List<KitchenItem>>(
      (ref) => KitchenNotifier(),
);