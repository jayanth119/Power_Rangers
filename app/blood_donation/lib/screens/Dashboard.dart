import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Track the selected tab (Requested or Donated)
  int _selectedTab = 0;

  // Dummy data for requested and donated blood
  final List<Map<String, String>> requestedData = [
    {
      'name': 'Patient One',
      'address': '1275 Connecticut St, San Francisco, 94107, United States',
      'status': 'Active',
    },
    {
      'name': 'Patient Two',
      'address': '456 Elm St, Los Angeles, 90001, United States',
      'status': 'Pending',
    },
  ];

  final List<Map<String, String>> donatedData = [
    {
      'name': 'Donor One',
      'address': '789 Oak St, New York, 10001, United States',
      'status': 'Completed',
    },
    {
      'name': 'Donor Two',
      'address': '321 Pine St, Chicago, 60601, United States',
      'status': 'Completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        children: [
          // Tabs for Requested and Donated
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 0; // Switch to Requested tab
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Requested',
                        style: TextStyle(
                          color: _selectedTab == 0 ? Colors.red : Colors.black,
                          fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 2,
                        width: 100,
                        color: _selectedTab == 0 ? Colors.red : Colors.transparent,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 1; // Switch to Donated tab
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Donated',
                        style: TextStyle(
                          color: _selectedTab == 1 ? Colors.red : Colors.black,
                          fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 2,
                        width: 100,
                        color: _selectedTab == 1 ? Colors.red : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Display data based on the selected tab
          Expanded(
            child: ListView.builder(
              itemCount: _selectedTab == 0 ? requestedData.length : donatedData.length,
              itemBuilder: (context, index) {
                final data = _selectedTab == 0 ? requestedData[index] : donatedData[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(data['name']!),
                    subtitle: Text(data['address']!),
                    trailing: Text(
                      data['status']!,
                      style: TextStyle(
                        color: data['status'] == 'Active'
                            ? Colors.red
                            : data['status'] == 'Pending'
                                ? Colors.orange
                                : Colors.green,
                      ),
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