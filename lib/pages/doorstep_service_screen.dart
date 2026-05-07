import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoorStepServiceScreen extends StatefulWidget {
  @override
  _DoorStepServiceScreenState createState() => _DoorStepServiceScreenState();
}

class _DoorStepServiceScreenState extends State<DoorStepServiceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> services = [
    {'name': 'Oil Change', 'icon': Icons.oil_barrel},
    {'name': 'Minor Repair', 'icon': Icons.build},
    {'name': 'Adjustments', 'icon': Icons.settings},
    {'name': 'Car Wash and Wax', 'icon': Icons.local_car_wash},
    {'name': 'Filter Replacement', 'icon': Icons.filter_alt},
    {'name': 'Brake Inspection', 'icon': Icons.car_repair},
    {'name': 'Battery Health Checkup', 'icon': Icons.battery_charging_full},
    {'name': 'Battery Replacement', 'icon': Icons.battery_alert},
    {'name': 'Car Spa', 'icon': Icons.spa},
    {'name': 'Tire Replacement', 'icon': Icons.tire_repair},
    {'name': 'Tire Rotation', 'icon': Icons.sync_alt},
    {'name': 'Wheel Alignment', 'icon': Icons.straighten},
    {'name': 'AC Service', 'icon': Icons.ac_unit},
    {'name': 'Headlight Restoration', 'icon': Icons.light_mode},
  ];

  Set<String> selectedServices = {};
  List<Map<String, dynamic>> bookedServices = [];
  Map<int, bool> paymentStatus = {};

  DateTime? selectedDate;
  final TextEditingController additionalInfoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    additionalInfoController.dispose();
    super.dispose();
  }

  void toggleServiceSelection(String serviceName) {
    setState(() {
      if (selectedServices.contains(serviceName)) {
        selectedServices.remove(serviceName);
      } else {
        selectedServices.add(serviceName);
      }
    });
  }

  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now().add(Duration(days: 1));
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? initialDate,
      firstDate: initialDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void bookSelectedServices() {
    if (selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one service to book')),
      );
      return;
    }
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date for the service')),
      );
      return;
    }
    setState(() {
      bookedServices.add({
        'services': selectedServices.toList(),
        'date': selectedDate,
        'additionalInfo': additionalInfoController.text.trim(),
      });
      selectedServices.clear();
      selectedDate = null;
      additionalInfoController.clear();
      _tabController.index = 1; // Switch to Booked Services tab
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Services booked successfully')),
    );
  }

  void cancelBooking(int index) {
    setState(() {
      bookedServices.removeAt(index);
      paymentStatus.remove(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking cancelled')),
    );
  }

  void postponeBooking(int index) async {
    DateTime initialDate = bookedServices[index]['date'] ?? DateTime.now().add(Duration(days: 1));
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        bookedServices[index]['date'] = picked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking postponed to ${DateFormat('yyyy-MM-dd').format(picked)}')),
      );
    }
  }

  void makePayment(int index) {
    setState(() {
      paymentStatus[index] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment processed (dummy)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Door Step Service'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Book Service'),
            Tab(text: 'Booked Services'),
          ],
          isScrollable: true,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Book Service Tab
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Services',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: services.map((service) {
                      return CheckboxListTile(
                        title: Text(service['name']),
                        secondary: Icon(service['icon']),
                        value: selectedServices.contains(service['name']),
                        onChanged: (bool? value) {
                          toggleServiceSelection(service['name']);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Select Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? 'No date chosen'
                            : DateFormat('yyyy-MM-dd').format(selectedDate!),
                      ),
                    ),
                    TextButton(
                      onPressed: _selectDate,
                      child: Text('Choose Date'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: additionalInfoController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter any additional details',
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: bookSelectedServices,
                  child: Text('Book Services'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
          // Booked Services Tab
          bookedServices.isEmpty
              ? Center(child: Text('No booked services found'))
              : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: bookedServices.length,
            itemBuilder: (context, index) {
              final booking = bookedServices[index];
              final services = booking['services'] as List<String>;
              final date = booking['date'] as DateTime;
              final additionalInfo = booking['additionalInfo'] as String;
              final isPaid = paymentStatus[index] ?? false;
              final cost = services.length * 50; // $50 per service, matching appointment logic

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          services.join(', '),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'),
                            Text('Cost: \$${cost.toStringAsFixed(2)}'),
                            if (additionalInfo.isNotEmpty) ...[
                              SizedBox(height: 4),
                              Text('Additional Info: $additionalInfo'),
                            ],
                            SizedBox(height: 8),
                            Text(
                              'Payment Status: ${isPaid ? "Paid" : "Pending"}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isPaid ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'Cancel') {
                              cancelBooking(index);
                            } else if (value == 'Postpone') {
                              postponeBooking(index);
                            }
                          },
                          itemBuilder: (ctx) => [
                            PopupMenuItem(value: 'Cancel', child: Text('Cancel')),
                            PopupMenuItem(value: 'Postpone', child: Text('Postpone')),
                          ],
                        ),
                      ),
                      if (!isPaid)
                        ButtonBar(
                          alignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => makePayment(index),
                              child: Text('Pay Now'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}