import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final farmer = authService.farmer;
    final name = farmer?['name'] ?? 'రైతు';

    return Scaffold(
      appBar: AppBar(
        title: const Text('శ్రీకారం | Sreekaram'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome card
            Card(
              color: const Color(0xFF2E7D32),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Color(0xFF2E7D32), size: 36),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('నమస్కారం, $name!',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text(farmer?['mandal'] != null ? 'మండల్: ${farmer!['mandal']}' : 'ఖమ్మం జిల్లా',
                          style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('సేవలు | Services',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _ServiceCard(
                  icon: Icons.trending_up,
                  title: 'మార్కెట్ ధరలు',
                  subtitle: 'Market Prices',
                  color: Colors.orange,
                  onTap: () => Navigator.pushNamed(context, '/market'),
                ),
                _ServiceCard(
                  icon: Icons.cloud,
                  title: 'వాతావరణం',
                  subtitle: 'Weather',
                  color: Colors.blue,
                  onTap: () => Navigator.pushNamed(context, '/weather'),
                ),
                _ServiceCard(
                  icon: Icons.account_balance,
                  title: 'పథకాలు',
                  subtitle: 'Schemes',
                  color: Colors.purple,
                  onTap: () => Navigator.pushNamed(context, '/schemes'),
                ),
                _ServiceCard(
                  icon: Icons.grass,
                  title: 'పంట సలహా',
                  subtitle: 'Crop Advisory',
                  color: Colors.green,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('ఖమ్మం జిల్లా పంటలు | Khammam Crops',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Cotton - పత్తి', 'Chilli - మిర్చి', 'Rice - వరి',
                'Maize - మొక్కజొన్న', 'Turmeric - పసుపు',
              ].map((crop) => Chip(
                label: Text(crop, style: const TextStyle(fontSize: 12)),
                backgroundColor: const Color(0xFFE8F5E9),
              )).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E7D32),
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ఇంటి'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'ధరలు'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'వాతావరణం'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: 'పథకాలు'),
        ],
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/market');
          if (index == 2) Navigator.pushNamed(context, '/weather');
          if (index == 3) Navigator.pushNamed(context, '/schemes');
        },
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}