import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blood_donation/screens/BloodBankDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentLocation = "Fetching location...";
  List<Map<String, dynamic>> bloodBanks = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadStoredLocation();
    _getCurrentLocation();
    _fetchBloodBanks();
  }

  Future<void> _loadStoredLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');

    if (latitude != null && longitude != null) {
      setState(() {
        _currentLocation = "Lat: $latitude, Lng: $longitude";
      });
    }
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', position.latitude);
    await prefs.setDouble('longitude', position.longitude);

    setState(() {
      _currentLocation =
          "Lat: ${position.latitude}, Lng: ${position.longitude}";
    });
  }

  Future<void> _fetchBloodBanks() async {
    final String apiUrl = 'http://127.0.0.1:8000/get_bloodbanks';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          bloodBanks = data.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load blood banks';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to connect to the server';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Location and welcome banner
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

            // Blood Banks List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(
                          child: Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : bloodBanks.isEmpty
                          ? Center(
                              child: Text(
                                "No blood banks available.",
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: bloodBanks.length > 5
                                  ? 5
                                  : bloodBanks.length,
                              itemBuilder: (context, index) {
                                final bloodBank = bloodBanks[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BloodBankDetailsScreen(
                                          bloodBankDetails: bloodBank,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 3,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 10),
                                    child: ListTile(
                                      leading: Icon(Icons.local_hospital,
                                          color: Colors.redAccent),
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