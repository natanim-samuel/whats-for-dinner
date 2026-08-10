require('dotenv').config();
const pool = require('./db');

// Each recipe lists ingredients as { name, category, quantity, unit, required }
const recipes = [
  {
    name: 'Egg Fried Rice',
    description: 'A quick, classic way to turn leftover rice into dinner.',
    image_url: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b',
    category: 'Rice',
    cooking_time: 20,
    difficulty: 'Easy',
    servings: 2,
    rating: 4.7,
    instructions: [
      'Heat oil in a wok over high heat.',
      'Scramble the eggs and set aside.',
      'Add rice and stir-fry until heated through.',
      'Add onion and garlic, cook 2 minutes.',
      'Return eggs to the pan, add soy sauce, and toss to combine.',
      'Garnish with green onion and serve.',
    ],
    ingredients: [
      { name: 'rice', category: 'Grains', quantity: 2, unit: 'cup', required: true },
      { name: 'egg', category: 'Protein', quantity: 2, unit: 'pieces', required: true },
      { name: 'onion', category: 'Vegetables', quantity: 1, unit: 'pieces', required: true },
      { name: 'garlic', category: 'Other', quantity: 2, unit: 'cloves', required: true },
      { name: 'soy sauce', category: 'Other', quantity: 2, unit: 'tbsp', required: false },
      { name: 'green onion', category: 'Vegetables', quantity: 1, unit: 'pieces', required: false },
    ],
  },
  {
    name: 'Chicken Fried Rice',
    description: 'Egg fried rice leveled up with seared chicken.',
    image_url: 'https://images.unsplash.com/photo-1512058564366-18510be2db19',
    category: 'Rice',
    cooking_time: 25,
    difficulty: 'Easy',
    servings: 2,
    rating: 4.8,
    instructions: [
      'Cook the rice (or use day-old rice).',
      'Cut chicken into small cubes and season.',
      'Sear chicken in a hot pan until cooked through, set aside.',
      'Scramble eggs in the same pan, set aside.',
      'Stir-fry onion, garlic, and carrot until soft.',
      'Add rice, chicken, and egg back in. Add soy sauce and toss well.',
      'Top with green onion and serve.',
    ],
    ingredients: [
      { name: 'rice', category: 'Grains', quantity: 2, unit: 'cup', required: true },
      { name: 'chicken', category: 'Protein', quantity: 1, unit: 'lb', required: true },
      { name: 'egg', category: 'Protein', quantity: 2, unit: 'pieces', required: true },
      { name: 'onion', category: 'Vegetables', quantity: 1, unit: 'pieces', required: true },
      { name: 'garlic', category: 'Other', quantity: 2, unit: 'cloves', required: true },
      { name: 'carrot', category: 'Vegetables', quantity: 1, unit: 'pieces', required: false },
      { name: 'soy sauce', category: 'Other', quantity: 2, unit: 'tbsp', required: false },
      { name: 'green onion', category: 'Vegetables', quantity: 1, unit: 'pieces', required: false },
    ],
  },
  {
    name: 'Pasta Carbonara',
    description: 'Creamy Roman classic made with egg, cheese, and pepper — no cream needed.',
    image_url: 'https://images.unsplash.com/photo-1612874742237-6526221588e3',
    category: 'Pasta',
    cooking_time: 25,
    difficulty: 'Medium',
    servings: 2,
    rating: 4.6,
    instructions: [
      'Boil pasta until al dente, reserving a cup of pasta water.',
      'Cook bacon until crisp.',
      'Whisk eggs and grated cheese together in a bowl.',
      'Off heat, toss hot pasta with bacon, then quickly stir in egg mixture.',
      'Add pasta water a little at a time until glossy and creamy.',
      'Finish with cracked black pepper.',
    ],
    ingredients: [
      { name: 'pasta', category: 'Grains', quantity: 200, unit: 'g', required: true },
      { name: 'egg', category: 'Protein', quantity: 2, unit: 'pieces', required: true },
      { name: 'cheese', category: 'Other', quantity: 0.5, unit: 'cup', required: true },
      { name: 'bacon', category: 'Protein', quantity: 100, unit: 'g', required: true },
      { name: 'pepper', category: 'Other', quantity: 1, unit: 'tsp', required: false },
    ],
  },
  {
    name: 'Tomato Garlic Pasta',
    description: 'A pantry-staple pasta that comes together in one pan.',
    image_url: 'https://images.unsplash.com/photo-1608219992759-8d74ed8d76eb',
    category: 'Pasta',
    cooking_time: 20,
    difficulty: 'Easy',
    servings: 2,
    rating: 4.5,
    instructions: [
      'Boil pasta until al dente.',
      'Sauté garlic in olive oil until fragrant.',
      'Add chopped tomato and cook down into a sauce.',
      'Toss pasta with the sauce.',
      'Season with salt and finish with basil if you have it.',
    ],
    ingredients: [
      { name: 'pasta', category: 'Grains', quantity: 200, unit: 'g', required: true },
      { name: 'tomato', category: 'Vegetables', quantity: 4, unit: 'pieces', required: true },
      { name: 'garlic', category: 'Other', quantity: 3, unit: 'cloves', required: true },
      { name: 'oil', category: 'Other', quantity: 2, unit: 'tbsp', required: true },
      { name: 'basil', category: 'Vegetables', quantity: 5, unit: 'leaves', required: false },
      { name: 'salt', category: 'Other', quantity: 1, unit: 'tsp', required: false },
    ],
  },
  {
    name: 'Shakshuka',
    description: 'Eggs poached in a spiced tomato and pepper sauce.',
    image_url: 'https://images.unsplash.com/photo-1590412200988-a436970781fa',
    category: 'Breakfast',
    cooking_time: 30,
    difficulty: 'Easy',
    servings: 2,
    rating: 4.7,
    instructions: [
      'Sauté onion and garlic in oil until soft.',
      'Add chopped tomato and cook into a thick sauce, about 15 minutes.',
      'Make small wells in the sauce and crack eggs into them.',
      'Cover and cook until egg whites are set, about 5 minutes.',
      'Serve straight from the pan with bread.',
    ],
    ingredients: [
      { name: 'egg', category: 'Protein', quantity: 4, unit: 'pieces', required: true },
      { name: 'tomato', category: 'Vegetables', quantity: 5, unit: 'pieces', required: true },
      { name: 'onion', category: 'Vegetables', quantity: 1, unit: 'pieces', required: true },
      { name: 'garlic', category: 'Other', quantity: 2, unit: 'cloves', required: true },
      { name: 'oil', category: 'Other', quantity: 2, unit: 'tbsp', required: true },
      { name: 'bell pepper', category: 'Vegetables', quantity: 1, unit: 'pieces', required: false },
    ],
  },
  {
    name: 'Chicken Tibs',
    description: 'Ethiopian pan-seared chicken with onion, tomato, and berbere spice.',
    image_url: 'https://images.unsplash.com/photo-1603360946369-dc9bb6258143',
    category: 'Ethiopian',
    cooking_time: 30,
    difficulty: 'Medium',
    servings: 2,
    rating: 4.6,
    instructions: [
      'Cut chicken into strips and season.',
      'Sear chicken in oil over high heat until browned, set aside.',
      'In the same pan, sauté onion until soft.',
      'Add garlic, tomato, and berbere; cook until it forms a sauce.',
      'Return chicken to the pan and toss to coat.',
      'Serve hot, traditionally with injera.',
    ],
    ingredients: [
      { name: 'chicken', category: 'Protein', quantity: 1, unit: 'lb', required: true },
      { name: 'onion', category: 'Vegetables', quantity: 1, unit: 'pieces', required: true },
      { name: 'tomato', category: 'Vegetables', quantity: 2, unit: 'pieces', required: true },
      { name: 'garlic', category: 'Other', quantity: 2, unit: 'cloves', required: true },
      { name: 'berbere', category: 'Other', quantity: 1, unit: 'tbsp', required: true },
      { name: 'oil', category: 'Other', quantity: 2, unit: 'tbsp', required: true },
    ],
  },
  {
    name: 'Misir Wot',
    description: 'Ethiopian spiced red lentil stew — hearty, vegan, and freezer-friendly.',
    image_url: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe',
    category: 'Ethiopian',
    cooking_time: 40,
    difficulty: 'Easy',
    servings: 3,
    rating: 4.8,
    instructions: [
      'Sauté onion in oil until deeply softened, about 10 minutes.',
      'Add garlic and berbere, cook 1 minute until fragrant.',
      'Add lentils and water, bring to a simmer.',
      'Cook, stirring occasionally, until lentils are soft, about 25 minutes.',
      'Season with salt and serve with injera or rice.',
    ],
    ingredients: [
      { name: 'lentils', category: 'Grains', quantity: 1, unit: 'cup', required: true },
      { name: 'onion', category: 'Vegetables', quantity: 1, unit: 'pieces', required: true },
      { name: 'garlic', category: 'Other', quantity: 2, unit: 'cloves', required: true },
      { name: 'berbere', category: 'Other', quantity: 1, unit: 'tbsp', required: true },
      { name: 'oil', category: 'Other', quantity: 2, unit: 'tbsp', required: true },
      { name: 'water', category: 'Other', quantity: 3, unit: 'cup', required: true },
      { name: 'salt', category: 'Other', quantity: 1, unit: 'tsp', required: false },
    ],
  },
  {
    name: 'Shiro',
    description: 'Ethiopian chickpea flour stew, smooth and richly spiced.',
    image_url: 'https://images.unsplash.com/photo-1547592180-85f173990554',
    category: 'Ethiopian',
    cooking_time: 30,
    difficulty: 'Easy',
    servings: 2,
    rating: 4.7,
    instructions: [
      'Sauté onion and garlic in oil until soft.',
      'Add berbere and cook 1 minute.',
      'Whisk in shiro powder and water gradually to avoid lumps.',
      'Simmer, stirring often, until thickened, about 15 minutes.',
      'Serve hot with injera.',
    ],
    ingredients: [
      { name: 'shiro powder', category: 'Grains', quantity: 2, unit: 'cup', required: true },
      { name: 'onion', category: 'Vegetables', quantity: 1, unit: 'pieces', required: true },
      { name: 'garlic', category: 'Other', quantity: 3, unit: 'cloves', required: true },
      { name: 'berbere', category: 'Other', quantity: 1, unit: 'tbsp', required: true },
      { name: 'oil', category: 'Other', quantity: 2, unit: 'tbsp', required: true },
      { name: 'water', category: 'Other', quantity: 3, unit: 'cup', required: true },
    ],
  },
  {
    name: 'Potato Chicken Curry',
    description: 'A weeknight curry that stretches a few pantry staples a long way.',
    image_url: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7',
    category: 'Curry',
    cooking_time: 35,
    difficulty: 'Medium',
    servings: 3,
    rating: 4.5,
    instructions: [
      'Sauté onion, garlic in oil until golden.',
      'Add chicken and brown on all sides.',
      'Add potato, tomato, and curry powder; stir to coat.',
      'Add water, cover, and simmer until potato and chicken are cooked through.',
      'Season with salt and serve with rice.',
    ],
    ingredients: [
      { name: 'chicken', category: 'Protein', quantity: 1, unit: 'lb', required: true },
      { name: 'potato', category: 'Vegetables', quantity: 3, unit: 'pieces', required: true },
      { name: 'onion', category: 'Vegetables', quantity: 1, unit: 'pieces', required: true },
      { name: 'garlic', category: 'Other', quantity: 2, unit: 'cloves', required: true },
      { name: 'tomato', category: 'Vegetables', quantity: 1, unit: 'pieces', required: false },
      { name: 'curry powder', category: 'Other', quantity: 1, unit: 'tbsp', required: true },
      { name: 'oil', category: 'Other', quantity: 2, unit: 'tbsp', required: true },
      { name: 'water', category: 'Other', quantity: 1, unit: 'cup', required: true },
    ],
  },
  {
    name: 'Garlic Butter Rice',
    description: 'Simple, fast, and endlessly pairable side or light meal.',
    image_url: 'https://images.unsplash.com/photo-1516684732162-798a0062be99',
    category: 'Rice',
    cooking_time: 15,
    difficulty: 'Easy',
    servings: 2,
    rating: 4.3,
    instructions: [
      'Melt butter in a pan and sauté garlic until fragrant.',
      'Add cooked rice and toss to coat.',
      'Season with salt and serve.',
    ],
    ingredients: [
      { name: 'rice', category: 'Grains', quantity: 2, unit: 'cup', required: true },
      { name: 'garlic', category: 'Other', quantity: 3, unit: 'cloves', required: true },
      { name: 'butter', category: 'Other', quantity: 2, unit: 'tbsp', required: true },
      { name: 'salt', category: 'Other', quantity: 1, unit: 'tsp', required: false },
    ],
  },
];

