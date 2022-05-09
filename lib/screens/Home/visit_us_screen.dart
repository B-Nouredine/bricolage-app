import 'package:bricolage_app/Account/Settings/settings_screen.dart';
import 'package:bricolage_app/Account/User_Info/user_info_screen.dart';
import 'package:bricolage_app/screens/sign_in/sign_in_screen.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../enums.dart';
import 'components/Bottom_Nav_Bar.dart';
import 'components/profile_menu.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMedia extends StatelessWidget {
  const SocialMedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visit Us", style: TextStyle(fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            const Image(
              image: AssetImage("assets/images/logo.png"),
              width: 150,
              height: 150,
              alignment: Alignment.center,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Twitter",
              icon: "assets/icons/twitter.svg",
              press: () => _launchURL("https://twitter.com/NBoutlih"),
              verticalPadding: 9,
              color: const Color.fromRGBO(0, 0, 255, 1),
            ),
            /* ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),*/
            ProfileMenu(
              text: "Facebook",
              icon: "assets/icons/facebook-2.svg",
              press: () =>
                  _launchURL("https://facebook.com/Nouredine.Boutlih.71"),
              verticalPadding: 4,
              color: const Color.fromRGBO(20, 40, 255, 0.8),
            ),
            ProfileMenu(
              text: "Instagram",
              icon: "assets/icons/instagram.svg",
              press: () => _launchURL("https://instagram.com/nouredineboutlih"),
              color: Colors.pinkAccent,
              verticalPadding: 9,
            ),
            ProfileMenu(
              text: "GitHub",
              icon: "assets/icons/github.svg",
              press: () => _launchURL("https://github.com/b-nouredine"),
              verticalPadding: 9,
              color: const Color.fromRGBO(0, 0, 0, 1),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '\u00A9 \nBouamlat, Boutlih',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(10, 108, 10, 1),
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
