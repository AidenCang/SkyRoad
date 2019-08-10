import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:skyroad/page/main_page.dart';
import 'package:skyroad/page/register_login.dart';

import 'common/event/http_error_event.dart';
import 'common/localization/location_delegate.dart';
import 'common/net/code.dart';
import 'common/redux/gosund_state.dart';
import 'common/utils/common_utls.dart';
import 'common/utils/flutter_toast.dart';
import 'navigator/home_page.dart';
import 'page/login_page.dart';

void main() => runApp(SkyRoadApp());

class SkyRoadApp extends StatelessWidget {
  final store = Store<GosundState>(appReducer,
      middleware: middleware,
      initialState: GosundState(locale: Locale('zh', '')));

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: StoreBuilder<GosundState>(builder: (context, state) {
          return MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GosundLocationDelegate.delegate,
//              解决中文输入框长按复制黏贴异常 https://www.kikt.top/posts/flutter/framework/cupertino-paste-tooltip/
//              ChineseCupertinoLocalizations.delegate,
//              ios语言支持
//              GlobalCupertinoLocalizations.delegate,
            ],
            locale: store.state.locale,
            supportedLocales: [
              const Locale('en', ""), // English
              const Locale('zh', ""), // Chinese
              // ... other locales the app supports
            ],
            initialRoute: RegisterLogin.sName,
            routes: {
              MainPage.sName: (context) {
//                return HomePage();

                ///通过 Localizations.override 包裹一层，
                return GosundLocalizations(
                  child: HomePage(),
                );
              },
              LoginPage.sName: (context) {
                return GosundLocalizations(
                  child: LoginPage(),
                );
//                return LoginPage();
              },
              RegisterLogin.sName: (context) {
//                return WelcomePage();
                return GosundLocalizations(
                  child: RegisterLogin(),
                );
              }
            },
          );
        }));
  }
}

class GosundLocalizations extends StatefulWidget {
  final Widget child;

  GosundLocalizations({Key key, this.child}) : super(key: key);

  @override
  State<GosundLocalizations> createState() {
    return new _GSYLocalizations();
  }
}

class _GSYLocalizations extends State<GosundLocalizations> {
  StreamSubscription stream;

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<GosundState>(builder: (context, store) {
      ///通过 StoreBuilder 和 Localizations 实现实时多语言切换
      ///读取当前系统的语言修改相关的app语言
      store.state.locale =
          Locale(ui.window.locale.languageCode, ui.window.locale.countryCode);
      return new Localizations.override(
        context: context,
//        locale: Locale(ui.window.locale.languageCode, ui.window.locale.countryCode),
        locale: store.state.locale,
        child: widget.child,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    stream = Code.eventBus.on<HttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream.cancel();
      stream = null;
    }
  }

  errorHandleFunction(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error);
        break;
      case 401:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_401);
        break;
      case 403:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_403);
        break;
      case 404:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_404);
        break;
      case Code.NETWORK_TIMEOUT:
        //超时
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_timeout);
        break;
      default:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_unknown +
                " " +
                message);
        break;
    }
  }
}
