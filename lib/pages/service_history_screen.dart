import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rebuilded_project/models/appointment.dart';

class ServiceHistoryScreen extends StatelessWidget {
  final List<Appointment> appointments;
  final String currentUserEmail;

  ServiceHistoryScreen({
    required this.appointments,
    required this.currentUserEmail,
  });

  @override
  Widget build(BuildContext context) {
    // Filter appointments for the current user and past dates
    final pastAppointments = appointments
        .where((appt) =>
    appt.userDetails.email == currentUserEmail &&
        appt.date.isBefore(DateTime.now()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Service History'),
      ),
      body: pastAppointments.isEmpty
          ? Center(child: Text('No service history found'))
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: pastAppointments.length,
        itemBuilder: (context, index) {
          final appt = pastAppointments[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appt.serviceTypes.join(', '),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Date: ${DateFormat('yyyy-MM-dd').format(appt.date)}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Car: ${appt.userDetails.carCompany} ${appt.userDetails.carName} ${appt.userDetails.carModel}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Car Number: ${appt.userDetails.carNumber}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Owner: ${appt.userDetails.name}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Contact: ${appt.userDetails.contactNumber}',
                    style: TextStyle(fontSize: 14),
                  ),
                  if (appt.problemDetails.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text(
                      'Problem Details: ${appt.problemDetails}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                  if (appt.pickupDropSelected) ...[
                    SizedBox(height: 8),
                    Text(
                      'Pickup and Drop Service: Yes',
                      style: TextStyle(fontSize: 14),
                    ),
                    if (appt.currentCarLocation.isNotEmpty)
                      Text(
                        'Location: ${appt.currentCarLocation}',
                        style: TextStyle(fontSize: 14),
                      ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}