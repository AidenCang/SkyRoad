import 'package:flutter/material.dart';

class SmartPage extends StatefulWidget {
  @override
  _SmartPageState createState() => _SmartPageState();
}

class _SmartPageState extends State<SmartPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[Text("SmartPage")],
      ),
    );
  }
}
