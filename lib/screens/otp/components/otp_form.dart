import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bricolage_app/components/default_button.dart';
import 'package:bricolage_app/components/form_error.dart';
import 'package:bricolage_app/screens/Home/Home.dart';
import 'package:bricolage_app/size_config.dart';

import '../../../constants.dart';

class OtpForm extends StatefulWidget {
  final String? phoneNumber;
  const OtpForm({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;
  var pin =List.filled(6,"0",growable: false);
  String? VerificationId;
  final List<String?> errors = [];
  bool showSpinner=false;
  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    otpcode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
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
              SizedBox(height: SizeConfig.screenHeight * 0.15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: getProportionateScreenWidth(40),
                    child: TextFormField(
                      autofocus: true,
                      onSaved: (newValue) => pin[0]=newValue!,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        nextField(value, pin2FocusNode);
                      },
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(40),
                    child: TextFormField(
                        onSaved: (newValue) => pin[1]=newValue!,
                        focusNode: pin2FocusNode,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        nextField(value, pin3FocusNode);
                      }
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(40),
                    child: TextFormField(
                      focusNode: pin3FocusNode,
                        onSaved: (newValue) => pin[2]=newValue!,
                        style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged:(value) {
                        nextField(value, pin4FocusNode);
                      }
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(40),
                    child: TextFormField(
                        onSaved: (newValue) => pin[3]=newValue!,
                        focusNode: pin4FocusNode,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged:(value) {
                        nextField(value, pin5FocusNode);
                      }
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(40),
                    child: TextFormField(
                      focusNode: pin5FocusNode,
                        onSaved: (newValue) => pin[4]=newValue!,
                        style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        nextField(value, pin6FocusNode);
                      }
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(40),
                    child: TextFormField(
                      onSaved: (newValue) => pin[5]=newValue!,
                      focusNode: pin6FocusNode,
                      style: const TextStyle(fontSize: 18),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        if (value.length == 1) {
                          pin6FocusNode!.unfocus();
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              FormError(errors: errors),
              SizedBox(height: SizeConfig.screenHeight * 0.15),
              DefaultButton(
                text: "Continue",
                press: () async {
                  if (VerificationId != null) {
                    _formKey.currentState!.save();
                    setState(() {
                    showSpinner=true;
                    });
                    await auth.currentUser
                        ?.linkWithCredential(PhoneAuthProvider.credential(
                            verificationId: VerificationId!, smsCode: pin.join()))
                        .then((value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Home()),
                            (Route<dynamic> route) => false))
                        .catchError((e) {
                      setState(() {
                        errors.isNotEmpty?errors.removeLast()
                        :errors.add("Invalid Code");
                        showSpinner=false;
                      });
                    });
                  } else {
                    setState(() {
                      errors.isNotEmpty?errors.removeLast()
                          :errors.add("Unable to Verify Code");
                      showSpinner=false;
                    });
                  }
                },
              ),
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

  void otpcode() async {
    await auth.verifyPhoneNumber(
        phoneNumber: "+212${widget.phoneNumber?.trim().substring(1)}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) async {

        },
        codeAutoRetrievalTimeout: (String verificationId) async {
          setState(() {
            errors.isEmpty?errors.add("TimeOut")
            :errors.removeLast();
            showSpinner=false;
          });
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          setState(() {
            VerificationId = verificationId;
          });
        },
        verificationFailed: (FirebaseAuthException error) async {
          setState(() {
           errors.isNotEmpty?errors.removeLast()
            :errors.add("verification failed");
            showSpinner=false;
          });
        });
  }
}
