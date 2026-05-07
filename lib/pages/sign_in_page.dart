import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  final Function(String) login;

  SignInPage({required this.login});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void submit() async{
    // String email = emailController.text.trim();
    // String password = passwordController.text.trim();

    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );



      String userEmail = FirebaseAuth.instance.currentUser?.email ??'emailnotfound@gmail.com';

      widget.login(userEmail);




    }on FirebaseAuthException catch(e){
      String ErrorMessage;
      switch(e.code){
        case 'invalid-email':
          ErrorMessage='Invalid email format';
          break;
        case 'user-disabled':
          ErrorMessage='This account has been disabled';
          break;
        case 'user-not-found':
          ErrorMessage='No account found for this email';
          break;
        case 'wrong-password':
          ErrorMessage='Incorrect password';
          break;
        default:
          ErrorMessage='Sign-In failed: ${e.message}';
      }
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(ErrorMessage)));

    }catch(e){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
    // widget.login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: maxWidth * 0.04),
                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: maxWidth * 0.06),
                      ElevatedButton(
                        onPressed: submit,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: maxWidth * 0.035),
                          child: Text('Sign In', style: TextStyle(fontSize: maxWidth * 0.045)),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, maxWidth * 0.12)),
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