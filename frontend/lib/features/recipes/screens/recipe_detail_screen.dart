import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/models.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/recipe_provider.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final int recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final recipe = ref.watch(recipeByIdProvider(widget.recipeId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopBar(onSave: () => setState(() => _saved = !_saved), saved: _saved),
              const SizedBox(height: 12),
              _RecipeImage(imageUrl: recipe.imageUrl),
              const SizedBox(height: 20),
              Text(recipe.name,
                  style: const TextStyle(
                      color: AppColors.textLight, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _MetaRow(recipe: recipe),
              const SizedBox(height: 20),
              _IngredientChipsRow(ingredients: recipe.ingredients),
              const SizedBox(height: 24),
              const Text('Ingredients',
                  style: TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _IngredientListCard(ingredients: recipe.ingredients),
              const SizedBox(height: 24),
              const Text('Instructions',
                  style: TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...recipe.instructions.asMap().entries.map(
                    (entry) => _InstructionStep(number: entry.key + 1, text: entry.value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onSave;
  final bool saved;
  const _TopBar({required this.onSave, required this.saved});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _RoundIconButton(icon: Icons.arrow_back, onTap: () => Navigator.of(context).pop()),
        _RoundIconButton(
          icon: saved ? Icons.star : Icons.star_border,
          iconColor: saved ? AppColors.accent : AppColors.textLight,
          onTap: onSave,
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  const _RoundIconButton({required this.icon, required this.onTap, this.iconColor = AppColors.textLight});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  final String imageUrl;
  const _RecipeImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: Image.network(
          '$imageUrl?w=800&q=70',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.backgroundElevated,
            child: const Icon(Icons.restaurant, color: AppColors.accent, size: 40),
          ),
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final Recipe recipe;
  const _MetaRow({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetaItem(icon: Icons.access_time, label: '${recipe.cookingTimeMinutes} mins'),
        const SizedBox(width: 20),
        _MetaItem(icon: Icons.local_fire_department, label: '${recipe.calories} kcal'),
        const SizedBox(width: 20),
        _MetaItem(icon: Icons.restaurant, label: '${recipe.servings} serves'),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textLightMuted),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: AppColors.textLightMuted, fontSize: 13)),
      ],
    );
  }
}

class _IngredientChipsRow extends StatelessWidget {
  final List<RecipeIngredient> ingredients;
  const _IngredientChipsRow({required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('Ingredients',
              style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700, fontSize: 14)),
          const Spacer(),
          ...ingredients.take(5).map(
                (i) => Padding(
              padding: const EdgeInsets.only(left: 4),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.cardAlt,
                child: Text(i.icon, style: const TextStyle(fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientListCard extends ConsumerWidget {
  final List<RecipeIngredient> ingredients;
  const _IngredientListCard({required this.ingredients});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kitchen = ref.watch(kitchenProviderKeysProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: ingredients.map((ingredient) {
          final have = kitchen.contains(ingredient.name.toLowerCase().trim());
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.cardAlt,
                  child: Text(ingredient.icon, style: const TextStyle(fontSize: 15)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ingredient.name + (ingredient.required ? '' : '  (optional)'),
                    style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  '${_formatQty(ingredient.quantity)} ${ingredient.unit}',
                  style: const TextStyle(color: AppColors.textDarkMuted, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Icon(
                  have ? Icons.check_circle : Icons.remove_circle_outline,
                  size: 18,
                  color: have ? AppColors.success : AppColors.missing,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatQty(num q) => q == q.roundToDouble() ? q.toInt().toString() : q.toString();
}

class _InstructionStep extends StatelessWidget {
  final int number;
  final String text;
  const _InstructionStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
            child: Text('$number',
                style: const TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(color: AppColors.textLight, height: 1.4)),
          ),
        ],
      ),
    );
  }
}