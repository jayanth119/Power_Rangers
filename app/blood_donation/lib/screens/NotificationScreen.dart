import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'Test Rated you 5 Stars.',
      'date': 'Feb 6 2024',
      'description': 'Rated for Donation for John.',
    },
    {
      'title': 'Donate Request Accepted',
      'date': 'Feb 6 2024',
      'description': 'Your donate request for John has been accepted.',
    },
    {
      'title': 'Nearby Blood Donation Request',
      'date': 'Feb 6 2024',
      'description': 'John needs B Positive (B+) Blood. Donate or Share to someone you know.',
    },
    {
      'title': 'Donate Request Accepted',
      'date': 'Feb 4 2024',
      'description': 'Your donate request for Patient Two has been accepted.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['title']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification['date']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification['description']!,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}