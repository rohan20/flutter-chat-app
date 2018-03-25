import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;

void main() => runApp(new FlutterChatApp());

class FlutterChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Flutter Chat App",
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messagesList = <ChatMessage>[];
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposingMessage = false;
  final reference = FirebaseDatabase.instance.reference().child('messages');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Flutter Chat App"),
        ),
        body: new Column(
          children: <Widget>[
            new Flexible(
                child: new ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messagesList[index],
              itemCount: _messagesList.length,
            )),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            )
          ],
        ));
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    controller: _textEditingController,
                    onChanged: (String messageText) {
                      setState(() {
                        _isComposingMessage = messageText.length > 0;
                      });
                    },
                    onSubmitted: _textMessageSubmitted,
                    decoration: new InputDecoration.collapsed(
                        hintText: "Send a message"),
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: () => _isComposingMessage
                        ? _textMessageSubmitted(_textEditingController.text)
                        : null,
                  ),
                )
              ],
            )));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    await _ensureLoggedIn();
    _sendMessage(messageText: text);
  }

  void _sendMessage({String messageText}) {
    ChatMessage chatMessage = new ChatMessage(
      messageText: messageText,
      animationController: new AnimationController(
          duration: new Duration(milliseconds: 700), vsync: this),
    );

    setState(() {
      _messagesList.insert(0, chatMessage);
    });

    chatMessage.animationController.forward();

    reference.push().set({
      'text': messageText,
      'senderName': googleSignIn.currentUser.displayName,
      'senderPhotoUrl': googleSignIn.currentUser.photoUrl,
    });

    analytics.logEvent(name: 'send_message');
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount signedInUser = googleSignIn.currentUser;
    if (signedInUser == null)
      signedInUser = await googleSignIn.signInSilently();
    if (signedInUser == null) {
      await googleSignIn.signIn();
      analytics.logLogin();
    }

    if(await auth.currentUser() == null){
      GoogleSignInAuthentication credentials = await googleSignIn.currentUser.authentication;
      await auth.signInWithGoogle(idToken: credentials.idToken, accessToken: credentials.accessToken);
    }
  }
}

class ChatMessage extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;

  ChatMessage({this.messageSnapshot, this.animation});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animation, curve: Curves.decelerate),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(
                  //display first letter of name in avatar
                  backgroundImage: new NetworkImage(messageSnapshot.value['senderPhotoUrl']),
                )),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(messageSnapshot.value['senderName'], style: Theme.of(context).textTheme.subhead),
                  new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(messageSnapshot.value['text'])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
