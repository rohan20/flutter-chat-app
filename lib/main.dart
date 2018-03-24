import 'package:flutter/material.dart';

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

class ChatScreenState extends State<ChatScreen> {

  final TextEditingController _textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Chat App"),
      ),
      body: _buildTextComposer(),
    );
  }

  Widget _buildTextComposer(){
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new TextField(
        controller: _textEditingController,
        onSubmitted: _textMessageSubmitted,
        decoration: new InputDecoration.collapsed(hintText: "Send a message"),
      ),
    );
  }

  void _textMessageSubmitted(String text) {
    _textEditingController.clear();
  }
}
