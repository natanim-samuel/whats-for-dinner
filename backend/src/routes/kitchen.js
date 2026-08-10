const express = require('express');
const router = express.Router();
const { getKitchen, addToKitchen, removeFromKitchen } = require('../controllers/kitchenController');

router.get('/', getKitchen);
router.post('/', addToKitchen);
router.delete('/:ingredientId', removeFromKitchen);

module.exports = router;
