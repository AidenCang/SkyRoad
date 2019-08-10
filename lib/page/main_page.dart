import 'package:flutter/material.dart';
import 'package:skyroad/widget/gosund_tabview.dart';

class MainPage extends StatefulWidget {
//  路由名称
  static final String sName = 'mainpage';

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return GosundTabView();
  }
}
