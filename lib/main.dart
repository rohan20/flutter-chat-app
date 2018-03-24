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
  final List<ChatMessage> _messagesList = <ChatMessage>[];
  final TextEditingController _textEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Flutter Chat App"),
        ),
        body: new Column(
          children: <Widget>[
            new Divider(
                height: 1.0
            ),
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
          color: Theme.of(context).accentColor,
        ),
        child: new Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    controller: _textEditingController,
                    onSubmitted: _textMessageSubmitted,
                    decoration: new InputDecoration.collapsed(
                        hintText: "Send a message"),
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: () =>
                        _textMessageSubmitted(_textEditingController.text),
                  ),
                )
              ],
            )));
  }

  void _textMessageSubmitted(String text) {
    _textEditingController.clear();
    ChatMessage chatMessage = new ChatMessage(
      messageText: text,
    );
    setState(() {
      _messagesList.insert(0, chatMessage);
    });
  }
}

class ChatMessage extends StatelessWidget {
  //TODO Replace name with Google username
  String _name = "Rohan";
  final String messageText;

  ChatMessage({this.messageText});

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new CircleAvatar(
            child: new Text(_name[0]), //display first letter of name in avatar
          ),
          new Column(
            children: <Widget>[
              new Text(_name),
              new Text(messageText),
            ],
          ),
        ],
      ),
    );
  }
}
