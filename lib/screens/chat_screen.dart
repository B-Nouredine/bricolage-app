import 'package:bricolage_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:bricolage_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final interlocutor = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: const <Widget>[
          // IconButton(
          //     icon: Icon(Icons.close),
          //     onPressed: () {
          //       //Implement logout functionality
          //     }),
        ],
        title: Column(
          children: [
            const Text('⚡️Messaging'),
            const SizedBox(
              height: 2,
            ),
            Text(
              interlocutor,
              textAlign: TextAlign.end,
              style: const TextStyle(
                backgroundColor: Color.fromRGBO(160, 160, 180, 1),
                fontSize: 10,
                color: Color.fromRGBO(20, 20, 140, 1),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
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
                    final messageDate = message.doc['createdAt'].toString();
                    if ((messageReceiver == interlocutor &&
                            messageSender == loggedInUser!.email) ||
                        (messageReceiver == loggedInUser!.email &&
                            messageSender == interlocutor)) {
                      var messageBuble = MessageBuble(
                        message: messageText,
                        sender: messageSender,
                        alignment: messageReceiver == interlocutor
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        color: messageReceiver == interlocutor
                            ? Colors.green
                            : Colors.blueGrey,
                        myMessage:
                            messageReceiver == interlocutor ? true : false,
                        messageDate: messageDate,
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
                        children: messageBubles,
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
                        'receiver': interlocutor,
                        'createdAt': Timestamp.now(),
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

class MessageBuble extends StatefulWidget {
  MessageBuble(
      {required this.message,
      required this.sender,
      required this.alignment,
      required this.color,
      required this.myMessage,
      required this.messageDate});

  final String message;
  final String sender;
  final CrossAxisAlignment alignment;
  final Color color;
  final bool myMessage;

  final String messageDate;

  @override
  State<MessageBuble> createState() => _MessageBubleState();
}

class _MessageBubleState extends State<MessageBuble> {
  late bool showMessageDate = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        // crossAxisAlignment: alignment,
        children: [
          Text(widget.myMessage == false ? widget.sender : "Me"),
          GestureDetector(
            onTap: () {
              showMessageDate = !showMessageDate;
            },
            child: Material(
                elevation: 10,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: widget.color,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: Text(widget.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      )),
                )),
          ),
          Text(showMessageDate ? widget.messageDate : ""),
        ],
      ),
    );
  }
}
