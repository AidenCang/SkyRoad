import 'package:flutter/material.dart';
import 'package:skyroad/common/utils/common_utls.dart';
import 'package:skyroad/page/login_page.dart';
import 'package:skyroad/page/register_page.dart';
import 'package:skyroad/widget/gosund_button.dart';
/**
 *
 *
 * Project Name: skyroad
 * Package Name: page
 * File Name: register_login
 * USER: Aige
 * Create Time: 2019-07-30-19:11
 *
 */

class RegisterLogin extends StatefulWidget {
  static String sName = 'registerlogin';

  @override
  RegisterLoginState createState() => RegisterLoginState();
}

enum CurrentState { none, register, login }

class RegisterLoginState extends State<RegisterLogin> {
  @override
  Widget build(BuildContext context) {
    return Material(child: buildView());
  }

  Widget buildView() {
    return _buildRegisterLogin();
  }

  Widget _buildRegisterLogin() {
    return SafeArea(
        child: Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Center(
              child: Text(CommonUtils.getLocale(context).welcome_title,
                  style: TextStyle(color: Colors.red, fontSize: 30))),
        ),
        Column(
          children: <Widget>[
            GosundButton(
              child: Text(CommonUtils.getLocale(context).create_account),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 150, top: 20),
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: GosundButton(
                  background: Colors.white12,
                  child: Text(CommonUtils.getLocale(context).login),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ),
            )
          ],
        )
      ],
    ));
  }
}
