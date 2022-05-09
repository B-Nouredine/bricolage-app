import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bricolage_app/components/custom_surfix_icon.dart';
import 'package:bricolage_app/components/form_error.dart';
import 'package:bricolage_app/models/Usr.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class UserInfoForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  late String firstName;
  late String lastName;
  late String phoneNumber;
  late String address;
  bool showSpinner=false;
  Usr user=Usr(firstName:"", lastName: "", address: "", phoneNumber: "");
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }
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
    return user.firstName==""?const SizedBox(width: 0)
    :Stack(
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
              SizedBox(height: getProportionateScreenHeight(45)),
              ElevatedButton(
                style: ButtonStyle(backgroundColor:  MaterialStateProperty.all(Colors.green)),
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text("save",style: TextStyle(fontSize: 18)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      showSpinner=true;
                    });
                    EditProfile();
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

  Widget buildAddressFormField() {
    return Container(
      alignment: Alignment.center,
      child: TextFormField(
        initialValue: user.address,
        onSaved: (newValue) => address = newValue!,
        validator: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 40),
          border: OutlineInputBorder( borderRadius: BorderRadius.all(Radius.circular(40))),
          labelText: "Address",
          hintText: "Enter your phone address",
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
        initialValue: user.phoneNumber,
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
          border: OutlineInputBorder( borderRadius: BorderRadius.all(Radius.circular(40))),
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
        initialValue: user.lastName,
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
          border: OutlineInputBorder( borderRadius: BorderRadius.all(Radius.circular(40))),
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
        initialValue: user.firstName,
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
          border: OutlineInputBorder( borderRadius: BorderRadius.all(Radius.circular(40))),
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
  void EditProfile() async {
    try{
    await firestore.collection("users").doc(auth.currentUser?.uid).update({
    'firstName': firstName,
    'lastName': lastName,
      'email': auth.currentUser?.email,
    'phoneNumber': phoneNumber,
    'address': address,
      'userId': auth.currentUser?.uid
    });
    setState(() {
      showSpinner=false;
      Navigator.pop(context);
    });
    }
    catch(e){
      setState(() {
        addError(error: "Connection Error");
        showSpinner=false;
      });
    }
  }

  void getUserInfo() async {
    DocumentSnapshot querySnapshot =
    await firestore.collection("users").doc(auth.currentUser?.uid).get();
    setState(() {
      user = Usr.getUsr(querySnapshot);
    });
  }
}
