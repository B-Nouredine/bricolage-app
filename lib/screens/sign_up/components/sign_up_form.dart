import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bricolage_app/components/custom_surfix_icon.dart';
import 'package:bricolage_app/components/default_button.dart';
import 'package:bricolage_app/components/form_error.dart';
import 'package:bricolage_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? confirm_password;
  bool remember = false;
  bool showSpinner = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              buildEmailFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildPasswordFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildconfirmPassFormField(),
              SizedBox(height: getProportionateScreenHeight(20)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(85)),
              DefaultButton(
                text: "Continue",
                press: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      showSpinner = true;
                    });
                    _signUp(email?.trim(), password);
                  }
                },
              ),
            ],
          ),
        ),
        showSpinner
            ? Container(
                width: double.infinity,
                height: 150,
                color: Colors.transparent,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
              )
            : const SizedBox(height: 0),
      ],
    );
  }

  Widget buildconfirmPassFormField() {
    return Container(
      alignment: Alignment.center,
      child: TextFormField(
        obscureText: true,
        onSaved: (newValue) => confirm_password = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kPassNullError);
          }
          if (value.isNotEmpty && password == confirm_password) {
            removeError(error: kMatchPassError);
          }
          confirm_password = value;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kPassNullError);
            return "";
          } else if ((password != value)) {
            addError(error: kMatchPassError);
            return "";
          }
          return null;
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 40),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          labelText: "Confirm Password",
          hintText: "Re-enter your password",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
        ),
      ),
    );
  }

  Widget buildPasswordFormField() {
    return Container(
      alignment: Alignment.center,
      child: TextFormField(
        obscureText: true,
        onSaved: (newValue) => password = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kPassNullError);
          }
          if (value.length >= 8) {
            removeError(error: kShortPassError);
          }
          password = value;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kPassNullError);
            return "";
          } else if (value.length < 8) {
            addError(error: kShortPassError);
            return "";
          }
          return null;
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 40),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          labelText: "Password",
          hintText: "Enter your password",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
        ),
      ),
    );
  }

  Widget buildEmailFormField() {
    return Container(
      alignment: Alignment.center,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        onSaved: (newValue) => email = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kEmailNullError);
          }
          if (emailValidatorRegExp.hasMatch(value)) {
            removeError(error: kInvalidEmailError);
          }
          return;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kEmailNullError);
            return "";
          } else if (!emailValidatorRegExp.hasMatch(value)) {
            addError(error: kInvalidEmailError);
            return "";
          }
          return null;
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 40),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          labelText: "Email",
          hintText: "Enter your email",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
        ),
      ),
    );
  }

  void _signUp(email, password) async {
    try {
      final User? user = (await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) {
        saveEmailAndPassword();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CompleteProfileScreen()),
            (Route<dynamic> route) => false);
      } else {
        setState(() {
          addError(error: kSignUpError);
          showSpinner = false;
        });
      }
    } catch (e) {
      setState(() {
        addError(error: "Connection Error");
        showSpinner = false;
      });
    }
  }

  void saveEmailAndPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email != null ? email! : '');
    prefs.setString('password', password != null ? password! : '');
  }
}
