
import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment2 {
  final String appointmentId;
  final String emailId;
  final List<String> serviceTypes;
  final DateTime date;
  final String problemDetails;
  final bool pickupDropSelected;
  final String currentCarLocation;
  final String serviceStatus;



  Appointment2({
    required this.appointmentId,
    required this.emailId,
    required this.serviceTypes,
    required this.date,
    this.problemDetails='',
    this.pickupDropSelected = false,
    this.currentCarLocation = '',
    required this.serviceStatus,
  });

  factory Appointment2.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Appointment2(
      appointmentId: doc.id,
      emailId: data['email'] ?? '',
      serviceTypes: List<String>.from(data['serviceTypes'] ?? []),
      date: (data['date'] as Timestamp).toDate(),
      problemDetails: data['problemDetails'] ?? '',
      pickupDropSelected: data['pickDropSelected'] ?? false,
      currentCarLocation: data['currentCarLocation'] ?? '',
      serviceStatus: data['serviceStatus'] ?? 'Pending',
    );
  }
}








// Appointment copyWith({
//   List<String>? serviceTypes,
//   DateTime? date,
//   UserDetails? userDetails,
//   String? problemDetails,
//   bool? pickupDropSelected,
//   String? currentCarLocation,
// }) {
//   return Appointment(
//     serviceTypes: serviceTypes ?? this.serviceTypes,
//     date: date ?? this.date,
//     userDetails: userDetails ?? this.userDetails,
//     problemDetails: problemDetails ?? this.problemDetails,
//     pickupDropSelected: pickupDropSelected ?? this.pickupDropSelected,
//     currentCarLocation: currentCarLocation ?? this.currentCarLocation,
//   );
// }