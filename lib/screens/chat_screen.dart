import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messageme_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User signedInUser; //this is for saving the user  email address

class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';

  @override
  _ChatScreenState createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController =
      TextEditingController(); //this is for deleting the text inside text field after sending the message
  final _auth = FirebaseAuth.instance; //this is for using firebase authincation

  String? messageText; //this will give us the message from users

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth
          .currentUser; //here the values of the user is saved inside _auth object in here we write _auth .cureentuser and this current is made by flutter team they created it and we only use it
      if (user != null) {
        signedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore
  //       .collection('messages')
  //       .get(); //we use this to get the messages inside database all of them
  //   for (var message in messages.docs) {
  //     //this is for cutting messages into the number of the messages to all messages be showen in seperate part not together
  //
  //   }
  // }

  // void messagesSreams() async {
  //   //this is another way to get the messages from the firestore we use two fors to first cut the sender and text fields then in text and sender cut all messages
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {}
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset(
              'images/logo.png',
              height: 25,
            ),
            SizedBox(width: 10),
            Text('MessageMe'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // messagesSreams();
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      //this is for deleting the meesage after sending
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          hintText: 'Write your message here... ',
                          border: InputBorder.none),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController
                          .clear(); //deleting text field after sending
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': signedInUser.email,
                        'time': FieldValue.serverTimestamp(),
                      }); //this is for sending the message to the collection of the messages inside firebase firestore
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//this is for getting the values from the firebase and move it to my program
class MessageStreamBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      //this snapshot come in firebase
      // here we connected the database with our program and this will get the message in one second from the firebase
      builder: (context, snapshot) {
        //this snapshot come from flutter async and run after reciving the data from firebase
        List<MessageLine> messageWidgets = []; //this is for all messages (s)

        if (!snapshot.hasData) {
          //this condition work when snapshote dont have a data(dont recived the data from the firebase)
//that is because the ! before the snapshot word
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final messages = snapshot
            .data!.docs.reversed; // (!) this is for checking the null safety
//this is for make messages show from bottom to the top and show newest one in the bottom
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final currentUser = signedInUser.email;

          final messageWidget = MessageLine(
            sender: messageSender,
            text: messageText,
            isMe: currentUser ==
                messageSender, //this is the shortcut of the if statment if those two values equal then the isMe bool variable will be true
          );
          messageWidgets.add(
              messageWidget); //this is inside for every time when the message added to this list will be reshow all the messages inside the list
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

//.
//.
//this is for showing messages design
class MessageLine extends StatelessWidget {
  MessageLine({this.text, this.sender, required this.isMe});

  final String? sender; // (?) this is for null safety
  final String? text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(
              fontSize: 12,
              color: Colors.yellow[900],
            ),
          ),
          Material(
            elevation: 6,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
            color: isMe ? Colors.blue[800] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                //this is for one message
                '$text',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isMe ? Colors.white : Colors.black45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
