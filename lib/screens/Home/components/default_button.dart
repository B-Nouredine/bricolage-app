import 'package:flutter/material.dart';

import '../../../constants.dart';


class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness==Brightness.dark;
    return Container(
      color: darkMode? kdarkColor : kSecondaryColor,
      width: double.infinity,
      height: 62,
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0,right: 25.0,bottom: 7,top: 2),
        child: TextButton(
          style: TextButton.styleFrom(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: kContentColorLightTheme,
          ),
          onPressed: press as Function(),
          child: Text(
            text!,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}