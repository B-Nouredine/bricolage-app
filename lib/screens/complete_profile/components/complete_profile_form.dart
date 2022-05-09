import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bricolage_app/components/custom_surfix_icon.dart';
import 'package:bricolage_app/components/default_button.dart';
import 'package:bricolage_app/components/form_error.dart';
import 'package:bricolage_app/screens/otp/otp_screen.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  late String firstName;
  late String lastName;
  late String phoneNumber;
  late String address;
  bool showSpinner = false;
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
              buildFirstNameFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildLastNameFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildPhoneNumberFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildAddressFormField(),
              SizedBox(height: getProportionateScreenHeight(5)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(35)),
              DefaultButton(
                text: "continue",
                press: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      showSpinner = true;
                    });
                    completeProfile();
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

  Widget buildAddressFormField() {
    return Container(
      alignment: Alignment.center,
      child: TextFormField(
        onSaved: (newValue) => address = newValue!,
        validator: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 40),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          labelText: "Address",
          hintText: "Enter your address",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon:
              CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
        ),
      ),
    );
  }

  Widget buildPhoneNumberFormField() {
    return Container(
      alignment: Alignment.center,
      child: TextFormField(
        keyboardType: TextInputType.phone,
        onSaved: (newValue) => phoneNumber = newValue!,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kPhoneNumberNullError);
          }
          return null;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kPhoneNumberNullError);
            return "";
          }
          return null;
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 40),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          labelText: "Phone Number",
          hintText: "Enter your phone number",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
        ),
      ),
    );
  }

  Widget buildLastNameFormField() {
    return Container(
      alignment: Alignment.center,
      child: TextFormField(
        onSaved: (newValue) => lastName = newValue!,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kNamelNullError);
          }
          return;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kNamelNullError);
            return "";
          }
          return null;
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 40),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          labelText: "Last Name",
          hintText: "Enter your last name",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
        ),
      ),
    );
  }

  Widget buildFirstNameFormField() {
    return Container(
      alignment: Alignment.center,
      child: TextFormField(
        onSaved: (newValue) => firstName = newValue!,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kNamelNullError);
          }
          return;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kNamelNullError);
            return "";
          }
          return null;
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 40),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          labelText: "First Name",
          hintText: "Enter your first name",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
        ),
      ),
    );
  }

  void completeProfile() async {
    try {
      String devID =
          await FirebaseInstallations.instanceFor(app: Firebase.app()).getId();
      await firestore.collection("users").doc(auth.currentUser?.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': auth.currentUser?.email,
        'phoneNumber': phoneNumber,
        'address': address,
        'userId': auth.currentUser?.uid,
        'deviceID': devID,
        'fingerPrintEnabled': false,
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                OtpScreen(phoneNumber: phoneNumber)),
      );
      //(Route<dynamic> route) => false
    } catch (e) {
      setState(() {
        addError(error: kProfileError);
        showSpinner = false;
      });
    }
  }
}
