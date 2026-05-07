import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rebuilded_project/models/appointment.dart';
import 'package:rebuilded_project/models/user_details.dart';

class AppointmentForm extends StatefulWidget {
  final Function(Appointment) addAppointment;
  final UserDetails userDetails;

  AppointmentForm({required this.addAppointment, required this.userDetails});

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  List<String> selectedServices = [];
  DateTime? selectedDate;
  final TextEditingController problemDetailsController = TextEditingController();
  bool pickupDropSelected = false;
  final TextEditingController currentCarLocationController = TextEditingController();

  final List<String> services = [
    'Wash',
    'Full Repair',
    'Full Checkup',
    'Tyre Replacement',
    'Engine Checking',
    'Engine Repair',
    'Oil Change',
    'Brake Service',
    'Battery Replacement',
  ];

  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now().add(Duration(days: 1));
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void submit() async{
    if (selectedServices.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select at least one service and date')));
      return;
    } else if(selectedDate==null){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select date')));
    }

    try{
      DocumentReference docRef =await FirebaseFirestore.instance.collection('appointments').add({
        'appointmentId': '',
        'emailId':widget.userDetails.email,
        'serviceTypes': selectedServices,
        'date': selectedDate,
        'problemDetails': problemDetailsController.text.trim(),
        'pickDropSelected':pickupDropSelected,
        'currentCarLocation':pickupDropSelected ? currentCarLocationController.text.trim(): widget.userDetails.address,
        'serviceStatus':'Still Not in Process'
      });
      await docRef.update({'appointmentId': docRef.id});
    } on FirebaseException catch(e){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.code}')));
    }
    // {
    //   // use this code for user showing the appointment
    //   QuerySnapshot snapshot = await FirebaseFirestore.instance
    //       .collection('appointments')
    //       .where('userEmail', isEqualTo: user.email)
    //       .get();
    //
    //   List<Appointment> appointments = snapshot.docs.map((doc) => Appointment.fromFirestore(doc)).toList();
    //
    // }

    final appointment = Appointment(
      serviceTypes: selectedServices,
      date: selectedDate!,
      userDetails: widget.userDetails,
      problemDetails: problemDetailsController.text.trim(),
      pickupDropSelected: pickupDropSelected,
      currentCarLocation: pickupDropSelected ? currentCarLocationController.text.trim() : '',
    );


    widget.addAppointment(appointment);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Appointment booked successfully')));
    setState(() {
      selectedServices = [];
      selectedDate = null;
      problemDetailsController.clear();
      pickupDropSelected = false;
      currentCarLocationController.clear();
    });
  }

  @override
  void dispose() {
    problemDetailsController.dispose();
    currentCarLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Services', style: TextStyle(fontSize: 16)),
                  ...services.map((service) {
                    return CheckboxListTile(
                      title: Text(service),
                      value: selectedServices.contains(service),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedServices.add(service);
                          } else {
                            selectedServices.remove(service);
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: problemDetailsController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Describe your problem',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Car Pickup and Drop Service'),
              value: pickupDropSelected,
              onChanged: (bool? value) {
                setState(() {
                  pickupDropSelected = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            if (pickupDropSelected) ...[
              SizedBox(height: 8),
              TextField(
                controller: currentCarLocationController,
                decoration: InputDecoration(
                  labelText: 'Current Car Location (if different from submitted address)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'No Date Chosen!'
                        : 'Date: ${selectedDate!.toLocal().toString().split(" ")[0]}',
                  ),
                ),
                TextButton(
                  onPressed: _selectDate,
                  child: Text('Choose Date'),
                ),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: submit,
              child: Text('Book Appointment'),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48)),
            ),
          ],
        ),
      ),
    );
  }
}