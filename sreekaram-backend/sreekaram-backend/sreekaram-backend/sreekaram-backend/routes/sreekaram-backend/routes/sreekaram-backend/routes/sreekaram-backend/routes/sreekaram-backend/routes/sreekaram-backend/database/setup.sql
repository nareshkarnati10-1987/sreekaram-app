-- Sreekaram Agritech Database Setup
-- Khammam District, Telangana

CREATE DATABASE sreekaram_db;

\c sreekaram_db;

-- Farmers table
CREATE TABLE IF NOT EXISTS farmers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(15) UNIQUE NOT NULL,
  phone_hash VARCHAR(255),
  village VARCHAR(100),
  mandal VARCHAR(100),
  district VARCHAR(100) DEFAULT 'Khammam',
  state VARCHAR(50) DEFAULT 'Telangana',
  crops TEXT[],
  land_acres DECIMAL(10,2),
  profile_image VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Market prices table
CREATE TABLE IF NOT EXISTS market_prices (
  id SERIAL PRIMARY KEY,
  crop_name VARCHAR(100) NOT NULL,
  mandi_name VARCHAR(100) NOT NULL,
  price_per_quintal DECIMAL(10,2) NOT NULL,
  quality_grade VARCHAR(10) DEFAULT 'A',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crop advisories table
CREATE TABLE IF NOT EXISTS crop_advisories (
  id SERIAL PRIMARY KEY,
  crop_name VARCHAR(100) NOT NULL,
  season VARCHAR(20),
  advisory_telugu TEXT,
  advisory_english TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample market price data for Khammam
INSERT INTO market_prices (crop_name, mandi_name, price_per_quintal, quality_grade) VALUES
  ('Cotton', 'Khammam Main APMC', 6500.00, 'A'),
  ('Cotton', 'Sattupalli APMC', 6450.00, 'A'),
  ('Chilli', 'Khammam Main APMC', 12000.00, 'A'),
  ('Chilli', 'Madhira APMC', 11800.00, 'B'),
  ('Rice', 'Kothagudem APMC', 2200.00, 'A'),
  ('Rice', 'Bhadrachalam APMC', 2180.00, 'A'),
  ('Maize', 'Khammam Main APMC', 1850.00, 'A'),
  ('Turmeric', 'Khammam Main APMC', 8500.00, 'A');

-- Create index for faster queries
CREATE INDEX idx_farmers_mandal ON farmers(mandal);
CREATE INDEX idx_market_crop ON market_prices(crop_name);
CREATE INDEX idx_market_mandi ON market_prices(mandi_name);