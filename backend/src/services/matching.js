/**
 * Ingredient matching engine.
 *
 * Given a recipe's ingredient list (each flagged required/optional) and the
 * set of ingredient IDs the user currently has, compute a match percentage.
 *
 * Rules (see spec section 10 — "Recipe Matching System"):
 *  - Required ingredients matter much more than optional ones.
 *  - A recipe with ALL required ingredients present should score highly
 *    even if some optional/garnish ingredients are missing.
 *  - A recipe missing a required ingredient should never outrank one that
 *    only lacks optional ingredients.
 *
 * Weighting: required ingredients are worth 3x an optional ingredient.
 */
function computeMatch(recipeIngredients, userIngredientIds) {
  const haveSet = new Set(userIngredientIds);

  const REQUIRED_WEIGHT = 3;
  const OPTIONAL_WEIGHT = 1;

  let totalWeight = 0;
  let matchedWeight = 0;
  const have = [];
  const missing = [];

  for (const ri of recipeIngredients) {
    const weight = ri.required ? REQUIRED_WEIGHT : OPTIONAL_WEIGHT;
    totalWeight += weight;

    if (haveSet.has(ri.ingredient_id)) {
      matchedWeight += weight;
      have.push(ri);
    } else {
      missing.push(ri);
    }
  }

  const percentage = totalWeight === 0 ? 0 : Math.round((matchedWeight / totalWeight) * 100);

  return {
    matchPercentage: percentage,
    haveCount: have.length,
    totalCount: recipeIngredients.length,
    have,
    missing,
  };
}

module.exports = { computeMatch };
