import 'package:flutter/material.dart';

import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up",style: TextStyle(fontSize: 17)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Body(),
    );
  }
}
