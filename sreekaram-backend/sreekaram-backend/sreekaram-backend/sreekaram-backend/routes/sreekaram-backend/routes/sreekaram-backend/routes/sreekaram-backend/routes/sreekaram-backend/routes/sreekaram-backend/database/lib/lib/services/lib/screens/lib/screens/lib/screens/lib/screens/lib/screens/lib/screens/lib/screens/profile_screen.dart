import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final farmer = authService.farmer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ప్రొఫైల్ | Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Color(0xFF2E7D32)),
                  ),
                  const SizedBox(height: 12),
                  Text(farmer?['name'] ?? 'రైతు',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(farmer?['phone'] ?? '',
                    style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Farm details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('వ్యవసాయ వివరాలు | Farm Details',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Divider(),
                    _ProfileRow('గ్రామం | Village', farmer?['village'] ?? '-', Icons.location_village),
                    _ProfileRow('మండల్ | Mandal', farmer?['mandal'] ?? '-', Icons.map),
                    _ProfileRow('జిల్లా | District', 'Khammam', Icons.location_city),
                    _ProfileRow('పంటలు | Crops',
                      (farmer?['crops'] as List?)?.join(', ') ?? '-', Icons.grass),
                    _ProfileRow('భూమి | Land',
                      farmer?['land_acres'] != null ? '${farmer!['land_acres']} acres' : '-',
                      Icons.agriculture),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Quick links
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.trending_up, color: Color(0xFF2E7D32)),
                    title: const Text('మార్కెట్ ధరలు | Market Prices'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.pushNamed(context, '/market'),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.cloud, color: Colors.blue),
                    title: const Text('వాతావరణం | Weather'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.pushNamed(context, '/weather'),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.account_balance, color: Colors.purple),
                    title: const Text('పథకాలు | Schemes'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.pushNamed(context, '/schemes'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileRow(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}