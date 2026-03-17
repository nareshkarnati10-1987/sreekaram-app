import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  static const List<Map<String, dynamic>> _schemes = [
    {
      'name': 'Rythu Bandhu',
      'telugu_name': 'రైతు బంధు',
      'benefit': 'ఎకరాకు రూ.10,000',
      'description': 'Investment support of Rs. 10,000 per acre per year for crop cultivation in Telangana',
      'icon': 0xe1d8,
      'color': 0xFF4CAF50,
      'apply_link': 'https://rythubandhu.telangana.gov.in',
      'category': 'ఆర్థిక',
    },
    {
      'name': 'PM-KISAN',
      'telugu_name': 'పీఎం-కిసాన్',
      'benefit': 'సంవత్సరంకు రూ.6,000',
      'description': 'Income support of Rs. 6,000 per year to all farmer families with cultivable land',
      'icon': 0xe1d8,
      'color': 0xFF2196F3,
      'apply_link': 'https://pmkisan.gov.in',
      'category': 'ఆర్థిక',
    },
    {
      'name': 'Fasal Bima Yojana',
      'telugu_name': 'పంట బీమా యోజన',
      'benefit': 'పంట నష్టానికి పూర్తి బీమా',
      'description': 'Comprehensive crop insurance protection against natural calamities and crop failure',
      'icon': 0xe3ab,
      'color': 0xFFFF9800,
      'apply_link': 'https://pmfby.gov.in',
      'category': 'బీమా',
    },
    {
      'name': 'Kisan Credit Card',
      'telugu_name': 'కిసాన్ క్రెడిట్ కార్డు',
      'benefit': '4% వడ్డీకి 3 లక్షల రుణం',
      'description': 'Flexible credit for farming needs at 4% interest. Available for all farmers including tenant farmers',
      'icon': 0xe1cc,
      'color': 0xFF9C27B0,
      'apply_link': 'https://www.nabard.org/kisan-credit-card',
      'category': 'రుణం',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('పథకాలు | Schemes'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _schemes.length,
        itemBuilder: (context, index) {
          final scheme = _schemes[index];
          final color = Color(scheme['color'] as int);
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      Icon(IconData(scheme['icon'] as int, fontFamily: 'MaterialIcons'),
                        color: Colors.white, size: 32),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(scheme['name'] as String,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text(scheme['telugu_name'] as String,
                            style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(scheme['category'] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.monetization_on, color: Color(0xFF2E7D32), size: 20),
                          const SizedBox(width: 8),
                          Text('ప్రయోజనం: ${scheme['benefit']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(scheme['description'] as String,
                        style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('దరఖాస్తు చేయండి | Apply Now'),
                          style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
                          onPressed: () async {
                            final url = Uri.parse(scheme['apply_link'] as String);
                            if (await canLaunchUrl(url)) await launchUrl(url);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}