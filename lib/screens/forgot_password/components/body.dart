import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bricolage_app/components/custom_surfix_icon.dart';
import 'package:bricolage_app/components/default_button.dart';
import 'package:bricolage_app/components/form_error.dart';
import 'package:bricolage_app/components/no_account_text.dart';
import 'package:bricolage_app/screens/sign_in/sign_in_screen.dart';
import 'package:bricolage_app/size_config.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(30),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Please enter your email and we will send \nyou a link to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;
  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) => email = newValue,
                onChanged: (value) {
                  if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                    setState(() {
                      errors.remove(kEmailNullError);
                    });
                  } else if (emailValidatorRegExp.hasMatch(value) &&
                      errors.contains(kInvalidEmailError)) {
                    setState(() {
                      errors.remove(kInvalidEmailError);
                    });
                  }
                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                    setState(() {
                      errors.add(kEmailNullError);
                    });
                  } else if (!emailValidatorRegExp.hasMatch(value) &&
                      !errors.contains(kInvalidEmailError)) {
                    setState(() {
                      errors.add(kInvalidEmailError);
                    });
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 40),
                  border: OutlineInputBorder( borderRadius: const BorderRadius.all(Radius.circular(40))),
                  labelText: "Email",
                  hintText: "Enter your email",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              FormError(errors: errors),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              DefaultButton(
                text: "Continue",
                press: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      showSpinner=true;
                    });
                    _forgotPass(email?.trim());

                  }
                },
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              const NoAccountText(),
              SizedBox(height: getProportionateScreenHeight(30)),
            ],
          ),
        ),
        showSpinner? Container(
          width: double.infinity,
          height: 100,
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
  void _forgotPass(email) async {
    try{
      await auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('check your email to reset you password')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
    }catch(e) {
      setState(() {
        showSpinner=false;
        errors.isNotEmpty?errors.removeLast()
       :errors.add("Error sending email : \n Check your connection or try another email");
      });
    }
  }
}
