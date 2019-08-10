import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static String sName = "home";

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[Text("HomePage")],
      ),
    );
  }
}
