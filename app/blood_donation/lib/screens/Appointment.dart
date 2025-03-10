import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  bool _isLoading = true;
  String _errorMessage = '';

  // Appointment details
  String _location = '';
  DateTime? _date;
  TimeOfDay? _time;
  String _confirmationId = '';

  @override
  void initState() {
    super.initState();
    _fetchAppointmentDetails();
  }

  // Dummy API call to fetch appointment details
  Future<void> _fetchAppointmentDetails() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Simulate API response
      final Map<String, dynamic> appointmentData = {
        'location': 'City Blood Bank - Downtown Center',
        'date': '2025-03-15',
        'time': '10:30',
        'confirmationId':
            'BD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}',
      };

      setState(() {
        _location = appointmentData['location'];
        _date = DateTime.parse(appointmentData['date']);

        // Parse time string to TimeOfDay
        final timeParts = appointmentData['time'].split(':');
        _time = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );

        _confirmationId = appointmentData['confirmationId'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'Failed to load appointment details. Please try again later.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? _buildLoadingView()
          : _errorMessage.isNotEmpty
              ? _buildErrorView()
              : _buildConfirmationView(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFFFF3B5B),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading your appointment details...',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[400],
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = '';
                });
                _fetchAppointmentDetails();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationView() {
    final dateFormatter = DateFormat('EEEE, MMMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Confirmation'), // AppBar label
        backgroundColor: const Color(0xFFFF3B5B), // Optional: Set AppBar color
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Success icon and header
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.green[400],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Appointment Confirmed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF3B5B),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Thank you for your commitment to save lives',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Confirmation ID
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B5B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFF3B5B).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Confirmation ID',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _confirmationId,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Appointment Details Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Appointment Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF3B5B),
                          ),
                        ),
                        const Divider(height: 30),

                        // Location
                        _buildDetailRow(
                          icon: Icons.location_on,
                          iconColor: const Color(0xFFFF3B5B),
                          title: 'Location',
                          content: _location,
                        ),
                        const SizedBox(height: 20),

                        // Date
                        _buildDetailRow(
                          icon: Icons.calendar_today,
                          iconColor: Colors.blue,
                          title: 'Date',
                          content: _date != null
                              ? dateFormatter.format(_date!)
                              : 'Unknown',
                        ),
                        const SizedBox(height: 20),

                        // Time
                        _buildDetailRow(
                          icon: Icons.access_time,
                          iconColor: Colors.orange,
                          title: 'Time',
                          content: _time != null
                              ? _time!.format(context)
                              : 'Unknown',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Instructions
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.amber[700],
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Important Information',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInstructionItem(
                          'Please arrive 15 minutes before your scheduled time.',
                        ),
                        _buildInstructionItem(
                          'Bring a valid photo ID with you.',
                        ),
                        _buildInstructionItem(
                          'Stay hydrated and eat a healthy meal before donating.',
                        ),
                        _buildInstructionItem(
                          'Wear comfortable clothing with sleeves that can be rolled up.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Add to Calendar and Home buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Calendar functionality would go here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to calendar'),
                              backgroundColor: Color(0xFFFF3B5B),
                            ),
                          );
                        },
                        icon: const Icon(Icons.calendar_month),
                        label: const Text('Add to Calendar'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFFFF3B5B)),
                          foregroundColor: const Color(0xFFFF3B5B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        icon: const Icon(Icons.home),
                        label: const Text('Home'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(0xFFFF3B5B),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: Colors.grey[700],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
