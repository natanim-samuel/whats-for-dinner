const express = require('express');
const router = express.Router();
const { listRecipes, getRecipe, matchRecipes } = require('../controllers/recipeController');

router.get('/', listRecipes);
router.post('/match', matchRecipes);
router.get('/:id', getRecipe);

module.exports = router;
