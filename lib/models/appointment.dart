import 'user_details.dart';

class Appointment {
  final List<String> serviceTypes;
  final DateTime date;
  final UserDetails userDetails;
  final String problemDetails;
  final bool pickupDropSelected;
  final String currentCarLocation;

  Appointment({
    required this.serviceTypes,
    required this.date,
    required this.userDetails,
    this.problemDetails = '',
    this.pickupDropSelected = false,
    this.currentCarLocation = '',
  });

  Appointment copyWith({
    List<String>? serviceTypes,
    DateTime? date,
    UserDetails? userDetails,
    String? problemDetails,
    bool? pickupDropSelected,
    String? currentCarLocation,
  }) {
    return Appointment(
      serviceTypes: serviceTypes ?? this.serviceTypes,
      date: date ?? this.date,
      userDetails: userDetails ?? this.userDetails,
      problemDetails: problemDetails ?? this.problemDetails,
      pickupDropSelected: pickupDropSelected ?? this.pickupDropSelected,
      currentCarLocation: currentCarLocation ?? this.currentCarLocation,
    );
  }
}