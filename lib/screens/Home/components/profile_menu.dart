import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu(
      {Key? key,
      required this.text,
      required this.icon,
      this.press,
      this.verticalPadding = 10,
      this.color = kPrimaryColor})
      : super(key: key);

  final String text, icon;
  final VoidCallback? press;
  final double verticalPadding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
              horizontal: 20, vertical: verticalPadding * 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: darkMode ? Colors.white38 : Colors.black38,
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: color,
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
