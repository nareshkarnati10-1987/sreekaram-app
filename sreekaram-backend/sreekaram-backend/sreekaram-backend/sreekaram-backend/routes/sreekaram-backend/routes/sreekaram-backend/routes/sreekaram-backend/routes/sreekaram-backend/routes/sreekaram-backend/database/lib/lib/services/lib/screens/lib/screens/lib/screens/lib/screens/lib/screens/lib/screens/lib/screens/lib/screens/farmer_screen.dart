import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FarmerScreen extends StatefulWidget {
  const FarmerScreen({super.key});

  @override
  State<FarmerScreen> createState() => _FarmerScreenState();
}

class _FarmerScreenState extends State<FarmerScreen> {
  List farmers = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchFarmers();
  }

  Future<void> fetchFarmers() async {
    try {
      final response = await http.get(
        Uri.parse('https://sreekaram-backend.onrender.com/api/farmers'),
      );
      if (response.statusCode == 200) {
        setState(() {
          farmers = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = farmers.where((f) {
      final name = (f['name'] ?? '').toLowerCase();
      final village = (f['village'] ?? '').toLowerCase();
      return name.contains(searchQuery.toLowerCase()) ||
          village.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('రైతు నెట్‌వర్క్ | Farmer Network'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'పేరు లేదా గ్రామం వెతకండి | Search by name or village',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (v) => setState(() => searchQuery = v),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(child: Text('రైతులు కనుగొనబడలేదు | No farmers found'))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final farmer = filtered[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green[100],
                                child: Text(
                                  (farmer['name'] ?? 'F')[0].toUpperCase(),
                                  style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(farmer['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('గ్రామం: ${farmer['village'] ?? ''}'),
                                  Text('పంట: ${farmer['crop_type'] ?? ''}'),
                                  Text('వైశాల్యం: ${farmer['land_area'] ?? ''} ఎకరాలు'),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: IconButton(
                                icon: const Icon(Icons.phone, color: Colors.green),
                                onPressed: () {},
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}