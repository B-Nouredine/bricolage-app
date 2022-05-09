import 'package:flutter/material.dart';

import 'components/body.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text("Sign Up",style: TextStyle(fontSize: 17)),
      centerTitle: true,
      elevation: 0,
      ),
      body: Body(),
    );
  }
}
