import 'package:flutter/material.dart';
import 'package:bricolage_app/size_config.dart';

import 'components/body.dart';

class OtpScreen extends StatelessWidget {
   final String phoneNumber;
   const OtpScreen({
     Key? key,required this.phoneNumber,
   }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Code Verification",style: TextStyle(fontSize: 15)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Body(phoneNumber: phoneNumber),
    );
  }
}
