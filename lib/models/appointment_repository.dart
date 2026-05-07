import 'package:cloud_firestore/cloud_firestore.dart';
import 'appointment2.dart';
// import 'appointment2.dart'; // Your Appointment2 class file

class AppointmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all appointments
  Future<List<Appointment2>> getAllAppointments() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('appointments')
          .get();

      return querySnapshot.docs
          .map((doc) => Appointment2.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  // Fetch appointments for specific email
  Future<List<Appointment2>> getAppointmentsByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('appointments')
          .where('emailId', isEqualTo: email)
          .get();

      return querySnapshot.docs
          .map((doc) => Appointment2.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }
}