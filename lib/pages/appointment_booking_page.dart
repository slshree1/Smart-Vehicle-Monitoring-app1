import 'package:flutter/material.dart';
import 'package:rebuilded_project/models/appointment.dart';
import 'package:rebuilded_project/models/user_details.dart';
import 'package:rebuilded_project/widgets/appointment_form.dart';
import 'package:rebuilded_project/widgets/appointments_list_screen.dart';

class AppointmentBookingPage extends StatefulWidget {
  final List<Appointment> appointments;
  final Function(Appointment) addAppointment;
  final Function(String) cancelAppointment;
  final Function(int, DateTime) postponeAppointment;
  final UserDetails userDetails;

  AppointmentBookingPage({
    required this.appointments,
    required this.addAppointment,
    required this.cancelAppointment,
    required this.postponeAppointment,
    required this.userDetails,
  });

  @override
  _AppointmentBookingPageState createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> tabs = [
    Tab(text: 'Book Appointment'),
    Tab(text: 'My Appointments'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Booking'),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AppointmentForm(
            addAppointment: widget.addAppointment,
            userDetails: widget.userDetails,
          ),
          AppointmentsListScreen(
            currentEmailId: widget.userDetails.email,
          ),
        ],
      ),
    );
  }
}