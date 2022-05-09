import 'package:bricolage_app/components/default_button.dart';
import 'package:bricolage_app/constants.dart';
import 'package:bricolage_app/screens/Home/Home.dart';
import 'package:bricolage_app/screens/sign_in/sign_in_screen.dart';
import 'package:bricolage_app/screens/sign_up/sign_up_screen.dart';
import 'package:bricolage_app/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../size_config.dart';
import 'local_auth_api.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintPage extends StatefulWidget {
  @override
  State<FingerprintPage> createState() => _FingerprintPageState();
}

class _FingerprintPageState extends State<FingerprintPage> {
  late String? email;
  late String? password;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyAvailability(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(

        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(20, 40, 100, 0.6),
          title: const Text("Sign In",
              style: TextStyle(fontSize: 17)),
          centerTitle: true,
          elevation: 2,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Please use your fingerprint to login...",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                buildAuthenticate(context),
                const SizedBox(
                  height: 20,
                ),
                buildButton(
                  text: "Normal Authentication",
                  icon: Icons.auto_fix_normal,
                  onClicked: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInScreen())),
                )
              ],
            ),
          ),
        ),
      );

  void verifyAvailability(BuildContext context) async {
    final isAvailable = await LocalAuthApi.hasBiometrics();
    final biometrics = await LocalAuthApi.getBiometrics();
    final hasFingerprint = biometrics.contains(BiometricType.fingerprint);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Availability'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildText('Biometrics', isAvailable),
            buildText('Fingerprint', hasFingerprint),
          ],
        ),
      ),
    );
  }

  Widget buildText(String text, bool checked) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            checked
                ? Icon(Icons.check, color: Colors.green, size: 24)
                : Icon(Icons.close, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontSize: 24)),
          ],
        ),
      );

  Widget buildAuthenticate(BuildContext context) => buildButton(
        text: 'Biometric Authentication',
        icon: Icons.fingerprint,
        onClicked: () async {
          final isAuthenticated = await LocalAuthApi.authenticate();

          if (isAuthenticated) {
            setState(() {
              signIn();
            });

          }
        },
      );

  Widget buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.deepPurple,
          minimumSize: const Size.fromHeight(50),
          elevation: 8,
        ),
        icon: Icon(icon, size: 30),
        label: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
        onPressed: onClicked,
      );

  void signIn() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      email = prefs.getString('email');
      password = prefs.getString('password');
      await auth.signInWithEmailAndPassword(email: email!, password: password!);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } catch (e) {
      showToast(txt: 'An error occurred!');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => SignInScreen()),
              (Route<dynamic> route) => false
      );
    }
  }
}
