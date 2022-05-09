import 'package:flutter/material.dart';
import 'package:bricolage_app/screens/otp/otp_screen.dart';
import 'package:bricolage_app/screens/sign_in/sign_in_screen.dart';
import 'package:bricolage_app/screens/sign_up/sign_up_screen.dart';

import '../constants.dart';
import '../size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() =>Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don’t have an account? ",
              style: TextStyle(fontSize: getProportionateScreenWidth(16)),
            ),
            Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: getProportionateScreenWidth(16), color: kColor),
            ),
          ],
        ),
      ),
    );
  }
}
