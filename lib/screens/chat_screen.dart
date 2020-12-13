import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ChatScreen extends StatefulWidget {
  static String id = 'CHAT_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  final _fireStore = Firestore.instance;
  String messageText;
  FirebaseUser loggedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedUser = user;
        print(loggedUser.email);
      }
    } catch (e) {
      print(e);
    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _fireStore.collection('message').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightGreenAccent,
                      ),
                    );
                  }
                  final messages = snapshot.data.documents.reversed;
                  List<MessageBubble> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message.data['text'];
                    final sender = message.data['email'];
                    final current_user = loggedUser.email;


                    final messageWidget = MessageBubble(
                    isMe: current_user==sender?true:false,
                      sender: sender,
                      text: messageText,

                    );

                    messageWidgets.add(messageWidget);
                  }
                  return Expanded(
                    child: ListView(

                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      children: messageWidgets,
                      reverse: true,
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
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      //Implement send functionality.
                      _fireStore.collection('message').add(
                          {'email': loggedUser.email, 'text': messageText});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
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

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text,this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          Material(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 15, color: isMe ? Colors.white : Colors.black54),
              ),
            ),
            elevation: 5,
            borderRadius: isMe?BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ):BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
          ),
        ],
      ),
    );
  }
}
