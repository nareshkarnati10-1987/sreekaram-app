const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
});

// Register Farmer
router.post('/register', async (req, res) => {
  try {
    const { name, phone, village, mandal, crops, land_acres } = req.body;
    const hashedPhone = await bcrypt.hash(phone, 10);
    const result = await pool.query(
      'INSERT INTO farmers (name, phone, phone_hash, village, mandal, crops, land_acres) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id',
      [name, phone, hashedPhone, village, mandal, crops, land_acres]
    );
    const token = jwt.sign({ id: result.rows[0].id, phone }, process.env.JWT_SECRET, { expiresIn: '30d' });
    res.json({ success: true, token, farmerId: result.rows[0].id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Login Farmer
router.post('/login', async (req, res) => {
  try {
    const { phone } = req.body;
    const result = await pool.query('SELECT * FROM farmers WHERE phone = $1', [phone]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Farmer not found' });
    const farmer = result.rows[0];
    const token = jwt.sign({ id: farmer.id, phone }, process.env.JWT_SECRET, { expiresIn: '30d' });
    res.json({ success: true, token, farmer });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
