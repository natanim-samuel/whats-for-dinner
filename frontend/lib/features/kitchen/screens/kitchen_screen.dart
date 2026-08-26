import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/kitchen_provider.dart';

class KitchenScreen extends ConsumerWidget {
  const KitchenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(kitchenProvider);

    final byCategory = <String, List<KitchenItem>>{};

    for (final item in items) {
      byCategory.putIfAbsent(item.category, () => []).add(item);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Kitchen'),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddIngredientSheet(context),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textDark,
        icon: const Icon(Icons.add),
        label: const Text('Add Ingredient'),
      ),

      body: items.isEmpty
          ? const _EmptyKitchen()
          : ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          100,
        ),
        children: byCategory.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                ...entry.value.map(
                      (item) => _IngredientTile(
                    item: item,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showAddIngredientSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddIngredientSheet(),
    );
  }
}

class _EmptyKitchen extends StatelessWidget {
  const _EmptyKitchen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🥕',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              'Your kitchen is empty.\n'
                  'Add a few ingredients to get started.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientTile extends ConsumerWidget {
  final KitchenItem item;

  const _IngredientTile({
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest,
          child: Text(
            item.icon,
            style: const TextStyle(fontSize: 18),
          ),
        ),

        title: Text(
          item.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Text(
          '${_formatQuantity(item.quantity)} ${item.unit}',
        ),

        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref
                .read(kitchenProvider.notifier)
                .removeItem(item.name);
          },
        ),
      ),
    );
  }

  String _formatQuantity(num value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }
}

class _AddIngredientSheet extends ConsumerStatefulWidget {
  const _AddIngredientSheet();

  @override
  ConsumerState<_AddIngredientSheet> createState() =>
      _AddIngredientSheetState();
}

class _AddIngredientSheetState
    extends ConsumerState<_AddIngredientSheet> {
  final _quantityController =
  TextEditingController(text: '1');

  IngredientOption? _selectedIngredient;

  double get _quantity {
    return double.tryParse(
      _quantityController.text.trim(),
    ) ??
        1;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + bottomInset,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.25),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Add Ingredient',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Start typing and select an ingredient.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),

            const SizedBox(height: 20),

            _buildIngredientAutocomplete(context),

            if (_selectedIngredient != null) ...[
              const SizedBox(height: 20),
              _buildSelectedIngredient(context),
              const SizedBox(height: 20),
              _buildQuantityField(context),
              const SizedBox(height: 20),
              _buildAddButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientAutocomplete(
      BuildContext context,
      ) {
    return Autocomplete<IngredientOption>(
      displayStringForOption: (option) => option.name,

      optionsBuilder: (
          TextEditingValue textEditingValue,
          ) {
        final query =
        textEditingValue.text.trim().toLowerCase();

        if (query.isEmpty) {
          return ingredientOptions;
        }

        return ingredientOptions.where(
              (ingredient) =>
              ingredient.name
                  .toLowerCase()
                  .contains(query),
        );
      },

      onSelected: (IngredientOption option) {
        setState(() {
          _selectedIngredient = option;
        });
      },

      fieldViewBuilder: (
          context,
          controller,
          focusNode,
          onFieldSubmitted,
          ) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Ingredient',
            hintText: 'e.g. chicken, tomato, rice...',
            prefixIcon: const Icon(
              Icons.search,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller.clear();

                setState(() {
                  _selectedIngredient = null;
                });
              },
            )
                : null,
          ),

          onChanged: (_) {
            setState(() {});
          },
        );
      },

      optionsViewBuilder: (
          context,
          onSelected,
          options,
          ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 8,
            borderRadius:
            BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 280,
                maxWidth: 500,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (
                    context,
                    index,
                    ) {
                  final option =
                  options.elementAt(index);

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        option.icon,
                      ),
                    ),

                    title: Text(
                      option.name,
                    ),

                    subtitle: Text(
                      '${option.category} • '
                          '${option.defaultUnit}',
                    ),

                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedIngredient(
      BuildContext context,
      ) {
    final ingredient =
    _selectedIngredient!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer,
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            ingredient.icon,
            style: const TextStyle(
              fontSize: 30,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  ingredient.category,
                ),
              ],
            ),
          ),

          const Icon(
            Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityField(
      BuildContext context,
      ) {
    final ingredient =
    _selectedIngredient!;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _quantityController,
            keyboardType:
            const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Quantity',
              prefixIcon:
              Icon(Icons.numbers),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest,
            borderRadius:
            BorderRadius.circular(14),
          ),
          child: Text(
            ingredient.defaultUnit,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(
      BuildContext context,
      ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          final ingredient =
              _selectedIngredient;

          if (ingredient == null) {
            return;
          }

          final quantity = _quantity;

          if (quantity <= 0) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'Please enter a valid quantity.',
                ),
              ),
            );

            return;
          }

          final item = KitchenItem(
            name: ingredient.name,
            icon: ingredient.icon,
            category: ingredient.category,
            quantity: quantity,
            unit: ingredient.defaultUnit,
          );

          ref
              .read(kitchenProvider.notifier)
              .addItem(item);

          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.add),
        label: const Text(
          'Add to My Kitchen',
        ),
      ),
    );
  }
}