import 'package:flutter/material.dart';

class BloodBankDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> bloodBankDetails;

  const BloodBankDetailsScreen({Key? key, required this.bloodBankDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ...bloodBankDetails['available_blood_groups'].entries.map((entry) {
              return Text('${entry.key}: ${entry.value} units');
            }).toList(),
          ],
        ),
      ),
    );
  }
}