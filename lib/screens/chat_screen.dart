import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
final _firestore = FirebaseFirestore.instance;
User? LoggedinUser;
class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authp = FirebaseAuth.instance;

  String? MessageText;
  final MessageTextCont=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _authp.currentUser;

      if (user != null) {
        LoggedinUser = user;

      }
    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _authp.signOut();
                Navigator.pop(context);

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

            MessagesStream(),


            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: MessageTextCont,
                      onChanged: (value) {
                        MessageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      MessageTextCont.clear();
                      _firestore.collection('messages').add(
                          {
                            'text': MessageText,
                            'sender': LoggedinUser!.email,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
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

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return   StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages')
        .orderBy('timestamp', descending: true).snapshots(),
        
        builder: (context, snapshot) {

          List<MessageBubble> messageBubblers = [];

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
          final messages = snapshot.data!.docs;

          for (var message in messages) {
            final Map messageData =
            message.data() as Map<String, dynamic>;
            final messageText = messageData['text'];
            final messageSender = messageData['sender'];

            final CurrentUser=LoggedinUser!.email;

            if(CurrentUser==messageSender){

            }

            final messagebubble = MessageBubble(
              sender: messageSender,
              message: messageText,
              isme: CurrentUser==messageSender,

            );
            messageBubblers.add(messagebubble);
          }

          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubblers,
            ),
          );
        });
  }
}






class MessageBubble extends StatelessWidget {
  final String? sender;
  final String? message;
  final bool? isme;
  MessageBubble({this.sender, this.message,this.isme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isme!? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Text(sender!,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white54
          ),
          ),
          Material(
            borderRadius:isme!? BorderRadius.only(
              topLeft:Radius.circular(30.0),
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0)
            ):BorderRadius.only(
              topLeft:Radius.circular(30.0),
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)
            ),
            elevation: 5.0,
            color:isme! ? Colors.lightBlueAccent:Colors.black12,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text(
                '$message ',
                style: TextStyle(

                  color: Colors.white,
                  fontSize: 15.0,
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
