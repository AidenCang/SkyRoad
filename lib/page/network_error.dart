import 'package:flutter/material.dart';
import 'package:skyroad/common/utils/common_utls.dart';
import 'package:skyroad/page/welcome_page.dart';
import 'package:skyroad/widget/gosund_button.dart';
/**
 *
 * Project Name: skyroad
 * Package Name: page
 * File Name: network_error
 * USER: Aige
 * Create Time: 2019-07-30-17:16
 *
 */

class NetworkError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: Icon(Icons.error),
                      )),
                  Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: Text(
                            CommonUtils.getLocale(context).connetion_error),
                      )),
                  Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: Text(
                            CommonUtils.getLocale(context).connetion_title),
                      )),
                ],
              )),
          Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: GosundButton(
              child: Text(CommonUtils.getLocale(context).try_agin),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomePage()));
              },
            ),
          )
        ],
      )),
    );
  }
}
