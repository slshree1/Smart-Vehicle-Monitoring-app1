import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rebuilded_project/models/user_details.dart';
import 'package:rebuilded_project/utils/constants.dart';


class SignUpPage extends StatefulWidget {
  // final Function(UserDetails) signup;
  final Function() signup;

  SignUpPage({required this.signup});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();
  final carNumberController = TextEditingController();
  final yearOfManufactureController = TextEditingController();

  String? uid;
  String? selectedCarCompany;
  String? selectedCarName;
  String? selectedCarModel;
  String? selectedCarColor;

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
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    contactController.dispose();
    addressController.dispose();
    carNumberController.dispose();
    yearOfManufactureController.dispose();
    super.dispose();
  }

  void submit() async{

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty ||
        contactController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        selectedCarCompany == null ||
        selectedCarName == null ||
        selectedCarModel == null ||
        carNumberController.text.trim().isEmpty ||
        yearOfManufactureController.text.trim().isEmpty ||
        selectedCarColor == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return;
    }


    try{
      UserCredential userCredential=
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim()
          );
      String? userEmail=userCredential.user!.email;


      await FirebaseFirestore.instance
          .collection('users')  // Collection name
          .doc(userEmail)  // Use UID as document ID
          .set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'contactNumber': contactController.text.trim(),
        'address': addressController.text.trim(),
        'carCompany': selectedCarCompany,
        'carName': selectedCarName,
        'carModel': selectedCarModel,
        'carNumber': carNumberController.text.trim(),
        'yearOfManufacture': yearOfManufactureController.text.trim(),
        'color': selectedCarColor,
      });

      widget.signup();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup successful! Please sign in.")),
      );


    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        // print('Password is too weak');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Passwords is too week')));
        return;
      } else if (e.code == 'email-already-in-use') {
        // print('Email already exists');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Email already exists')));
        return;
      } else {
        // print('Error: ${e.message}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
        return;
      }
    } on FirebaseException catch (e) {
        // Handle Firestore-specific errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Database error: ${e.message ?? 'Unknown error'}')),
        );

    } catch (e) {
      // Handle generic errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: ${e.toString()}')),
      );
    }


    // widget.signup(UserDetails(
    //   name: name,
    //   email: email,
    //   password: password,
    //   contactNumber: contact,
    //   address: address,
    //   carCompany: company,
    //   carName: carName,
    //   carModel: carModel,
    //   carNumber: carNumber,
    //   yearOfManufacture: year,
    //   color: color,
    // ));





  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Container(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth < 400 ? constraints.maxWidth : 400;
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      SizedBox(height: maxWidth * 0.02),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      SizedBox(height: maxWidth * 0.02),
                      TextField(
                        controller: contactController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(labelText: 'Contact Number'),
                      ),
                      SizedBox(height: maxWidth * 0.02),
                      TextField(
                        controller: addressController,
                        decoration: InputDecoration(labelText: 'Address'),
                      ),
                      SizedBox(height: maxWidth * 0.02),
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
                      SizedBox(height: maxWidth * 0.02),
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
                      SizedBox(height: maxWidth * 0.02),
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
                      SizedBox(height: maxWidth * 0.02),
                      TextField(
                        controller: carNumberController,
                        decoration: InputDecoration(labelText: 'Car Number'),
                      ),
                      SizedBox(height: maxWidth * 0.02),
                      TextField(
                        controller: yearOfManufactureController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Year of Manufacture'),
                      ),
                      SizedBox(height: maxWidth * 0.02),
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
                      SizedBox(height: maxWidth * 0.02),
                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                                obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: maxWidth * 0.02),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obscureConfirmPassword = !obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: maxWidth * 0.05),
                      ElevatedButton(
                        onPressed: submit,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: maxWidth * 0.035),
                          child: Text('Sign Up', style: TextStyle(fontSize: maxWidth * 0.045)),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, maxWidth * 0.12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}