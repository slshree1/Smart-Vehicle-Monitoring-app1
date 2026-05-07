import 'package:flutter/material.dart';
import 'package:rebuilded_project/models/user_details.dart';
import 'package:rebuilded_project/models/appointment.dart';
import 'package:rebuilded_project/pages/account_screen.dart';
import 'package:rebuilded_project/pages/settings_screen.dart';
import 'package:rebuilded_project/pages/service_history_screen.dart';
import 'package:rebuilded_project/pages/automatic_booked_appointments.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback logout;
  final Map<String, dynamic> carHealth;
  final String currentUserEmail;
  final UserDetails userDetails;
  final List<Appointment> appointments;
  final List<Appointment> mlAppointments; // New
  final Function(Appointment) addAppointment;
  final Function(String) cancelAppointment;
  final Function(int) cancelMLAppointment; // New
  final Function(int, DateTime) postponeAppointment;
  final Function(UserDetails) updateUserDetails;
  final bool isDarkMode;
  final bool notificationsEnabled;
  final Function(bool) onDarkModeChanged;
  final Function(bool) onNotificationsChanged;




  HomeScreen({
    required this.logout,
    required this.carHealth,
    required this.currentUserEmail,
    required this.userDetails,
    required this.appointments,
    required this.mlAppointments, // New
    required this.addAppointment,
    required this.cancelAppointment,
    required this.cancelMLAppointment, // New
    required this.postponeAppointment,
    required this.updateUserDetails,
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.onDarkModeChanged,
    required this.onNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AutoCare Center'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              tooltip: 'Menu',
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Account'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountScreen(
                      userDetails: userDetails,
                      onSave: updateUserDetails,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Service History'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceHistoryScreen(
                      appointments: appointments,
                      currentUserEmail: currentUserEmail,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.auto_fix_high),
              title: Text('Automatic Booked Appointments'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AutomaticBookedAppointments(
                      mlAppointments: mlAppointments,
                      currentUserEmail: currentUserEmail,
                      cancelMLAppointment: cancelMLAppointment,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      isDarkMode: isDarkMode,
                      notificationsEnabled: notificationsEnabled,
                      onDarkModeChanged: onDarkModeChanged,
                      onNotificationsChanged: onNotificationsChanged,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Navigator.of(context).pop();

                logout();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 0, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome, ${userDetails.name}!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text('Car Health',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double maxWidth = constraints.maxWidth;
                        double itemWidth = 120;
                        double spacing = 12;
                        int itemsPerRow = (maxWidth - spacing) ~/ (itemWidth + 12);
                        itemsPerRow = itemsPerRow > 0 ? itemsPerRow : 1;
                        double totalSpacing = spacing * (itemsPerRow - 1);
                        double adjustedItemWidth = (maxWidth - totalSpacing) / itemsPerRow;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Car Health Parameters',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 12),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                int crossAxisCount = ((constraints.maxWidth - 0) / 140).floor();
                                crossAxisCount = crossAxisCount > 0 ? crossAxisCount : 1;
                                return GridView.count(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  childAspectRatio: 1.2,
                                  children: [
                                    ...carHealth.entries.map((e) {
                                      Color statusColor;
                                      if (e.value is String) {
                                        switch ((e.value as String).toLowerCase()) {
                                          case 'good':
                                            statusColor = Colors.green;
                                            break;
                                          case 'average':
                                            statusColor = Colors.orange;
                                            break;
                                          case 'needs replacement':
                                            statusColor = Colors.red;
                                            break;
                                          default:
                                            statusColor = Colors.grey;
                                        }
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: statusColor.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: statusColor, width: 1.5),
                                          ),
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                e.key,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: statusColor,
                                                ),
                                              ),
                                              SizedBox(height: 0.1),
                                              Text(
                                                e.value,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: statusColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }).toList(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.blue, width: 1.5),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Days after car needs servicing',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.blue,
                                            ),
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '10',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text('Door Step Service',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.book_online),
                    label: Text('Appointment Booking'),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/appointment');
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.local_taxi),
                    label: Text('Towing Service'),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/towing');
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.home_repair_service),
                    label: Text('Door Step Service'),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/doorstep');
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}