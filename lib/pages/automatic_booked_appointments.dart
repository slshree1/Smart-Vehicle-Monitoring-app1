import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rebuilded_project/models/appointment.dart';

class AutomaticBookedAppointments extends StatelessWidget {
  final List<Appointment> mlAppointments;
  final String currentUserEmail;
  final Function(int) cancelMLAppointment;

  AutomaticBookedAppointments({
    required this.mlAppointments,
    required this.currentUserEmail,
    required this.cancelMLAppointment,
  });

  @override
  Widget build(BuildContext context) {
    final userMLAppointments = mlAppointments
        .where((appt) => appt.userDetails.email == currentUserEmail)
        .toList();

    if (userMLAppointments.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Automatic Booked Appointments'),
        ),
        body: Center(child: Text('No ML-generated appointments found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Automatic Booked Appointments'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: userMLAppointments.length,
        itemBuilder: (context, index) {
          final appt = userMLAppointments[index];
          final globalIndex = mlAppointments.indexOf(appt);
          final cost = appt.serviceTypes.length * 50; // Same cost logic as AppointmentsListScreen

          return Card(
            margin: EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      appt.serviceTypes.join(', '),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${DateFormat('yyyy-MM-dd').format(appt.date)}'),
                        SizedBox(height: 4),
                        Text('Car: ${appt.userDetails.carCompany} ${appt.userDetails.carName} ${appt.userDetails.carModel}'),
                        Text('Car Number: ${appt.userDetails.carNumber}'),
                        Text('Owner: ${appt.userDetails.name}'),
                        Text('Contact: ${appt.userDetails.contactNumber}'),
                        Text('Cost: \$${cost.toStringAsFixed(2)}'),
                        if (appt.problemDetails.isNotEmpty) ...[
                          SizedBox(height: 4),
                          Text('Problem Details: ${appt.problemDetails}'),
                        ],
                        if (appt.pickupDropSelected) ...[
                          SizedBox(height: 4),
                          Text('Pickup and Drop Service: Yes'),
                          if (appt.currentCarLocation.isNotEmpty) ...[
                            SizedBox(height: 2),
                            Text('Current Car Location: ${appt.currentCarLocation}'),
                          ],
                        ],
                      ],
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Cancel') {
                          cancelMLAppointment(globalIndex);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('ML Appointment cancelled')),
                          );
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(value: 'Cancel', child: Text('Cancel')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}