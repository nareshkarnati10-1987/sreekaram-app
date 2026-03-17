import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _villageController = TextEditingController();
  bool _isLoading = false;
  bool _isRegister = false;
  String _selectedMandal = 'Khammam';
  final List<String> _selectedCrops = [];

  final List<String> _mandals = [
    'Khammam', 'Kothagudem', 'Bhadrachalam', 'Sattupalli',
    'Madhira', 'Wyra', 'Yellandu', 'Palvancha'
  ];

  final List<String> _crops = [
    'Cotton', 'Chilli', 'Rice', 'Maize', 'Turmeric', 'Banana', 'Mango'
  ];

  Future<void> _handleLogin() async {
    if (_phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('సరైన ఫోన్ నంబర్ నమోదు చేయండి | Enter valid phone number'))
      );
      return;
    }
    setState(() => _isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    final result = await authService.login(_phoneController.text);
    setState(() => _isLoading = false);
    if (result['success']) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'లోగిన్ విఫలమైంది'))
      );
    }
  }

  Future<void> _handleRegister() async {
    if (_nameController.text.isEmpty || _phoneController.text.length != 10) return;
    setState(() => _isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    final result = await authService.register({
      'name': _nameController.text,
      'phone': _phoneController.text,
      'village': _villageController.text,
      'mandal': _selectedMandal,
      'crops': _selectedCrops,
    });
    setState(() => _isLoading = false);
    if (result['success']) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'నమోదు విఫలమైంది'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: const Color(0xFF2E7D32),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.agriculture, size: 60, color: Colors.white),
                  SizedBox(height: 8),
                  Text('శ్రీకారం | Sreekaram',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('ఖమ్మం జిల్లా రైతుల అప్',
                    style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => setState(() => _isRegister = false),
                              style: TextButton.styleFrom(
                                backgroundColor: !_isRegister ? const Color(0xFF2E7D32) : null,
                                foregroundColor: !_isRegister ? Colors.white : Colors.green,
                              ),
                              child: const Text('లోగిన్ | Login'),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () => setState(() => _isRegister = true),
                              style: TextButton.styleFrom(
                                backgroundColor: _isRegister ? const Color(0xFF2E7D32) : null,
                                foregroundColor: _isRegister ? Colors.white : Colors.green,
                              ),
                              child: const Text('నమోదు | Register'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_isRegister) ...[
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'పేరు | Name',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _villageController,
                          decoration: const InputDecoration(
                            labelText: 'గ్రామం | Village',
                            prefixIcon: Icon(Icons.location_on),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedMandal,
                          decoration: const InputDecoration(
                            labelText: 'మండల్ | Mandal',
                            border: OutlineInputBorder(),
                          ),
                          items: _mandals.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                          onChanged: (v) => setState(() => _selectedMandal = v!),
                        ),
                        const SizedBox(height: 12),
                      ],
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: const InputDecoration(
                          labelText: 'ఫోన్ నంబర్ | Phone Number',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : (_isRegister ? _handleRegister : _handleLogin),
                          child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(_isRegister ? 'నమోదు చేయండి | Register' : 'లోగిన్ | Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}