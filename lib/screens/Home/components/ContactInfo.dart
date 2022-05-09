import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bricolage_app/constants.dart';
import 'package:bricolage_app/models/Post.dart';
import 'package:bricolage_app/models/Usr.dart';

import '../../Chat_Screen/chat_screen.dart';
class ContactInfo extends StatefulWidget {
  final Post post;
  final Size size;
  const ContactInfo({Key? key, required this.post, required this.size}) : super(key: key);

  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
    Usr user=Usr(firstName: 'anonymous',
    lastName: "",
    address: "",
    phoneNumber: "",
    );
    String? email;
    String? networkImage;
    @override
  void initState() {
      getOwner();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding*2),
      child: Container(
        padding:const EdgeInsets.all(8),
        margin: EdgeInsets.only(top: widget.size.height * 0.26),
        decoration: const BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: networkImage!=null?Image.network(networkImage!).image
                                :const AssetImage("assets/images/avatar.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                "${user.firstName} ${user.lastName}",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.message_outlined) , onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Chat(),
                      settings: RouteSettings(arguments: email)));
            },
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              icon: const Icon(Icons.call) , onPressed: () {
              launch("tel://${user.phoneNumber}");
            },
            )
          ],
        ),
      ),
    );
  }

  void getOwner() async {
        DocumentSnapshot querySnapshot =
        await firestore.collection("users").doc(widget.post.userId).get();
        setState(() {
          user = Usr.getUsr(querySnapshot);
          email=querySnapshot.get("email");
        });
        getImage(widget.post.userId);
  }
    void getImage(String id) async{
      String image= await fireStorage.ref().child("ProfilePics").child(id).getDownloadURL();
      setState(() {
        networkImage=image;
      });
    }
}
