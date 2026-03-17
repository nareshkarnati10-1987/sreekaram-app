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

// Get farmer profile
router.get('/profile/:id', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM farmers WHERE id = $1', [req.params.id]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Farmer not found' });
    res.json({ success: true, data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update farmer profile
router.put('/profile/:id', async (req, res) => {
  try {
    const { name, village, mandal, crops, land_acres } = req.body;
    const result = await pool.query(
      'UPDATE farmers SET name=$1, village=$2, mandal=$3, crops=$4, land_acres=$5 WHERE id=$6 RETURNING *',
      [name, village, mandal, crops, land_acres, req.params.id]
    );
    res.json({ success: true, data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get crop advisory for farmer
router.get('/advisory/:id', async (req, res) => {
  try {
    const farmer = await pool.query('SELECT * FROM farmers WHERE id = $1', [req.params.id]);
    if (farmer.rows.length === 0) return res.status(404).json({ error: 'Farmer not found' });
    const crops = farmer.rows[0].crops || [];
    const advisories = crops.map(crop => getCropAdvisory(crop));
    res.json({ success: true, data: advisories });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

function getCropAdvisory(crop) {
  const advisories = {
    'Cotton': { telugu: 'పత్తి పంట - బొంత పురుగు నివారణకు సిఫారసు మందులు వాడండి', english: 'Cotton - Use recommended pesticides for bollworm control' },
    'Chilli': { telugu: 'మిర్చి పంట - తెగులు నివారణకు రాగి మందు పిచికారి చేయండి', english: 'Chilli - Spray copper fungicide to prevent leaf curl disease' },
    'Rice': { telugu: 'వరి పంట - దుబ్బు తెగులు నివారణకు నీటి నిర్వహణ చేయండి', english: 'Paddy - Proper water management to prevent blast disease' },
    'Maize': { telugu: 'మొక్కజొన్న - ఆకు తెగులు నివారణకు శిలీంధ్ర నాశిని వాడండి', english: 'Maize - Use fungicide for leaf blight prevention' },
    'Turmeric': { telugu: 'పసుపు పంట - కాండం తెగులు నివారణకు జాగ్రత్త తీసుకోండి', english: 'Turmeric - Take precautions against rhizome rot' },
  };
  return advisories[crop] || { telugu: `${crop} పంట సలహా`, english: `${crop} crop advisory` };
}

module.exports = router;