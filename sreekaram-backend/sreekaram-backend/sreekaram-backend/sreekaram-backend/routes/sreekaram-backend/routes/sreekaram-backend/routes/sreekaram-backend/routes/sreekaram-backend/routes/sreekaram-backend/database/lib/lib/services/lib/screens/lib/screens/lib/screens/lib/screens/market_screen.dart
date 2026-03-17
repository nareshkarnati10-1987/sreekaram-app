import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../services/auth_service.dart';

const String BASE_URL = 'http://localhost:3000/api';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List<Map<String, dynamic>> _prices = [];
  bool _isLoading = true;
  String _selectedCrop = 'All';

  final List<String> _crops = ['All', 'Cotton', 'Chilli', 'Rice', 'Maize', 'Turmeric'];

  // Mock data for when API is unavailable
  final List<Map<String, dynamic>> _mockPrices = [
    {'crop_name': 'Cotton', 'mandi_name': 'Khammam Main APMC', 'price_per_quintal': 6500, 'quality_grade': 'A'},
    {'crop_name': 'Cotton', 'mandi_name': 'Sattupalli APMC', 'price_per_quintal': 6450, 'quality_grade': 'A'},
    {'crop_name': 'Chilli', 'mandi_name': 'Khammam Main APMC', 'price_per_quintal': 12000, 'quality_grade': 'A'},
    {'crop_name': 'Chilli', 'mandi_name': 'Madhira APMC', 'price_per_quintal': 11800, 'quality_grade': 'B'},
    {'crop_name': 'Rice', 'mandi_name': 'Kothagudem APMC', 'price_per_quintal': 2200, 'quality_grade': 'A'},
    {'crop_name': 'Rice', 'mandi_name': 'Bhadrachalam APMC', 'price_per_quintal': 2180, 'quality_grade': 'A'},
    {'crop_name': 'Maize', 'mandi_name': 'Khammam Main APMC', 'price_per_quintal': 1850, 'quality_grade': 'A'},
    {'crop_name': 'Turmeric', 'mandi_name': 'Khammam Main APMC', 'price_per_quintal': 8500, 'quality_grade': 'A'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchPrices();
  }

  Future<void> _fetchPrices() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/market/prices'),
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() { _prices = List<Map<String, dynamic>>.from(data['data']); _isLoading = false; });
        return;
      }
    } catch (e) {
      // Use mock data
    }
    setState(() { _prices = _mockPrices; _isLoading = false; });
  }

  List<Map<String, dynamic>> get _filteredPrices {
    if (_selectedCrop == 'All') return _prices;
    return _prices.where((p) => p['crop_name'] == _selectedCrop).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('మార్కెట్ ధరలు | Market Prices'),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFF5F5F5),
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _crops.map((crop) {
                  final selected = _selectedCrop == crop;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(crop),
                      selected: selected,
                      onSelected: (v) => setState(() => _selectedCrop = crop),
                      selectedColor: const Color(0xFF2E7D32),
                      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _fetchPrices,
                  child: ListView.builder(
                    itemCount: _filteredPrices.length,
                    itemBuilder: (context, index) {
                      final price = _filteredPrices[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF2E7D32),
                            child: Text(price['crop_name'][0],
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(price['crop_name'],
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(price['mandi_name']),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('₹${NumberFormat('#,##0').format(price['price_per_quintal'])}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                              Text('క్వింటల్కు | /quintal',
                                style: const TextStyle(fontSize: 10, color: Colors.grey)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: price['quality_grade'] == 'A' ? Colors.green : Colors.orange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('Grade ${price['quality_grade']}',
                                  style: const TextStyle(color: Colors.white, fontSize: 10)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ),
        ],
      ),
    );
  }
}