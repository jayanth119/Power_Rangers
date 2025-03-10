import 'package:blood_donation/screens/BloodBankDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentLocation = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = "Location services are disabled";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = "Location permission denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = "Location permissions are permanently denied";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = "Lat: ${position.latitude}, Lng: ${position.longitude}";
    });
  }

  final List<Map<String, dynamic>> bloodBanks = [
    {
      "name": "G.B. Pant Hospital Blood bank",
      "pincode": "744104",
      "district": "SOUTH ANDAMAN",
      "state": "Andaman And Nicobar Islands",
      "latitude": 11.675442,
      "longitude": 92.747338,
      "available_blood_groups": {
        "A+": 23,
        "A-": 6,
        "B+": 77,
        "B-": 19,
        "O+": 73,
        "O-": 18,
        "AB+": 70,
        "AB-": 17,
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Text(
                    'Welcome, Jayanth',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$_currentLocation',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Icon(Icons.location_on, color: Colors.white),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: bloodBanks.length,
                itemBuilder: (context, index) {
                  final bloodBank = bloodBanks[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the details screen and pass the blood bank data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BloodBankDetailsScreen(
                            bloodBankDetails: bloodBank,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Icon(Icons.local_hospital, color: Colors.redAccent),
                        title: Text(bloodBank['name']),
                        subtitle: Text(
                          'State: ${bloodBank['state']}\n'
                          'Pincode: ${bloodBank['pincode']}',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}