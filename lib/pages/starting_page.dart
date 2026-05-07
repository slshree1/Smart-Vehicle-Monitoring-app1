import 'package:flutter/material.dart';

class StartingPage extends StatelessWidget {
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  StartingPage({required this.onSignIn, required this.onSignUp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth < 400 ? constraints.maxWidth : 400;
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.car_repair,
                            size: maxWidth * 0.2,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(width: maxWidth * 0.03),
                          Flexible(
                            child: Text(
                              'AutoCare Center',
                              style: TextStyle(
                                fontSize: maxWidth * 0.08,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: maxWidth * 0.05),

                      SizedBox(height: maxWidth * 0.025),
                      Text(
                        'Welcome to AutoCare, your trusted car servicing partner!',
                        style: TextStyle(fontSize: maxWidth * 0.045, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: maxWidth * 0.1),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onSignIn,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: maxWidth * 0.035),
                                child: Text('Sign In', style: TextStyle(fontSize: maxWidth * 0.045)),
                              ),
                            ),
                          ),
                          SizedBox(width: maxWidth * 0.05),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onSignUp,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: maxWidth * 0.035),
                                child: Text('Sign Up', style: TextStyle(fontSize: maxWidth * 0.045)),
                              ),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            ),
                          ),
                        ],
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