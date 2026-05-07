import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebuilded_project/models/user_details.dart';
import 'package:rebuilded_project/models/appointment.dart';
import 'package:rebuilded_project/pages/starting_page.dart';
import 'package:rebuilded_project/pages/sign_in_page.dart';
import 'package:rebuilded_project/pages/sign_up_page.dart';
import 'package:rebuilded_project/pages/home_screen.dart';
import 'package:rebuilded_project/pages/appointment_booking_page.dart';
import 'package:rebuilded_project/pages/towing_booking_screen.dart';
import 'package:rebuilded_project/pages/doorstep_service_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// void main() {
//   runApp(CarServiceApp()); 
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(CarServiceApp());
}


class CarServiceApp extends StatefulWidget {
  @override
  _CarServiceAppState createState() => _CarServiceAppState();
}

class _CarServiceAppState extends State<CarServiceApp> {
  bool isLoggedIn = false;
  String currentUserEmail = '';
  late UserDetails userDetails;
  List<Appointment> appointments = [];
  List<Appointment> mlAppointments = [];

  Map<String, dynamic> carHealth = {
    'Engine': 'Good',
    'Engine Temperature': '90°C',
    'Tires': 'Average',
    'Oil Level': '80%',
    'Oil Quality': 'Good',
    'Fuel Level': '75%',
    'Brake Pads': 'Needs Replacement',
    'Battery Voltage': '12.6 V',
    'Battery Current': '5 A',
    'Battery Self Discharging rate': '0.02 %/day',
  };

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  bool isDarkMode = false;
  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    // Initialize ML appointments with dummy data
    mlAppointments = [
      Appointment(
        serviceTypes: ['Oil Change', 'Tire Rotation'],
        date: DateTime.now().add(Duration(days: 7)),
        userDetails: UserDetails(
          name: 'John Doe',
          email: 'john.doe@example.com',
          // password: 'password',
          contactNumber: '1234567890',
          address: '123 Main St',
          carCompany: 'Toyota',
          carName: 'Camry',
          carModel: 'SE',
          carNumber: 'ABC123',
          yearOfManufacture: '2020',
          color: 'Silver',
        ),
        problemDetails: 'ML-detected low oil level',
        pickupDropSelected: false,
        currentCarLocation: '',
      ),
      Appointment(
        serviceTypes: ['Brake Service'],
        date: DateTime.now().add(Duration(days: 10)),
        userDetails: UserDetails(
          name: 'John Doe',
          email: 'john.doe@example.com',
          // password: 'password',
          contactNumber: '1234567890',
          address: '123 Main St',
          carCompany: 'Toyota',
          carName: 'Camry',
          carModel: 'SE',
          carNumber: 'ABC123',
          yearOfManufacture: '2020',
          color: 'Silver',
        ),
        problemDetails: 'ML-detected brake pad wear',
        pickupDropSelected: true,
        currentCarLocation: '456 Elm St',
      ),
    ];
  }

  void login(String email) async{
    currentUserEmail=email;
    try{
      DocumentSnapshot userData= await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get();
      userDetails=UserDetails(
        name: userData.get('name'),
        email: userData.get('email'),
        contactNumber: userData.get('contactNumber'),
        address: userData.get('address'),
        carCompany: userData.get('carCompany'),
        carName: userData.get('carName'),
        carModel: userData.get('carModel'),
        carNumber: userData.get('carNumber'),
        yearOfManufacture: userData.get('yearOfManufacture'),
        color: userData.get('color')
      );
      isLoggedIn=true;
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(SnackBar(content: Text('Login Succesfully')));
    } on FirebaseException catch(e){
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(SnackBar(content: Text('Error: ${e.code}')));
      return;
    }
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          logout: logout,
          carHealth: carHealth,
          currentUserEmail: email,
          userDetails: userDetails,
          appointments: appointments,
          mlAppointments: mlAppointments,
          addAppointment: addAppointment,
          cancelAppointment: cancelAppointment,
          cancelMLAppointment: cancelMLAppointment,
          postponeAppointment: postponeAppointment,
          updateUserDetails: updateUserDetails,
          isDarkMode: isDarkMode,
          notificationsEnabled: notificationsEnabled,
          onDarkModeChanged: onDarkModeChanged,
          onNotificationsChanged: onNotificationsChanged,
        ),
      ),
          (route) => false,
    );
  }

  void signup() {
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => SignInPage(login: login),
      ),
          (route) => false,
    );
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
      currentUserEmail = '';
    });
    navigatorKey.currentState!.pushNamedAndRemoveUntil('/', (route) => false);
  }

  void addAppointment(Appointment appointment) {
    setState(() {
      appointments.add(appointment);
    });
  }

  void cancelAppointment(String apptId) {
    ScaffoldMessenger.of(navigatorKey.currentContext!)
        .showSnackBar(SnackBar(content: Text('Error: implementatio of cancel apointment is not done')));
  }

  void cancelMLAppointment(int index) {
    setState(() {
      mlAppointments.removeAt(index);
    });
  }

  void postponeAppointment(int index, DateTime newDate) {
    setState(() {
      appointments[index] = appointments[index].copyWith(date: newDate);
    });
  }

  void updateUserDetails(UserDetails updatedDetails) {
    setState(() {
      userDetails = updatedDetails;
    });
  }

  void onDarkModeChanged(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  void onNotificationsChanged(bool value) {
    setState(() {
      notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Car Service App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => isLoggedIn
            ? HomeScreen(
          logout: logout,
          carHealth: carHealth,
          currentUserEmail: currentUserEmail,
          userDetails: userDetails,
          appointments: appointments,
          mlAppointments: mlAppointments,
          addAppointment: addAppointment,
          cancelAppointment: cancelAppointment,
          cancelMLAppointment: cancelMLAppointment,
          postponeAppointment: postponeAppointment,
          updateUserDetails: updateUserDetails,
          isDarkMode: isDarkMode,
          notificationsEnabled: notificationsEnabled,
          onDarkModeChanged: onDarkModeChanged,
          onNotificationsChanged: onNotificationsChanged,
        )
            : StartingPage(
          onSignIn: () {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (context) => SignInPage(login: login),
              ),
            );
          },
          onSignUp: () {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (context) => SignUpPage(signup: signup),
              ),
            );
          },
        ),
        '/appointment': (context) {
          if (!isLoggedIn || currentUserEmail.isEmpty || !(userDetails.email==currentUserEmail)) {
            // Redirect to StartingPage if user is not logged in or userDetails is missing
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please log in to book appointments')),
              );
            });
            return StartingPage(
              onSignIn: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage(login: login)),
                );
              },
              onSignUp: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage(signup: signup)),
                );
              },
            );
          }
          return AppointmentBookingPage(
            appointments: appointments,
            addAppointment: addAppointment,
            cancelAppointment: cancelAppointment,
            postponeAppointment: postponeAppointment,
            userDetails: userDetails,
          );
        },
        '/towing': (context) => TowingBookingScreen(),
        '/doorstep': (context) => DoorStepServiceScreen(),
      },
    );
  }
}