import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models.dart';
import '../../../core/theme/app_theme.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../providers/recipe_provider.dart';
import 'recipe_detail_screen.dart';

class DinnerResultsScreen extends ConsumerStatefulWidget {
  const DinnerResultsScreen({super.key});

  @override
  ConsumerState<DinnerResultsScreen> createState() =>
      _DinnerResultsScreenState();
}

class _DinnerResultsScreenState
    extends ConsumerState<DinnerResultsScreen> {
  bool _showBookmarkedOnly = false;

  @override
  Widget build(BuildContext context) {
    final allMatches = ref.watch(dinnerMatchesProvider);
    final favoriteMatches =
    ref.watch(favoriteDinnerMatchesProvider);

    final matches =
    _showBookmarkedOnly ? favoriteMatches : allMatches;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dinner Ideas 🍽️'),
      ),

      body: Column(
        children: [
          // ------------------------------------------------------
          // FILTER
          // ------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              12,
              16,
              4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _FilterButton(
                    icon: Icons.restaurant_menu,
                    label: 'All Matches',
                    selected: !_showBookmarkedOnly,
                    onTap: () {
                      setState(() {
                        _showBookmarkedOnly = false;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _FilterButton(
                    icon: Icons.bookmark,
                    label: 'Bookmarked',
                    selected: _showBookmarkedOnly,
                    onTap: () {
                      setState(() {
                        _showBookmarkedOnly = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // ------------------------------------------------------
          // BOOKMARKED EMPTY STATE
          // ------------------------------------------------------
          if (_showBookmarkedOnly &&
              favoriteMatches.isEmpty)
            const Expanded(
              child: _EmptyBookmarkedState(),
            )
          else if (matches.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No recipes found.',
                  style: TextStyle(
                    color: AppColors.textLightMuted,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  24,
                ),
                itemCount: matches.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _RecipeMatchCard(
                    match: matches[index],
                    isBest:
                    !_showBookmarkedOnly && index == 0,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// FILTER BUTTON
// ============================================================

class _FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent
              : AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? AppColors.textDark
                  : AppColors.textLightMuted,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? AppColors.textDark
                    : AppColors.textLight,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// EMPTY BOOKMARKED STATE
// ============================================================

class _EmptyBookmarkedState extends StatelessWidget {
  const _EmptyBookmarkedState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: AppColors.accent,
            ),
            const SizedBox(height: 16),
            const Text(
              'No bookmarked recipes',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bookmark your favorite recipes and they will '
                  'appear here when you search for dinner.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textLightMuted,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// RECIPE MATCH CARD
// ============================================================

class _RecipeMatchCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(
      favoritesProvider.select(
            (favorites) => favorites.contains(match.recipe.id),
      ),
    );

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(
                recipeId: match.recipe.id,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  '${match.recipe.imageUrl}?w=160&q=60',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      _placeholder(),
                ),
              ),

              const SizedBox(width: 14),

              // CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    if (isBest)
                      const Padding(
                        padding:
                        EdgeInsets.only(bottom: 4),
                        child: Text(
                          '🎯 BEST MATCH',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            match.recipe.name,
                            style: const TextStyle(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        IconButton(
                          visualDensity:
                          VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            isFavorite
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: isFavorite
                                ? AppColors.accent
                                : AppColors.textLightMuted,
                          ),
                          onPressed: () {
                            ref
                                .read(
                              favoritesProvider
                                  .notifier,
                            )
                                .toggleFavorite(
                              match.recipe.id,
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value:
                        match.matchPercentage / 100,
                        minHeight: 8,
                        backgroundColor:
                        AppColors.background,
                        color: _matchColor,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '${match.matchPercentage}% match · '
                          '${match.haveCount}/${match.totalCount} '
                          'ingredients',
                      style: const TextStyle(
                        color: AppColors.textLightMuted,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color:
                          AppColors.textLightMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${match.recipe.cookingTimeMinutes} min',
                          style: const TextStyle(
                            fontSize: 12,
                            color:
                            AppColors.textLightMuted,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 4),

                        Text(
                          '${match.recipe.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            color:
                            AppColors.textLightMuted,
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

  Widget _placeholder() {
    return Container(
      width: 80,
      height: 80,
      color: AppColors.backgroundElevated,
      child: const Icon(
        Icons.restaurant,
        color: AppColors.accent,
      ),
    );
  }
}