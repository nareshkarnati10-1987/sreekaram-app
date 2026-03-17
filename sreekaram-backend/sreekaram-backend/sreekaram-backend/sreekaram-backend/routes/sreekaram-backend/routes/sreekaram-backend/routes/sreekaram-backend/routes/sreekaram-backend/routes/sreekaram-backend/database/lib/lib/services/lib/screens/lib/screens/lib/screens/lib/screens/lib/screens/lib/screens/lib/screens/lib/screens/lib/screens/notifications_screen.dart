import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'క్రోపు ధర అప్‌డేట్ | Market Price Update',
      'body': 'ధాన్యం ధర క్వింటాకు ₹1,850 గా నౌంది | Paddy price now ₹1,850/quintal',
      'time': '2 గంటల క్రితం',
      'icon': Icons.trending_up,
      'color': Colors.green,
      'read': false,
    },
    {
      'title': 'వాతావరణ హెచ్చరిక | Weather Alert',
      'body': 'రేపటి నుండి వర్షాలు అవకాశం | Rains likely from tomorrow',
      'time': '5 గంటల క్రితం',
      'icon': Icons.cloud,
      'color': Colors.blue,
      'read': false,
    },
    {
      'title': 'క్రోపు పర్చులు ఇప్పిచొక్కండి | New Scheme Available',
      'body': 'PM-KISAN క్రోపు పర్చులు ఎఖలైతే అనుకూలంగా ఉంది | PM-KISAN applications now open',
      'time': 'నిన్న',
      'icon': Icons.assignment,
      'color': Colors.orange,
      'read': true,
    },
    {
      'title': 'మార్కెట్ సమాచారం | Market Info',
      'body': 'ఖమ్మం APMC మార్కెట్ నేడు తెరుచుకోకపోవటం | Khammam APMC market closed today',
      'time': '2 రోజుల క్రితం',
      'icon': Icons.store,
      'color': Colors.purple,
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('నోటిఫికేషన్‌లు | Notifications'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in notifications) {
                  n['read'] = true;
                }
              });
            },
            child: const Text('అన్నిటా చదివావు | Mark all read', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: n['read'] ? Colors.white : Colors.green[50],
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (n['color'] as Color).withOpacity(0.2),
                child: Icon(n['icon'] as IconData, color: n['color'] as Color),
              ),
              title: Text(
                n['title'],
                style: TextStyle(
                  fontWeight: n['read'] ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(n['body']),
                  const SizedBox(height: 4),
                  Text(n['time'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              isThreeLine: true,
              trailing: n['read']
                  ? null
                  : Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
              onTap: () => setState(() => n['read'] = true),
            ),
          );
        },
      ),
    );
  }
}