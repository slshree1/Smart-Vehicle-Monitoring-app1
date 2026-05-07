import 'package:flutter/material.dart';
import 'package:rebuilded_project/models/user_details.dart';
import 'package:rebuilded_project/utils/constants.dart';

class AccountScreen extends StatefulWidget {
  final UserDetails userDetails;
  final Function(UserDetails) onSave;

  AccountScreen({required this.userDetails, required this.onSave});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late TextEditingController nameController;
  late TextEditingController contactController;
  late TextEditingController addressController;
  // late TextEditingController passwordController;
  // late TextEditingController confirmPasswordController;
  late TextEditingController carNumberController;
  late TextEditingController yearOfManufactureController;

  late String? selectedCarCompany;
  late String? selectedCarName;
  late String? selectedCarModel;
  late String? selectedCarColor;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  List<String> get carNamesForSelectedCompany {
    if (selectedCarCompany == null) return [];
    return carCompanyToNames[selectedCarCompany!] ?? [];
  }

  List<String> get carModelsForSelectedName {
    if (selectedCarName == null) return [];
    return carNameToModels[selectedCarName!] ?? [];
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userDetails.name);
    contactController = TextEditingController(text: widget.userDetails.contactNumber);
    addressController = TextEditingController(text: widget.userDetails.address);
    // passwordController = TextEditingController(text: widget.userDetails.password);
    // confirmPasswordController = TextEditingController(text: widget.userDetails.password);
    carNumberController = TextEditingController(text: widget.userDetails.carNumber);
    yearOfManufactureController = TextEditingController(text: widget.userDetails.yearOfManufacture);

    selectedCarCompany = widget.userDetails.carCompany;
    selectedCarName = widget.userDetails.carName;
    selectedCarModel = widget.userDetails.carModel;
    selectedCarColor = widget.userDetails.color;
  }

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    addressController.dispose();
    // passwordController.dispose();
    // confirmPasswordController.dispose();
    carNumberController.dispose();
    yearOfManufactureController.dispose();
    super.dispose();
  }

  void save() {
    String name = nameController.text.trim();
    String contact = contactController.text.trim();
    String address = addressController.text.trim();
    // String password = passwordController.text.trim();
    // String confirmPassword = confirmPasswordController.text.trim();
    String carNumber = carNumberController.text.trim();
    String year = yearOfManufactureController.text.trim();

    if (name.isEmpty ||
        contact.isEmpty ||
        address.isEmpty ||
        // password.isEmpty ||
        // confirmPassword.isEmpty ||
        selectedCarCompany == null ||
        selectedCarName == null ||
        selectedCarModel == null ||
        carNumber.isEmpty ||
        year.isEmpty ||
        selectedCarColor == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    // if (password != confirmPassword) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text('Passwords do not match')));
    //   return;
    // }

    UserDetails updatedDetails = UserDetails(
      name: name,
      email: widget.userDetails.email,
      // password: password,
      contactNumber: contact,
      address: address,
      carCompany: selectedCarCompany!,
      carName: selectedCarName!,
      carModel: selectedCarModel!,
      carNumber: carNumber,
      yearOfManufacture: year,
      color: selectedCarColor!,
    );

    widget.onSave(updatedDetails);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Details')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: contactController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Contact Number'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Car Company'),
                value: selectedCarCompany,
                items: carCompanyToNames.keys
                    .map((c) => DropdownMenuItem<String>(
                  value: c,
                  child: Text(c),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedCarCompany = val;
                    selectedCarName = null;
                    selectedCarModel = null;
                  });
                },
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Car Name'),
                value: selectedCarName,
                items: carNamesForSelectedCompany
                    .map((name) => DropdownMenuItem<String>(
                  value: name,
                  child: Text(name),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedCarName = val;
                    selectedCarModel = null;
                  });
                },
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Car Model'),
                value: selectedCarModel,
                items: carModelsForSelectedName
                    .map((model) => DropdownMenuItem<String>(
                  value: model,
                  child: Text(model),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedCarModel = val;
                  });
                },
              ),
              SizedBox(height: 12),
              TextField(
                controller: carNumberController,
                decoration: InputDecoration(labelText: 'Car Number'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: yearOfManufactureController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Year of Manufacture'),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Car Color'),
                value: selectedCarColor,
                items: carColors
                    .map((color) => DropdownMenuItem<String>(
                  value: color,
                  child: Text(color),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedCarColor = val;
                  });
                },
              ),
              SizedBox(height: 12),
              // TextField(
              //   controller: passwordController,
              //   obscureText: obscurePassword,
              //   decoration: InputDecoration(
              //     labelText: 'Password',
              //     suffixIcon: IconButton(
              //       icon: Icon(
              //           obscurePassword ? Icons.visibility_off : Icons.visibility),
              //       onPressed: () {
              //         setState(() {
              //           obscurePassword = !obscurePassword;
              //         });
              //       },
              //     ),
              //   ),
              // ),
              // SizedBox(height: 12),
              // TextField(
              //   controller: confirmPasswordController,
              //   obscureText: obscureConfirmPassword,
              //   decoration: InputDecoration(
              //     labelText: 'Confirm Password',
              //     suffixIcon: IconButton(
              //       icon: Icon(obscureConfirmPassword
              //           ? Icons.visibility_off
              //           : Icons.visibility),
              //       onPressed: () {
              //         setState(() {
              //           obscureConfirmPassword = !obscureConfirmPassword;
              //         });
              //       },
              //     ),
              //   ),
              // ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: save,
                child: Text('Save'),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}