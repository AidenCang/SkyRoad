import 'package:flutter/material.dart';
import 'package:skyroad/widget/gosund_button.dart';

import 'login_page.dart';

/**
 *
 * Project Name: skyroad
 * Package Name: page
 * File Name: verify_account
 * USER: Aige
 * Create Time: 2019-08-02-21:46
 *
 */

class VerifyAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Account'),
        leading: Icon(Icons.arrow_back),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(bottom: 50, top: 50),
                child: FlutterLogo(
                  size: 100,
                ),
              )),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    '   We  have sent an email to your Please enter your email and follow',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      '   Please enter your email and follow the instructions to complete registration',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 50,
                  ),
                  GosundButton(
                    child: Text('Start'),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginPage()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
