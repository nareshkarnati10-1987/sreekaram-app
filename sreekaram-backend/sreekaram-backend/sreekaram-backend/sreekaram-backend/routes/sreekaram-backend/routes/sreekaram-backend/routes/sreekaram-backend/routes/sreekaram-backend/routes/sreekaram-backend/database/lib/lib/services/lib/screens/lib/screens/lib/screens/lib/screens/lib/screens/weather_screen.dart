import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String BASE_URL = 'http://localhost:3000/api';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? _weather;
  bool _isLoading = true;
  String _selectedMandal = 'Khammam';

  final List<String> _mandals = [
    'Khammam', 'Kothagudem', 'Bhadrachalam', 'Sattupalli', 'Madhira', 'Wyra'
  ];

  final Map<String, dynamic> _mockWeather = {
    'temperature': 28,
    'humidity': 72,
    'description': 'Partly Cloudy',
    'windSpeed': 14,
    'rainfall': 0,
    'location': 'Khammam',
    'advisory': 'Good farming conditions for Khammam district crops',
  };

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/weather/current?mandal=$_selectedMandal'),
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() { _weather = data['data']; _isLoading = false; });
        return;
      }
    } catch (e) {
      // Use mock
    }
    setState(() { _weather = {..._mockWeather, 'location': _selectedMandal}; _isLoading = false; });
  }

  IconData _getWeatherIcon(String description) {
    if (description.toLowerCase().contains('rain')) return Icons.water_drop;
    if (description.toLowerCase().contains('cloud')) return Icons.cloud;
    if (description.toLowerCase().contains('sun') || description.toLowerCase().contains('clear')) return Icons.wb_sunny;
    return Icons.cloud;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('వాతావరణం | Weather'),
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
          onRefresh: _fetchWeather,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Mandal selector
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _mandals.length,
                    itemBuilder: (context, i) {
                      final m = _mandals[i];
                      final sel = m == _selectedMandal;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(m),
                          selected: sel,
                          onSelected: (_) {
                            setState(() => _selectedMandal = m);
                            _fetchWeather();
                          },
                          selectedColor: const Color(0xFF2E7D32),
                          labelStyle: TextStyle(color: sel ? Colors.white : Colors.black),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Main weather card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(_getWeatherIcon(_weather?['description'] ?? ''),
                        size: 80, color: Colors.white),
                      Text('${_weather?['temperature']}°C',
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(_weather?['description'] ?? '',
                        style: const TextStyle(fontSize: 18, color: Colors.white70)),
                      Text(_weather?['location'] ?? _selectedMandal,
                        style: const TextStyle(fontSize: 14, color: Colors.white60)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Stats row
                Row(
                  children: [
                    _WeatherStat('తేట', 'తేటి', '${_weather?['humidity']}%', Icons.water_drop),
                    const SizedBox(width: 12),
                    _WeatherStat('గాలి', 'Wind', '${_weather?['windSpeed']} km/h', Icons.air),
                    const SizedBox(width: 12),
                    _WeatherStat('వర్షపాతం', 'Rain', '${_weather?['rainfall']} mm', Icons.umbrella),
                  ],
                ),
                const SizedBox(height: 16),
                // Advisory card
                Card(
                  color: const Color(0xFFE8F5E9),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info, color: Color(0xFF2E7D32)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('వ్యవసాయ సలహా | Farm Advisory',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(_weather?['advisory'] ?? ''),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  final String telugu;
  final String english;
  final String value;
  final IconData icon;

  const _WeatherStat(this.telugu, this.english, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF1976D2)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(telugu, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}