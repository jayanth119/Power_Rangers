import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  Future<void> _scheduleAppointment() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Validate input fields
    if (_donorNameController.text.isEmpty ||
        _bloodGroupController.text.isEmpty ||
        _latitudeController.text.isEmpty ||
        _longitudeController.text.isEmpty) {
      setState(() {
        _error = "Please fill all fields.";
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> requestData = {
      "donor_name": _donorNameController.text,
      "blood_group": _bloodGroupController.text,
      "donor_location": [
        double.tryParse(_latitudeController.text) ?? 0.0,
        double.tryParse(_longitudeController.text) ?? 0.0
      ],
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/schedule_appointment'),
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
        title: Text('Blood Donation'),
        backgroundColor: Color(0xFFE53935),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
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
          _buildTextField(_latitudeController, "Latitude", keyboardType: TextInputType.number),
          _buildTextField(_longitudeController, "Longitude", keyboardType: TextInputType.number),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _scheduleAppointment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE53935),
              foregroundColor: Colors.white,
            ),
            child: Text('Schedule Appointment'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFFE53935),
          ),
          SizedBox(height: 16),
          Text('Scheduling appointment...'),
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
            Icon(
              Icons.error_outline,
              color: Color(0xFFE53935),
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'Appointment Failed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE53935),
                foregroundColor: Colors.white,
              ),
              child: Text('Try Again'),
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
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  'Appointment Scheduled!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB71C1C),
                  ),
                ),
                SizedBox(height: 24),
                _buildInfoItem('Donor', _response?['donor'] ?? ''),
                _buildInfoItem('Blood Group', _response?['blood_group'] ?? ''),
                _buildInfoItem('Blood Bank', _response?['blood_bank'] ?? ''),
                _buildInfoItem('Location', _response?['location'] ?? ''),
                _buildInfoItem('Appointment', _response?['appointment_time'] ?? ''),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE53935),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Done'),
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}