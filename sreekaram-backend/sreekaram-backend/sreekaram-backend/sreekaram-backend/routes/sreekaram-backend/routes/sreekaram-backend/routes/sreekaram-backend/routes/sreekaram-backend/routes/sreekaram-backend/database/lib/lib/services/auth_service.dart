import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String BASE_URL = 'http://localhost:3000/api';

class AuthService extends ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _farmer;
  bool _isLoggedIn = false;

  String? get token => _token;
  Map<String, dynamic>? get farmer => _farmer;
  bool get isLoggedIn => _isLoggedIn;

  AuthService() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final farmerJson = prefs.getString('farmer');
    if (farmerJson != null) {
      _farmer = json.decode(farmerJson);
    }
    _isLoggedIn = _token != null;
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone}),
      );
      final data = json.decode(response.body);
      if (data['success'] == true) {
        _token = data['token'];
        _farmer = data['farmer'];
        _isLoggedIn = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('farmer', json.encode(_farmer));
        notifyListeners();
        return {'success': true, 'farmer': _farmer};
      }
      return {'success': false, 'message': data['error'] ?? 'Login failed'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> farmerData) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(farmerData),
      );
      final data = json.decode(response.body);
      if (data['success'] == true) {
        _token = data['token'];
        _isLoggedIn = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        notifyListeners();
        return {'success': true};
      }
      return {'success': false, 'message': data['error'] ?? 'Registration failed'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<void> logout() async {
    _token = null;
    _farmer = null;
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('farmer');
    notifyListeners();
  }
}