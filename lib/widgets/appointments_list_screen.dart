import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/appointment2.dart';
import '../models/appointment_repository.dart';

class AppointmentsListScreen extends StatefulWidget {
  final String currentEmailId;

  const AppointmentsListScreen({super.key, required this.currentEmailId});

  @override
  State<AppointmentsListScreen> createState() => _AppointmentsListScreenState();
}

class _AppointmentsListScreenState extends State<AppointmentsListScreen> {
  late final AppointmentRepository _repository = AppointmentRepository();
  late Future<List<Appointment2>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = _repository.getAppointmentsByEmail(widget.currentEmailId);
  }

  Future<void> _showDatePicker(BuildContext context, String apptId, DateTime currentDate) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newDate == null) return; // User canceled the picker

    if (newDate == currentDate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selected date is same as current date')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(apptId)
          .update({
        'date': Timestamp.fromDate(newDate),
      });

      // Refresh the appointments list
      setState(() {
        _appointmentsFuture = _repository.getAppointmentsByEmail(widget.currentEmailId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment date updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update appointment: $e')),
      );
    }
  }

  Future<void> _cancelAppointment(String apptId) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(apptId)
          .delete();

      setState(() {
        _appointmentsFuture = _repository.getAppointmentsByEmail(widget.currentEmailId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete appointment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Appointment2>>(
      future: _appointmentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final appointments = snapshot.data ?? [];
        if (appointments.isEmpty) {
          return const Center(child: Text('No appointments found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: appointments.length,
          itemBuilder: (ctx, index) {
            final appt = appointments[index];
            final apptId = appt.appointmentId;

            void showReceiptDialog() {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Receipt'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Appointment Date: ${appt.date.toLocal().toString().split(" ")[0]}'),
                        const SizedBox(height: 8),
                        const Text('Services:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...appt.serviceTypes.map((service) => Text('- $service')),
                        const SizedBox(height: 12),
                        Text('Total Amount: \$${(appt.serviceTypes.length * 50).toStringAsFixed(2)}'),
                        const SizedBox(height: 12),
                        const Text('Thank you for choosing AutoCare Center!'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(appt.serviceTypes.join(', ')),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${appt.date.toLocal().toString().split(" ")[0]}'),
                          if (appt.problemDetails.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text('Problem Details: ${appt.problemDetails}'),
                          ],
                          if (appt.pickupDropSelected) ...[
                            const SizedBox(height: 4),
                            const Text('Pickup and Drop Service: Yes'),
                            if (appt.currentCarLocation.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text('Current Car Location: ${appt.currentCarLocation}'),
                            ],
                          ],
                        ],
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'Cancel') {
                            _cancelAppointment(apptId);
                          } else if (value == 'Postpone') {
                            _showDatePicker(context, apptId, appt.date);
                          }
                        },
                        itemBuilder: (ctx) => const [
                          PopupMenuItem(value: 'Cancel', child: Text('Cancel')),
                          PopupMenuItem(value: 'Postpone', child: Text('Postpone')),
                        ],
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: showReceiptDialog,
                          child: const Text('Receipt'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}