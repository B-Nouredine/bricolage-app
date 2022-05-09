import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';
import 'components/widgets.dart';

class Chat extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User? loggedInUser;
  late String _message;
  List<MessageBuble> messageBubles = [];
  var messageBoxController = TextEditingController();

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

  void getMessages() {
    //! to get messages from the db
  }

  @override
  Widget build(BuildContext context) {
    final receiver = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        leading: null,
        title:const Text('⚡️Messaging',style: TextStyle(fontSize: 17),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').orderBy('createdAt').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  final messages = snapshot.data!.docChanges;

                  for (var message in messages) {
                    final messageText = message.doc['message'];
                    final messageSender = message.doc['sender'];
                    final messageReceiver = message.doc['receiver'];
                    if ((messageReceiver == receiver &&
                            messageSender == loggedInUser!.email) ||
                        (messageReceiver == loggedInUser!.email &&
                            messageSender == receiver)) {
                      var messageBuble = MessageBuble(
                        message: messageText,
                        sender: messageSender,
                        color: messageReceiver == receiver
                            ? Colors.green
                            : Colors.blueGrey,
                        myMessage: messageReceiver == receiver ? true : false,
                      );
                      messageBubles.add(messageBuble);
                    }
                  }
                  return Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:messageBubles,
                      ),
                    ),
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageBoxController,
                      onChanged: (value) {
                        _message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'message': _message,
                        'sender': loggedInUser!.email,
                        'receiver': receiver,
                        'createdAt' : Timestamp.now(),
                      });
                      messageBoxController.clear();
                    },
                    icon: const Icon(Icons.send_outlined),
                    color: Colors.blueAccent,
                    iconSize: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBuble extends StatelessWidget {
  const MessageBuble(
      {required this.message,
      required this.sender,
      required this.color,
      required this.myMessage});

  final String message;
  final String sender;
  final Color color;
  final bool myMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: myMessage == false ?Alignment.topLeft:Alignment.topRight,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: myMessage == false ?CrossAxisAlignment.start:CrossAxisAlignment.end,
        children: [
          Padding(
            padding:myMessage == false ?const EdgeInsets.only(left: 8.0):const EdgeInsets.only(right: 10.0),
            child: Text(myMessage == false ?
                 sender.substring(0,sender.indexOf("@"))
                : "Me",style: const TextStyle(fontSize: 12),),
          ),
          Material(
              elevation: 8,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: color,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: Text(message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    )),
              )),
        ],
      ),
    );
  }
}
