import 'package:flutter/material.dart';

import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In",style: TextStyle(fontSize: 17)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Body(),
    );
  }
}