async function seed() {
  console.log('Seeding database...');
  await pool.query('BEGIN');
  try {
    for (const recipe of recipes) {
      const recipeResult = await pool.query(
        `INSERT INTO recipes (name, description, image_url, category, cooking_time, difficulty, servings, instructions, rating)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
         RETURNING id`,
        [
          recipe.name,
          recipe.description,
          recipe.image_url,
          recipe.category,
          recipe.cooking_time,
          recipe.difficulty,
          recipe.servings,
          JSON.stringify(recipe.instructions),
          recipe.rating,
        ]
      );
      const recipeId = recipeResult.rows[0].id;

      for (const ing of recipe.ingredients) {
        const ingredientResult = await pool.query(
          `INSERT INTO ingredients (name, category) VALUES ($1, $2)
           ON CONFLICT (name) DO UPDATE SET category = EXCLUDED.category
           RETURNING id`,
          [ing.name, ing.category]
        );
        const ingredientId = ingredientResult.rows[0].id;

        await pool.query(
          `INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit, required)
           VALUES ($1, $2, $3, $4, $5)`,
          [recipeId, ingredientId, ing.quantity, ing.unit, ing.required]
        );
      }
    }
    await pool.query('COMMIT');
    console.log(`Seeded ${recipes.length} recipes.`);
  } catch (err) {
    await pool.query('ROLLBACK');
    console.error('Seed failed:', err);
    throw err;
  } finally {
    await pool.end();
  }
}

seed();
