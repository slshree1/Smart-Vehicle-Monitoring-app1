import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rebuilded_project/models/service_center.dart';

class TowingBookingScreen extends StatefulWidget {
  @override
  _TowingBookingScreenState createState() => _TowingBookingScreenState();
}

class _TowingBookingScreenState extends State<TowingBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ServiceCenter> serviceCenters = [
    ServiceCenter(name: 'City Tow Services', address: '123 Main St', phone: '555-1234'),
    ServiceCenter(name: 'Fast Tow', address: '456 Elm St', phone: '555-5678'),
    ServiceCenter(name: '24/7 Tow Center', address: '789 Oak St', phone: '555-9876'),
  ];

  ServiceCenter? _selectedCenter;
  DateTime? _selectedDate;
  final TextEditingController _detailsController = TextEditingController();
  bool _paymentDone = false;
  String? _appointmentId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _selectDate() async {
    final DateTime initialDate = DateTime.now().add(const Duration(days: 1));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitBooking() async {
    if (_selectedCenter == null || _selectedDate == null) {
      _showSnackBar('Please select a service center and date');
      return;
    }
    if (_detailsController.text.trim().isEmpty) {
      _showSnackBar('Please enter details');
      return;
    }

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('towing_service_appointment')
          .add({
        'appointmentId': '',
        'centerName': _selectedCenter!.name,
        'centerPhone': _selectedCenter!.phone,
        'centerAddress': _selectedCenter!.address,
        'date': Timestamp.fromDate(_selectedDate!),
        'details': _detailsController.text.trim(),
        'paymentStatus': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await docRef.update({'appointmentId':docRef.id});
      setState(() {
        _appointmentId = docRef.id;
        _paymentDone = false;
        _tabController.index = 1;
      });

      _showSnackBar('Towing service booked successfully');
    } on FirebaseException catch (e) {
      _showSnackBar('Error: ${e.code}');
    } catch (e) {
      _showSnackBar('An unexpected error occurred');
    }
  }

  Future<void> _cancelBooking() async {
    if (_appointmentId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('towing_service_appointment')
          .doc(_appointmentId)
          .delete();

      setState(() {
        _selectedCenter = null;
        _selectedDate = null;
        _detailsController.clear();
        _paymentDone = false;
        _appointmentId = null;
        _tabController.index = 0;
      });

      _showSnackBar('Booking cancelled successfully');
    } on FirebaseException catch (e) {
      _showSnackBar('Error cancelling booking: ${e.code}');
    }
  }

  Future<void> _makePayment() async {
    if (_appointmentId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('towing_service_appointment')
          .doc(_appointmentId)
          .update({'paymentStatus': true});

      setState(() => _paymentDone = true);
      _showSnackBar('Payment processed successfully');
    } on FirebaseException catch (e) {
      _showSnackBar('Payment failed: ${e.code}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Towing Service Booking'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Book Towing Service'),
            Tab(text: 'Booked Service'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingForm(),
          _buildBookingDetails(),
        ],
      ),
    );
  }

  Widget _buildBookingForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Service Center',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<ServiceCenter>(
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Choose a service center',
              ),
              value: _selectedCenter,
              items: serviceCenters
                  .map<DropdownMenuItem<ServiceCenter>>((ServiceCenter center) {
                return DropdownMenuItem<ServiceCenter>(
                  value: center,
                  child: Text('${center.name} - ${center.address}'),
                );
              }).toList(),
              onChanged: (ServiceCenter? value) {
                setState(() => _selectedCenter = value);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _selectDate,
              child: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : DateFormat('yyyy-MM-dd').format(_selectedDate!),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _detailsController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter details about your towing request',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitBooking,
              child: const Text('Book Towing Service'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _appointmentId == null
          ? const Center(child: Text('No active booking'))
          : StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('towing_service_appointment')
            .doc(_appointmentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Booking not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final Timestamp? timestamp = data['date'] as Timestamp?;
          final DateTime? date = timestamp?.toDate();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Booking Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildDetailItem('Service Center', data['centerName']?.toString() ?? 'N/A'),
              _buildDetailItem('Address', data['centerAddress']?.toString() ?? 'N/A'),
              _buildDetailItem('Phone', data['centerPhone']?.toString() ?? 'N/A'),
              _buildDetailItem(
                'Date',
                date != null
                    ? DateFormat('yyyy-MM-dd').format(date)
                    : 'No date set',
              ),
              const SizedBox(height: 12),
              const Text(
                'Details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(data['details']?.toString() ?? 'No details provided'),
              const SizedBox(height: 24),
              const Text(
                'Payment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                (data['paymentStatus'] as bool? ?? false)
                    ? 'Payment Completed'
                    : 'Payment Pending',
              ),
              if (!(data['paymentStatus'] as bool? ?? true)) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _makePayment,
                  child: const Text('Pay Now'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _cancelBooking,
                child: const Text('Cancel Booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}