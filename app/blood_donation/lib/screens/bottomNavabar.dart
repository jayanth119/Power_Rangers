import 'package:blood_donation/screens/AskBloodScreen.dart';
import 'package:blood_donation/screens/BloodAvailabilityScreen.dart';
import 'package:blood_donation/screens/SheduleAppointment.dart';
import 'package:flutter/material.dart';
import 'Appointment.dart';
import 'Dashboard.dart';
import 'HomeScreen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    DashboardScreen(),
    BloodAvailabilityScreen(),
    AskBloodScreen(),
    AppointmentScheduleScreen(),
    AppointmentScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bloodtype),
            label: 'Blood Availability',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bloodtype),
            label: 'Ask Blood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_month_outlined),
            label: 'Appointment Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Appointment',
          ),
        ],
      ),
    );
  }
}