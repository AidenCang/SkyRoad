import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:skyroad/common/redux/gosund_state.dart';
import 'package:skyroad/common/redux/locale_redux.dart';
import 'package:skyroad/common/utils/common_utls.dart';
import 'package:skyroad/common/utils/net_utils.dart';
import 'package:skyroad/page/register_login.dart';

import 'main_page.dart';
import 'network_error.dart';

class WelcomePage extends StatefulWidget {
  static final String sName = '/';

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    NetUtils.connectiveType().then((type) {
      switch (type) {
//      wifi和mobile状态需要进入主界面
        case NetConnectivityType.mobile:
        case NetConnectivityType.wifi:
          new Future.delayed(Duration(seconds: 2), () {
            checkUserLoginState().then((flag) {
              if (flag) {
                //登陆状态
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              } else {
                //为登陆状态
//                Navigator.pushReplacement(context,
//                    MaterialPageRoute(builder: (context) => TextFormFieldDemo()));

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => RegisterLogin()));
              }
            });
          });
          break;
        case NetConnectivityType.none:
          new Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => NetworkError()));
          });
          break;
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Store<GosundState> store = StoreProvider.of(context);
    store.dispatch(RefreshLocaleAction(Localizations.localeOf(context)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              CommonUtils.getLocale(context).app_name,
              style: Theme.of(context).textTheme.display1,
            ),
            Column(
              children: <Widget>[
                new SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 15.0,
                    backgroundColor: Colors.green,
//               value: 0.2,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    CommonUtils.getLocale(context).connetion_network,
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
            Text(
              CommonUtils.getLocale(context).version_code + 'V1.0.0',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
    );
  }

//  判断用户是否是登陆状态
  Future<bool> checkUserLoginState() async {
    return await false;
  }
}
