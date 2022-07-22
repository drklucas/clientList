import 'package:client_list_app/components/auth_form.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade900,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            color: Colors.purple.shade900,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                AuthForm()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
