require('dotenv').config();
const express = require('express');
const cors = require('cors');

const recipeRoutes = require('./routes/recipes');
const kitchenRoutes = require('./routes/kitchen');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => res.json({ status: 'ok' }));

app.use('/api/recipes', recipeRoutes);
app.use('/api/kitchen', kitchenRoutes);

app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Something went wrong on the server.' });
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`What's for Dinner? API running on port ${PORT}`);
});
