import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AskBloodScreen extends StatefulWidget {
  const AskBloodScreen({Key? key}) : super(key: key);

  @override
  _AskBloodScreenState createState() => _AskBloodScreenState();
}

class _AskBloodScreenState extends State<AskBloodScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _hospitalLocationController =
      TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _unitsRequiredController =
      TextEditingController();
  final TextEditingController _timeUntilController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  Future<void> _sendSMS(String bloodgroup ) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/send-email'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "recipient": "chjayanth119@gmail.com",
          "subject": "Blood required in your Area ",
          "body": "Hey User urgent need of $bloodgroup  group . if you want help please contact "
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('SMS sent successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send SMS')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending SMS: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Blood'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Patient Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _patientNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter patient name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter patient name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Age',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  hintText: 'Enter age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Blood Group',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bloodGroupController,
                decoration: const InputDecoration(
                  hintText: 'Enter blood group',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter blood group';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Hospital Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _hospitalLocationController,
                decoration: const InputDecoration(
                  hintText: 'Enter hospital location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hospital location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Contact Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contactNumberController,
                decoration: const InputDecoration(
                  hintText: 'Enter contact number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Units Required',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _unitsRequiredController,
                decoration: const InputDecoration(
                  hintText: 'Enter units required',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter units required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Time Until',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _timeUntilController,
                decoration: const InputDecoration(
                  hintText: 'Enter time until',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter time until';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Notes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Enter notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter notes';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                String _blood = _bloodGroupController.text; 
                 await  _sendSMS(_blood); 
                  // api integrations to send email url "http://127.0.0.1:8000/send-email"
                  // api integrations to send sms url "http://127.0.0.1:8000/send-sms"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
