import 'package:blood_donation/screens/HomeScreen.dart';
import 'package:blood_donation/screens/bottomNavabar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentScheduleScreen extends StatefulWidget {
  const AppointmentScheduleScreen({Key? key}) : super(key: key);

  @override
  _AppointmentScheduleScreenState createState() =>
      _AppointmentScheduleScreenState();
}

class _AppointmentScheduleScreenState extends State<AppointmentScheduleScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _response;
  String? _error;

  // Controllers for user input
  final TextEditingController _donorNameController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();

  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _getLocationFromSharedPreferences();
  }

  Future<void> _getLocationFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _latitude = prefs.getDouble('latitude') ?? 0.0;
      _longitude = prefs.getDouble('longitude') ?? 0.0;
    });
  }

  Future<void> _scheduleAppointment() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Validate input fields
    if (_donorNameController.text.isEmpty ||
        _bloodGroupController.text.isEmpty ) {
      setState(() {
        _error = "Please fill all fields.";
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> requestData = {
      "donor_name": _donorNameController.text,
      "blood_group": _bloodGroupController.text,
      "donor_location": [_latitude, _longitude],
    };

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/schedule_appointment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        setState(() {
          _response = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to schedule appointment');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Donation'),
        backgroundColor: const Color(0xFFE53935),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: _isLoading
            ? _buildLoadingView()
            : _error != null
                ? _buildErrorView()
                : _response == null
                    ? _buildInputForm()
                    : _buildSuccessView(),
      ),
    );
  }

  Widget _buildInputForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTextField(_donorNameController, "Donor Name"),
          _buildTextField(_bloodGroupController, "Blood Group"),
          Text(
            'Latitude: ${_latitude ?? 'Fetching...'}',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Text(
            'Longitude: ${_longitude ?? 'Fetching...'}',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _scheduleAppointment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
            ),
            child: const Text('Schedule Appointment'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFFE53935),
          ),
          const SizedBox(height: 16),
          const Text('Scheduling appointment...'),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFFE53935),
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Appointment Failed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Appointment Scheduled!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB71C1C),
                  ),
                ),
                _buildInfoItem('Donor', _response?['donor'] ?? ''),
                _buildInfoItem('Blood Group', _response?['blood_group'] ?? ''),
                _buildInfoItem('Blood Bank', _response?['blood_bank'] ?? ''),
                _buildInfoItem('Location', _response?['location'] ?? ''),
                _buildInfoItem(
                    'Appointment', _response?['appointment_time'] ?? ''),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavBar()),
                    ),
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}