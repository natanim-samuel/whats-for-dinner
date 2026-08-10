const pool = require('../db');

const DEMO_USER = 'demo-user'; // Phase 1 has no auth yet — single demo user

// GET /api/kitchen — everything currently in the user's kitchen
async function getKitchen(req, res) {
  const { rows } = await pool.query(
    `SELECT uk.id, i.id AS ingredient_id, i.name, i.category, uk.quantity, uk.unit, uk.expiration_date
     FROM user_kitchen uk
     JOIN ingredients i ON i.id = uk.ingredient_id
     WHERE uk.user_id = $1
     ORDER BY i.category, i.name`,
    [DEMO_USER]
  );
  res.json({ kitchen: rows });
}

// POST /api/kitchen
// body: { name, category?, quantity?, unit?, expirationDate? }
// Creates the ingredient if it doesn't exist yet, then adds/updates it in the kitchen.
async function addToKitchen(req, res) {
  const { name, category = 'Other', quantity = 1, unit = 'pieces', expirationDate = null } = req.body;

  if (!name || !name.trim()) {
    return res.status(400).json({ error: 'Ingredient name is required.' });
  }

  const normalizedName = name.trim().toLowerCase();

  const ingredient = await pool.query(
    `INSERT INTO ingredients (name, category) VALUES ($1, $2)
     ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category
     RETURNING id, name, category`,
    [normalizedName, category]
  );
  const ingredientId = ingredient.rows[0].id;

  const kitchenRow = await pool.query(
    `INSERT INTO user_kitchen (user_id, ingredient_id, quantity, unit, expiration_date)
     VALUES ($1, $2, $3, $4, $5)
     ON CONFLICT (user_id, ingredient_id)
     DO UPDATE SET quantity = EXCLUDED.quantity, unit = EXCLUDED.unit, expiration_date = EXCLUDED.expiration_date
     RETURNING id, quantity, unit, expiration_date`,
    [DEMO_USER, ingredientId, quantity, unit, expirationDate]
  );

  res.status(201).json({
    id: kitchenRow.rows[0].id,
    ingredient_id: ingredientId,
    name: ingredient.rows[0].name,
    category: ingredient.rows[0].category,
    quantity: kitchenRow.rows[0].quantity,
    unit: kitchenRow.rows[0].unit,
    expiration_date: kitchenRow.rows[0].expiration_date,
  });
}

// DELETE /api/kitchen/:ingredientId
async function removeFromKitchen(req, res) {
  const { ingredientId } = req.params;
  await pool.query('DELETE FROM user_kitchen WHERE user_id = $1 AND ingredient_id = $2', [
    DEMO_USER,
    ingredientId,
  ]);
  res.status(204).send();
}

module.exports = { getKitchen, addToKitchen, removeFromKitchen };
