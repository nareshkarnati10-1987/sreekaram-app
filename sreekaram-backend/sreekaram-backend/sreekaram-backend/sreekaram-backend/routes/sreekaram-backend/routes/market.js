const express = require('express');
const router = express.Router();
const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
});

// Get current market prices for Khammam mandis
router.get('/prices', async (req, res) => {
  try {
    const { crop, mandi } = req.query;
    let query = 'SELECT * FROM market_prices WHERE 1=1';
    const params = [];
    if (crop) { query += ` AND crop_name ILIKE $${params.length + 1}`; params.push(`%${crop}%`); }
    if (mandi) { query += ` AND mandi_name ILIKE $${params.length + 1}`; params.push(`%${mandi}%`); }
    query += ' ORDER BY updated_at DESC LIMIT 50';
    const result = await pool.query(query, params);
    res.json({ success: true, data: result.rows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get Khammam mandis list
router.get('/mandis', async (req, res) => {
  try {
    const mandis = [
      { name: 'Khammam Main APMC', location: 'Khammam', crops: ['Cotton', 'Chilli', 'Maize'] },
      { name: 'Kothagudem APMC', location: 'Kothagudem', crops: ['Rice', 'Maize', 'Turmeric'] },
      { name: 'Bhadrachalam APMC', location: 'Bhadrachalam', crops: ['Rice', 'Bamboo'] },
      { name: 'Sattupalli APMC', location: 'Sattupalli', crops: ['Cotton', 'Chilli', 'Turmeric'] },
      { name: 'Madhira APMC', location: 'Madhira', crops: ['Rice', 'Cotton', 'Maize'] },
    ];
    res.json({ success: true, data: mandis });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Add market price (admin)
router.post('/prices', async (req, res) => {
  try {
    const { crop_name, mandi_name, price_per_quintal, quality_grade } = req.body;
    const result = await pool.query(
      'INSERT INTO market_prices (crop_name, mandi_name, price_per_quintal, quality_grade) VALUES ($1, $2, $3, $4) RETURNING *',
      [crop_name, mandi_name, price_per_quintal, quality_grade]
    );
    res.json({ success: true, data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;