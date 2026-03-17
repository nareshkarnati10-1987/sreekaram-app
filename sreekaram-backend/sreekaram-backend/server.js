const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
const authRoutes = require('./routes/auth');
const farmerRoutes = require('./routes/farmer');
const marketRoutes = require('./routes/market');
const weatherRoutes = require('./routes/weather');
const schemeRoutes = require('./routes/schemes');

app.use('/api/auth', authRoutes);
app.use('/api/farmer', farmerRoutes);
app.use('/api/market', marketRoutes);
app.use('/api/weather', weatherRoutes);
app.use('/api/schemes', schemeRoutes);

// Health check
app.get('/', (req, res) => {
  res.json({ message: 'Sreekaram API Running - Khammam District Agritech' });
});

app.listen(PORT, () => {
  console.log(`Sreekaram Server running on port ${PORT}`);
});