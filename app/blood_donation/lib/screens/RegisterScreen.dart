import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome", style: TextStyle(fontSize: 24)),
            Text("REGISTER", style: TextStyle(fontSize: 28, color: Colors.red)),
            TextFormField(decoration: InputDecoration(labelText: 'Name')),
            TextFormField(decoration: InputDecoration(labelText: 'Blood Group')),
            TextFormField(decoration: InputDecoration(labelText: 'Email')),
            TextFormField(decoration: InputDecoration(labelText: 'Phone')),
            TextFormField(decoration: InputDecoration(labelText: 'Address')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}