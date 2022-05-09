import 'package:flutter/material.dart';

import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       elevation: 0,
        title: const Text("Forgot Password",style: TextStyle(fontSize: 17)),
        centerTitle: true,
      ),
      body: Body(),
    );
  }
}
