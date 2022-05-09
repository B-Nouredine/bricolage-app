import 'package:flutter/material.dart';
import 'package:bricolage_app/constants.dart';
import 'package:bricolage_app/size_config.dart';

import 'user_info_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.07),
                Text("Account Info", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                UserInfoForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
