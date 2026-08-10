import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../models/kitchen_ingredient.dart';
import '../providers/kitchen_provider.dart';

class KitchenScreen extends ConsumerWidget {
  const KitchenScreen({super.key});

  static const categoryIcons = {
    'Vegetables': '🥬',
    'Protein': '🥩',
    'Grains': '🌾',
    'Other': '🧂',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kitchenAsync = ref.watch(kitchenProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Kitchen')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddIngredientSheet(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Ingredient', style: TextStyle(color: Colors.white)),
      ),
      body: kitchenAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 40, color: AppColors.textMuted),
                const SizedBox(height: 12),
                Text('Could not load your kitchen.\n$err', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.read(kitchenProvider.notifier).fetchKitchen(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('🥕', style: TextStyle(fontSize: 48)),
                    SizedBox(height: 12),
                    Text(
                      'Your kitchen is empty.\nAdd a few ingredients to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            );
          }

          final byCategory = <String, List<KitchenIngredient>>{};
          for (final item in items) {
            byCategory.putIfAbsent(item.category, () => []).add(item);
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: byCategory.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${categoryIcons[entry.key] ?? '🧂'}  ${entry.key}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    ...entry.value.map((ingredient) => _IngredientTile(ingredient: ingredient)),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showAddIngredientSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddIngredientSheet(),
    );
  }
}

class _IngredientTile extends ConsumerWidget {
  final KitchenIngredient ingredient;
  const _IngredientTile({required this.ingredient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(_capitalize(ingredient.name)),
        subtitle: Text('${ingredient.quantity} ${ingredient.unit}'),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textMuted),
          onPressed: () => ref.read(kitchenProvider.notifier).removeIngredient(ingredient.ingredientId),
        ),
      ),
    );
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _AddIngredientSheet extends ConsumerStatefulWidget {
  const _AddIngredientSheet();

  @override
  ConsumerState<_AddIngredientSheet> createState() => _AddIngredientSheetState();
}

class _AddIngredientSheetState extends ConsumerState<_AddIngredientSheet> {
  final _nameController = TextEditingController();
  String _category = 'Vegetables';
  double _quantity = 1;
  String _unit = 'pieces';
  bool _saving = false;

  static const categories = ['Vegetables', 'Protein', 'Grains', 'Other'];
  static const units = ['pieces', 'cup', 'g', 'kg', 'tbsp', 'tsp', 'lb', 'ml'];

  static const quickAdd = [
    'Tomato', 'Onion', 'Garlic', 'Egg', 'Rice', 'Chicken', 'Pasta', 'Potato',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add Ingredient', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'e.g. Tomato'),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: quickAdd.map((name) {
              return ActionChip(
                label: Text(name),
                onPressed: () => setState(() => _nameController.text = name),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _unit,
                  decoration: const InputDecoration(labelText: 'Unit'),
                  items: units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (v) => setState(() => _unit = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Quantity'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => setState(() => _quantity = (_quantity - 1).clamp(1, 999)),
              ),
              Text(_quantity.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => setState(() => _quantity += 1),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      height: 18, width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(kitchenProvider.notifier).addIngredient(
            name: name,
            category: _category,
            quantity: _quantity,
            unit: _unit,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not add ingredient: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
