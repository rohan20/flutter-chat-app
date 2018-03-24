import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    title: "Flutter Chat App",
    home: new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Chat App"),
      ),
    ),
  ));
}

class FlutterChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Flutter Chat App",
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Chat App"),
      ),
    );
  }
}
