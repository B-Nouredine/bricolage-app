import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bricolage_app/enums.dart';
import 'package:bricolage_app/screens/Home/components/Bottom_Nav_Bar.dart';
import 'chat_screen.dart';
import 'components/widgets.dart';

class AllMessages extends StatefulWidget {
  static String id = "messages_screen";
  @override
  _AllMessagesState createState() => _AllMessagesState();
}

class _AllMessagesState extends State<AllMessages> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  List users = [];
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
// ignore: await_only_futures
      final User? user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      _auth.signOut();
      showToast(txt: 'Something went wrong...\n     please login again!');
    }
  }

  Widget usersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        var messages = snapshot.data?.docChanges;
        if (messages == null) {
          return Text('No Data Found', style: simpleTextStyle());
        }
        for (var message in messages) {
          if (message.doc['sender'] == loggedInUser!.email.toString()) {
            var user = message.doc['receiver'];
            if (!users.contains(user)) {
              users.add(user);
            }
          } else if (message.doc['receiver'] ==
              loggedInUser!.email.toString()) {
            var user = message.doc['sender'];
            if (!users.contains(user)) {
              users.add(user);
            }
          }
        }
        return ListView(
          padding: const EdgeInsets.only(top: 12),
          children: [
            for (var user in users)
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Chat(),
                            settings: RouteSettings(arguments: user)));
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: const BoxDecoration(color: Colors.black26),
                        child: Row(children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                                user.substring(0, 1).toString().toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Times New Roman',
                                    fontWeight: FontWeight.w300)),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(user,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.w300)),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        color: Colors.black12,
                      )
                    ],
                  )),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        centerTitle: true,
        title: const Text("Chat", style: TextStyle(fontSize: 18)),
      ),
      body: Container(
        child: usersList(),
      ),
      bottomNavigationBar: const BottomNavBar(selectedMenu: MenuState.message),
    );
  }
}
