import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models.dart';
import '../../../core/theme/app_theme.dart';
import '../../kitchen/providers/kitchen_provider.dart';
import '../../recipes/providers/recipe_provider.dart';
import '../../recipes/screens/recipe_detail_screen.dart';
import '../../settings/screens/settings_screen.dart';

enum DinnerSource {
  all,
  bookmarked,
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends ConsumerState<HomeScreen> {
  bool _showResults = false;

  DinnerSource _source = DinnerSource.all;

  @override
  Widget build(BuildContext context) {
    final kitchenItems = ref.watch(kitchenProvider);

    final ingredientCount =
        kitchenItems.length;

    final allMatches =
    ref.watch(dinnerMatchesProvider);

    final bookmarkedMatches =
    ref.watch(favoriteDinnerMatchesProvider);

    final sourceMatches =
    _source == DinnerSource.all
        ? allMatches
        : bookmarkedMatches;

    final matches = sourceMatches
        .where(
          (match) =>
      match.matchPercentage > 0,
    )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "What's for Dinner?",
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            0,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Good evening 👋',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                ingredientCount > 0
                    ? 'You have $ingredientCount ingredients in your kitchen.'
                    : 'Add ingredients to your kitchen to get started.',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 24),

              Card(
                color: AppColors.card,
                child: Padding(
                  padding:
                  const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🍳 Cook With My Ingredients',
                        style: TextStyle(
                          color:
                          AppColors.textDark,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "We'll find recipes ranked by how much of your kitchen they use.",
                        style: TextStyle(
                          color: AppColors
                              .textDarkMuted,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // RECIPE SOURCE SELECTOR
                      _DinnerSourceSelector(
                        value: _source,
                        onChanged: (value) {
                          setState(() {
                            _source = value;
                            _showResults =
                            true;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child:
                        ElevatedButton(
                          onPressed:
                          ingredientCount ==
                              0
                              ? null
                              : () {
                            setState(() {
                              _showResults =
                              true;
                            });
                          },
                          child: Text(
                            _showResults
                                ? 'Dinner Ideas ✓'
                                : 'Find Dinner →',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              if (_showResults) ...[
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '🍽️ Dinner Ideas',
                        style: TextStyle(
                          color: AppColors
                              .textLight,
                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    Text(
                      '${matches.length} found',
                      style:
                      const TextStyle(
                        color: AppColors
                            .textLightMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (matches.isEmpty)
                  Expanded(
                    child: _NoRecipesState(
                      source: _source,
                    ),
                  )
                else
                  Expanded(
                    child:
                    ListView.separated(
                      padding:
                      const EdgeInsets.only(
                        bottom: 20,
                      ),
                      itemCount:
                      matches.length,
                      separatorBuilder:
                          (_, __) =>
                      const SizedBox(
                        height: 12,
                      ),
                      itemBuilder:
                          (context, index) {
                        return _RecipeMatchCard(
                          match:
                          matches[index],
                          isBest:
                          index == 0,
                        );
                      },
                    ),
                  ),
              ] else
                const Expanded(
                  child: _HomeEmptyState(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DinnerSourceSelector
    extends StatelessWidget {
  final DinnerSource value;
  final ValueChanged<DinnerSource>
  onChanged;

  const _DinnerSourceSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Find recipes from:',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: _OptionButton(
                  selected:
                  value ==
                      DinnerSource.all,
                  icon: Icons.restaurant_menu,
                  label: 'All Recipes',
                  onTap: () => onChanged(
                    DinnerSource.all,
                  ),
                ),
              ),

              Expanded(
                child: _OptionButton(
                  selected:
                  value ==
                      DinnerSource.bookmarked,
                  icon: Icons.bookmark,
                  label: 'Bookmarked',
                  onTap: () => onChanged(
                    DinnerSource.bookmarked,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OptionButton
    extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionButton({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(14),
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent
              : Colors.transparent,
          borderRadius:
          BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? AppColors.textDark
                  : AppColors.textDarkMuted,
            ),

            const SizedBox(width: 6),

            Flexible(
              child: Text(
                label,
                overflow:
                TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected
                      ? AppColors.textDark
                      : AppColors.textDarkMuted,
                  fontSize: 13,
                  fontWeight:
                  selected
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoRecipesState
    extends StatelessWidget {
  final DinnerSource source;

  const _NoRecipesState({
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarked =
        source ==
            DinnerSource.bookmarked;

    return Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Text(
            bookmarked ? '🔖' : '🍽️',
            style: const TextStyle(
              fontSize: 48,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            bookmarked
                ? 'No bookmarked matches.'
                : 'No recipes found.',
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Text(
              bookmarked
                  ? 'Bookmark some recipes or add more kitchen ingredients.'
                  : 'Try adding more ingredients to your kitchen.',
              textAlign:
              TextAlign.center,
              style: const TextStyle(
                color:
                AppColors.textLightMuted,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeEmptyState
    extends StatelessWidget {
  const _HomeEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Text(
            '🍳',
            style: TextStyle(
              fontSize: 52,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Ready to cook?',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Choose a recipe source and tap "Find Dinner".',
            textAlign:
            TextAlign.center,
            style: TextStyle(
              color:
              AppColors.textLightMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeMatchCard
    extends StatelessWidget {
  final RecipeMatchResult match;
  final bool isBest;

  const _RecipeMatchCard({
    required this.match,
    required this.isBest,
  });

  Color get _matchColor {
    if (match.matchPercentage >= 80) {
      return AppColors.success;
    }

    if (match.matchPercentage >= 50) {
      return AppColors.warning;
    }

    return AppColors.missing;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius:
        BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  RecipeDetailScreen(
                    recipeId:
                    match.recipe.id,
                  ),
            ),
          );
        },
        child: Padding(
          padding:
          const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(14),
                child: Image.network(
                  '${match.recipe.imageUrl}?w=160&q=60',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: AppColors
                          .backgroundElevated,
                      child: const Icon(
                        Icons.restaurant,
                        color:
                        AppColors.accent,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    if (isBest)
                      const Padding(
                        padding:
                        EdgeInsets.only(
                          bottom: 4,
                        ),
                        child: Text(
                          '🎯 BEST MATCH',
                          style:
                          TextStyle(
                            color:
                            AppColors
                                .accent,
                            fontWeight:
                            FontWeight
                                .bold,
                            fontSize: 11,
                          ),
                        ),
                      ),

                    Text(
                      match.recipe.name,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      const TextStyle(
                        color:
                        AppColors.textLight,
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 7),

                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(
                        6,
                      ),
                      child:
                      LinearProgressIndicator(
                        value:
                        match.matchPercentage /
                            100,
                        minHeight: 8,
                        backgroundColor:
                        AppColors.background,
                        color:
                        _matchColor,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '${match.matchPercentage}% match · '
                          '${match.haveCount}/${match.totalCount} ingredients',
                      style:
                      const TextStyle(
                        color: AppColors
                            .textLightMuted,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors
                              .textLightMuted,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          '${match.recipe.cookingTimeMinutes} min',
                          style:
                          const TextStyle(
                            fontSize: 12,
                            color: AppColors
                                .textLightMuted,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Icon(
                          Icons.star,
                          size: 14,
                          color:
                          AppColors.accent,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          '${match.recipe.rating}',
                          style:
                          const TextStyle(
                            fontSize: 12,
                            color: AppColors
                                .textLightMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}