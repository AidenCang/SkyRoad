import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final ThemeData iOSTheme = new ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[400],
  primaryColorBrightness: Brightness.dark,
);
final ThemeData androidTheme = new ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.green,
);

const String defaultUserName = "MeandNi";

//void main() => runApp(new MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext ctx) {
//    return new MaterialApp(
//      title: "Chat Application",
//      theme:
//          defaultTargetPlatform == TargetPlatform.iOS ? iOSTheme : androidTheme,
//      home: new Chat(),
//    );
//  }
//}
enum MessageType { send, accept }

class ChatPage extends StatefulWidget {
  @override
  State createState() => new ChatWindow();
}

class ChatWindow extends State<ChatPage> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];
  WebSocketChannel channel;
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;

  @override
  void initState() {
    initWebsocket();
    super.initState();
  }

  initWebsocket() {
    if (channel == null) {
      channel =
          IOWebSocketChannel.connect('ws://127.0.0.1:8000/channels/rooms/');
    }
    channel.stream.listen((data) {
      print(json.decode(data)["message"]);
      accetpMsg(json.decode(data)["message"]["message"],
          json.decode(data)["message"]["type"]);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return new Scaffold(
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
              reverse: true,
              padding: new EdgeInsets.all(6.0),
            )),
        new Divider(height: 1.0),
        new Container(
          child: _buildComposer(),
          decoration: new BoxDecoration(color: Theme.of(ctx).cardColor),
        ),
//        StreamBuilder(
//          stream: channel?.stream,
//          builder: (context, snapshot) {
//            return new Padding(
//              padding: const EdgeInsets.symmetric(vertical: 24.0),
//              child:
//              new Text(snapshot.hasData ? '${snapshot.data}' : ''),
//            );
//          },
//        )
      ]),
    );
  }

  Widget _buildComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onChanged: (String txt) {
                    setState(() {
                      _isWriting = txt.length > 0;
                    });
                  },
                  onSubmitted: _submitMsg,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Enter some text to send a message"),
                ),
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                      child: new Text("Submit"),
                      onPressed: _isWriting
                          ? () => _submitMsg(_textController.text)
                          : null)
                      : new IconButton(
                    icon: new Icon(Icons.message),
                    onPressed: _isWriting
                        ? () => _submitMsg(_textController.text)
                        : null,
                  )),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
              border: new Border(top: new BorderSide(color: Colors.brown)))
              : null),
    );
  }

  void _submitMsg(String txt) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    Msg msg = new Msg(
      txt: txt,
      animationController: new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 800)),
    );
    setState(() {
      _messages.insert(0, msg);
    });
    if (txt.isNotEmpty) {
      channel.sink.add(json.encode({
        "message": {"message": txt, "type": "send"}
      }));
    }
    msg.animationController.forward();
  }

  void accetpMsg(String txt, String type) {
    if (type == "send") {
      return;
    }
    Msg msg = new Msg(
      txt: txt,
      animationController: new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 800)),
      messageType: MessageType.accept,
    );
    setState(() {
      _messages.insert(0, msg);
    });
    msg.animationController.forward();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class Msg extends StatelessWidget {
  Msg(
      {this.txt,
        this.animationController,
        this.messageType = MessageType.send});

  final MessageType messageType;

  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext ctx) {
    return SizeTransition(
      sizeFactor:
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: messageType == MessageType.send
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 18.0),
              child: CircleAvatar(child: new Text(defaultUserName[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(defaultUserName,
                      style: Theme.of(ctx).textTheme.subhead),
                  Container(
                    margin: const EdgeInsets.only(top: 6.0),
                    child: Text(txt),
                  ),
                ],
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(defaultUserName,
                    style: Theme.of(ctx).textTheme.subhead),
                Container(
                  margin: const EdgeInsets.only(top: 6.0),
                  child: Text(txt),
                ),
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              margin: const EdgeInsets.only(right: 18.0),
              child: CircleAvatar(child: new Text(defaultUserName[0])),
            )
          ],
        ),
      ),
    );
  }
}
