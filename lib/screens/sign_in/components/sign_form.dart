import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bricolage_app/components/custom_surfix_icon.dart';
import 'package:bricolage_app/components/form_error.dart';
import 'package:bricolage_app/helper/keyboard.dart';
import 'package:bricolage_app/screens/Home/Home.dart';
import 'package:bricolage_app/screens/forgot_password/forgot_password_screen.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  bool showSpinner=false;
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
              SizedBox(height: getProportionateScreenHeight(25)),
              Row(
                children: [
                  Checkbox(
                    value: remember,
                    activeColor: kColor,
                    onChanged: (value) {
                      setState(() {
                        remember = value;
                      });
                    },
                  ),
                  const Text("Remember me"),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen())),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                          "Forgot Password?",
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                    ),
                  )
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(100)),
              DefaultButton(
                text: "Continue",
                press: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    KeyboardUtil.hideKeyboard(context);
                    setState(() {
                      showSpinner=true;
                    });
                    _signIn(email?.trim(), password);
                  }
                },
              ),
            ],
          ),
        ),
        showSpinner? Container(
          width: double.infinity,
          height: 150,
          color: Colors.transparent,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          ),
        ) : const SizedBox(height: 0),
      ],
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return;
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
        border: OutlineInputBorder( borderRadius: BorderRadius.all(Radius.circular(40))),
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
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
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  void _signIn(email,password) async {
    final User? user = (await
    auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )).user;
    if (user != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Home()),
              (Route<dynamic> route) => false
      );
    } else {
      setState(() {
        addError(error: kSignInError);
        showSpinner=false;
      });
    }
  }
}
