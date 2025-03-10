import 'package:flutter/material.dart';

class BloodAvailabilityScreen extends StatefulWidget {
  @override
  _BloodAvailabilityScreenState createState() => _BloodAvailabilityScreenState();
}

class _BloodAvailabilityScreenState extends State<BloodAvailabilityScreen> {
  // Static dummy data
  List<Map<String, dynamic>> bloodData = [
    {
      "bloodGroup": "A+",
      "bloodBankName": "City Blood Bank",
      "city": "New York",
      "state": "NY",
      "quantity": 12
    },
    {
      "bloodGroup": "O-",
      "bloodBankName": "Metro Blood Center",
      "city": "Los Angeles",
      "state": "CA",
      "quantity": 8
    },
    {
      "bloodGroup": "B+",
      "bloodBankName": "Sunshine Blood Bank",
      "city": "Chicago",
      "state": "IL",
      "quantity": 15
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blood Availability",
          style: TextStyle(
            color: Colors.white, // White text for contrast
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFFF3B5B), // Red background
        iconTheme: IconThemeData(color: Colors.white), // White back button
      ),
      body: bloodData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bloodData.length,
              itemBuilder: (context, index) {
                var blood = bloodData[index];
                return Card(
                  margin: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.bloodtype, color: Colors.redAccent, size: 24),
                            SizedBox(width: 10),
                            Text(
                              "Blood Group: ${blood['bloodGroup']}",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.blue, size: 22),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Blood Bank: ${blood['bloodBankName']}, ${blood['city']}, ${blood['state']}",
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.inventory, color: Colors.green, size: 22),
                            SizedBox(width: 10),
                            Text(
                              "Quantity Available: ${blood['quantity']} units",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
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