import 'package:dr_app/features/doctor/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class RejectedScreen extends StatelessWidget {
  const RejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'rejected',
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => DoctorSignupScreen()));
              },
              child: Text('back to signup page'))
        ],
      )),
    );
  }
}
