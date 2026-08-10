const pool = require('../db');
const { computeMatch } = require('../services/matching');

// GET /api/recipes  — list all recipes (basic info, for browsing/search)
async function listRecipes(req, res) {
  const { q } = req.query;
  let query = 'SELECT id, name, description, image_url, category, cooking_time, difficulty, servings, rating FROM recipes';
  const params = [];

  if (q) {
    query += ' WHERE name ILIKE $1 OR category ILIKE $1';
    params.push(`%${q}%`);
  }
  query += ' ORDER BY rating DESC';

  const { rows } = await pool.query(query, params);
  res.json({ recipes: rows });
}

// GET /api/recipes/:id — full recipe detail, including ingredient list & instructions
async function getRecipe(req, res) {
  const { id } = req.params;

  const recipeResult = await pool.query('SELECT * FROM recipes WHERE id = $1', [id]);
  if (recipeResult.rows.length === 0) {
    return res.status(404).json({ error: 'Recipe not found' });
  }
  const recipe = recipeResult.rows[0];

  const ingredientsResult = await pool.query(
    `SELECT i.id AS ingredient_id, i.name, i.category, ri.quantity, ri.unit, ri.required
     FROM recipe_ingredients ri
     JOIN ingredients i ON i.id = ri.ingredient_id
     WHERE ri.recipe_id = $1
     ORDER BY ri.required DESC, i.name ASC`,
    [id]
  );

  res.json({ recipe: { ...recipe, ingredients: ingredientsResult.rows } });
}

// POST /api/recipes/match
// body: { ingredientIds: [1, 4, 9, ...] }  (or { ingredientNames: ["Rice", "Egg", ...] })
// Returns every recipe sorted by match percentage, highest first.
async function matchRecipes(req, res) {
  const { ingredientIds = [], ingredientNames = [] } = req.body;

  let resolvedIds = ingredientIds.map(Number);

  if (ingredientNames.length > 0) {
    const { rows } = await pool.query(
      'SELECT id FROM ingredients WHERE name = ANY($1::text[])',
      [ingredientNames.map((n) => n.toLowerCase())]
    );
    resolvedIds = [...resolvedIds, ...rows.map((r) => r.id)];
  }

  if (resolvedIds.length === 0) {
    return res.status(400).json({ error: 'Provide ingredientIds or ingredientNames.' });
  }

  const recipesResult = await pool.query('SELECT * FROM recipes');
  const recipes = recipesResult.rows;

  const riResult = await pool.query(
    'SELECT recipe_id, ingredient_id, quantity, unit, required FROM recipe_ingredients'
  );

  const byRecipe = new Map();
  for (const ri of riResult.rows) {
    if (!byRecipe.has(ri.recipe_id)) byRecipe.set(ri.recipe_id, []);
    byRecipe.get(ri.recipe_id).push(ri);
  }

  const results = recipes.map((recipe) => {
    const recipeIngredients = byRecipe.get(recipe.id) || [];
    const match = computeMatch(recipeIngredients, resolvedIds);
    return {
      id: recipe.id,
      name: recipe.name,
      image_url: recipe.image_url,
      cooking_time: recipe.cooking_time,
      difficulty: recipe.difficulty,
      rating: recipe.rating,
      matchPercentage: match.matchPercentage,
      haveCount: match.haveCount,
      totalCount: match.totalCount,
    };
  });

  results.sort((a, b) => b.matchPercentage - a.matchPercentage);

  res.json({ recipes: results });
}

module.exports = { listRecipes, getRecipe, matchRecipes };
