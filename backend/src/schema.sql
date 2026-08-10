-- What's for Dinner? — database schema (Phase 1 MVP)

DROP TABLE IF EXISTS user_kitchen CASCADE;
DROP TABLE IF EXISTS recipe_ingredients CASCADE;
DROP TABLE IF EXISTS recipes CASCADE;
DROP TABLE IF EXISTS ingredients CASCADE;

CREATE TABLE ingredients (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  category TEXT NOT NULL DEFAULT 'Other'
);

CREATE TABLE recipes (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  category TEXT,
  cooking_time INT NOT NULL,       -- minutes
  difficulty TEXT NOT NULL DEFAULT 'Easy',
  servings INT NOT NULL DEFAULT 2,
  instructions JSONB NOT NULL,     -- array of step strings
  rating NUMERIC(2,1) DEFAULT 4.5,
  created_at TIMESTAMP DEFAULT now()
);

-- Join table: which ingredients a recipe needs, and whether they're required
CREATE TABLE recipe_ingredients (
  recipe_id INT REFERENCES recipes(id) ON DELETE CASCADE,
  ingredient_id INT REFERENCES ingredients(id) ON DELETE CASCADE,
  quantity NUMERIC,
  unit TEXT,
  required BOOLEAN NOT NULL DEFAULT true,
  PRIMARY KEY (recipe_id, ingredient_id)
);

-- What the (demo) user currently has in their kitchen
CREATE TABLE user_kitchen (
  id SERIAL PRIMARY KEY,
  user_id TEXT NOT NULL DEFAULT 'demo-user',
  ingredient_id INT REFERENCES ingredients(id) ON DELETE CASCADE,
  quantity NUMERIC,
  unit TEXT,
  expiration_date DATE,
  UNIQUE (user_id, ingredient_id)
);

CREATE INDEX idx_recipe_ingredients_recipe ON recipe_ingredients(recipe_id);
CREATE INDEX idx_recipe_ingredients_ingredient ON recipe_ingredients(ingredient_id);
CREATE INDEX idx_user_kitchen_user ON user_kitchen(user_id);
