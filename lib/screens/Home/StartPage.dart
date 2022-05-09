import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bricolage_app/screens/sign_in/sign_in_screen.dart';
import 'package:bricolage_app/Account/LocalAuth/local_auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../main.dart';
import '../../size_config.dart';
import 'Home.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool loaded = false;
  List users = [];
  late final SharedPreferences prefs;
  @override
  void initState() {
    startDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Center(
        child: SizedBox(
      height: 100,
      width: 100,
      child: Image.asset("assets/images/logo.png"),
    ));
  }

  void startDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('ThemeMode') != null) {
      MyApp.themeNotifier.value =
          prefs.getString('ThemeMode') == 'ThemeMode.dark'
              ? ThemeMode.dark
              : prefs.getString('ThemeMode') == 'ThemeMode.light'
                  ? ThemeMode.light
                  : ThemeMode.system;
    }
    if (auth.currentUser == null) {
      try {
        bool useFingerPrint = false;
        var deviceID =
            await FirebaseInstallations.instanceFor(app: Firebase.app())
                .getId();
        await firestore.collection('users').get().then((querySnapshot) {
          for (var element in querySnapshot.docs) {
            users.add(element.data());
          }
        });

        for (int i = 0; i < users.length; i++) {
          if (users[i]['deviceID'] == deviceID) {
            if (users[i]['fingerPrintEnabled'] == true) {
              useFingerPrint = true;
              Future.delayed(Duration.zero).then((value) =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => FingerprintPage())));
            }
          }
        }
        if (!useFingerPrint) {
          Future.delayed(Duration.zero).then((value) => Navigator.of(context)
              .pushReplacement(
                  MaterialPageRoute(builder: (context) => SignInScreen())));
        }
      } catch (e) {
        Future.delayed(Duration.zero).then((value) => Navigator.of(context)
            .pushReplacement(
                MaterialPageRoute(builder: (context) => SignInScreen())));
      }
    } else {
      Future.delayed(Duration.zero).then((value) => Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home())));
    }
  }
}
