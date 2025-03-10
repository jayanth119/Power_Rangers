import 'package:flutter/material.dart';
import 'dart:math';

class BloodBankDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> bloodBankDetails;

  const BloodBankDetailsScreen({Key? key, required this.bloodBankDetails})
      : super(key: key);

  // Function to generate random blood units
  Map<String, int> generateBloodData() {
    final Random random = Random();
    Map<String, int> bloodData = {
      'A+': random.nextInt(20),
      'A-': random.nextInt(20),
      'B+': random.nextInt(20),
      'B-': random.nextInt(20),
      'O+': random.nextInt(20),
      'O-': random.nextInt(20),
      'AB+': random.nextInt(20),
      'AB-': random.nextInt(20),
    };

    return bloodData;
  }

  // Function to determine low stock blood groups
  List<String> findLowStockGroups(Map<String, int> bloodData) {
    List<String> lowStock = [];
    bloodData.forEach((key, value) {
      if (value < 5) {
        lowStock.add(key);
      }
    });
    return lowStock;
  }

  @override
  Widget build(BuildContext context) {
    final bloodData = generateBloodData();
    final lowStockGroups = findLowStockGroups(bloodData);

    return Scaffold(
      appBar: AppBar(
        title: Text(bloodBankDetails['name']),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blood Bank Name: ${bloodBankDetails['name']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('State: ${bloodBankDetails['state']}'),
            Text('District: ${bloodBankDetails['district']}'),
            Text('Pincode: ${bloodBankDetails['pincode']}'),
            Text('Latitude: ${bloodBankDetails['latitude']}'),
            Text('Longitude: ${bloodBankDetails['longitude']}'),
            SizedBox(height: 20),
            Text(
              'Available Blood Groups:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...bloodData.entries.map((entry) {
              return ListTile(
                leading: Icon(Icons.bloodtype, color: Colors.redAccent),
                title: Text('${entry.key}: ${entry.value} units'),
              );
            }).toList(),
            SizedBox(height: 20),
            Text(
              'Low Stock Blood Groups:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (lowStockGroups.isNotEmpty)
              Wrap(
                spacing: 8,
                children: lowStockGroups.map((group) => Chip(
                  label: Text(group),
                  backgroundColor: Colors.red.shade100,
                )).toList(),
              )
            else
              Text('No shortages currently. All stocks are sufficient.'),
          ],
        ),
      ),
    );
  }
}