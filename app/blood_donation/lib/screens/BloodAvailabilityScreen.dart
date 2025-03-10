import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BloodAvailabilityScreen extends StatefulWidget {
  @override
  _BloodAvailabilityScreenState createState() =>
      _BloodAvailabilityScreenState();
}

class _BloodAvailabilityScreenState extends State<BloodAvailabilityScreen> {
  List<Map<String, dynamic>> bloodData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBloodAvailability();
  }

  Future<void> fetchBloodAvailability() async {
    const String apiUrl = "http://127.0.0.1:8000/get_bloodbanks";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);

        // Transforming response data to display in UI
        List<Map<String, dynamic>> tempData = [];
        for (var item in responseData) {
          item['available_blood_groups'].forEach((bloodGroup, quantity) {
            tempData.add({
              "bloodGroup": bloodGroup,
              "bloodBankName": item['name'],
              "city": item['district'],
              "state": item['state'],
              "quantity": quantity,
            });
          });
        }

        setState(() {
          bloodData = tempData;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load blood availability data");
      }
    } catch (error) {
      print("Error: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Available blood groups
  final List<String> bloodGroups = [
    'All',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  // Currently selected blood group filter
  String selectedBloodGroup = 'All';

  // Filtered blood data
  List<Map<String, dynamic>> get filteredBloodData {
    if (selectedBloodGroup == 'All') {
      return bloodData;
    } else {
      return bloodData
          .where((blood) => blood['bloodGroup'] == selectedBloodGroup)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blood Availability",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFFF3B5B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Dropdown filter
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButton<String>(
              value: selectedBloodGroup,
              isExpanded: true,
              underline: SizedBox(),
              icon: Icon(Icons.arrow_drop_down, color: Colors.redAccent),
              items: bloodGroups.map((String group) {
                return DropdownMenuItem<String>(
                  value: group,
                  child: Text(
                    group,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedBloodGroup = newValue!;
                });
              },
            ),
          ),

          // Display blood availability data
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredBloodData.isEmpty
                    ? Center(
                        child: Text(
                          "No blood data available for $selectedBloodGroup",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredBloodData.length,
                        itemBuilder: (context, index) {
                          var blood = filteredBloodData[index];
                          return Card(
                            margin: EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.bloodtype,
                                          color: Colors.redAccent, size: 24),
                                      SizedBox(width: 10),
                                      Text(
                                        "Blood Group: ${blood['bloodGroup']}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.blue, size: 22),
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
                                      Icon(Icons.inventory,
                                          color: Colors.green, size: 22),
                                      SizedBox(width: 10),
                                      Text(
                                        "Quantity Available: ${blood['quantity']} units",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
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