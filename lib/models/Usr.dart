


import 'package:cloud_firestore/cloud_firestore.dart';

class Usr{
  String firstName,lastName,phoneNumber,address;

  Usr({required this.firstName, required this.lastName, required this.phoneNumber, required this.address});

  static Usr getUsr(DocumentSnapshot userinfo){
    return Usr(
        firstName: userinfo.get("firstName"),
        lastName: userinfo.get("lastName"),
        phoneNumber: userinfo.get("phoneNumber"),
        address: userinfo.get("address"),
    );
  }
}