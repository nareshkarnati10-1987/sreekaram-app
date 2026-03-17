const express = require('express');
const router = express.Router();
const axios = require('axios');

// Khammam district coordinates
const KHAMMAM_COORDS = { lat: 17.2473, lon: 80.1514 };

const KHAMMAM_MANDALS = [
  { name: 'Khammam', lat: 17.2473, lon: 80.1514 },
  { name: 'Kothagudem', lat: 17.5500, lon: 80.6200 },
  { name: 'Bhadrachalam', lat: 17.6689, lon: 80.8893 },
  { name: 'Sattupalli', lat: 17.1200, lon: 80.8800 },
  { name: 'Madhira', lat: 17.0800, lon: 80.3700 },
  { name: 'Wyra', lat: 17.3500, lon: 80.3700 },
];

// Get current weather for Khammam
router.get('/current', async (req, res) => {
  try {
    const { mandal } = req.query;
    let coords = KHAMMAM_COORDS;
    if (mandal) {
      const found = KHAMMAM_MANDALS.find(m => m.name.toLowerCase() === mandal.toLowerCase());
      if (found) coords = { lat: found.lat, lon: found.lon };
    }
    const apiKey = process.env.WEATHER_API_KEY;
    const url = `https://api.openweathermap.org/data/2.5/weather?lat=${coords.lat}&lon=${coords.lon}&appid=${apiKey}&units=metric`;
    const response = await axios.get(url);
    const weather = response.data;
    res.json({
      success: true,
      data: {
        temperature: weather.main.temp,
        humidity: weather.main.humidity,
        description: weather.weather[0].description,
        windSpeed: weather.wind.speed,
        rainfall: weather.rain ? weather.rain['1h'] || 0 : 0,
        location: weather.name,
        advisory: getAgriAdvisory(weather),
      }
    });
  } catch (err) {
    // Return mock data if API fails
    res.json({ success: true, data: getMockWeather() });
  }
});

function getMockWeather() {
  return { temperature: 28, humidity: 75, description: 'Partly Cloudy', windSpeed: 12, rainfall: 0, location: 'Khammam', advisory: 'Good conditions for Cotton and Chilli cultivation' };
}

function getAgriAdvisory(weather) {
  const temp = weather.main.temp;
  const humidity = weather.main.humidity;
  if (temp > 35) return 'High temperature alert - Irrigate crops early morning or evening';
  if (humidity > 85) return 'High humidity - Watch for fungal diseases in Chilli and Cotton';
  if (weather.rain) return 'Rain expected - Good for Kharif crops, avoid pesticide spraying';
  return 'Good farming conditions for Khammam district crops';
}

// Get mandals list
router.get('/mandals', (req, res) => {
  res.json({ success: true, data: KHAMMAM_MANDALS });
});

module.exports = router;