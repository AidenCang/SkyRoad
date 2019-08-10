import 'package:flutter/material.dart';
import 'package:skyroad/common/localization/default_localization.dart';
import 'package:skyroad/common/localization/local_string_base.dart';
import 'package:skyroad/widget/cube_grid.dart';
/**
 *
 * Project Name: SkyRoad
 * Package Name: common.utils
 * File Name: common_utls
 * USER: Aige
 * Create Time: 2019-07-31-13:57
 *
 */

class CommonUtils {
  //处理多语言
  static GosundStringBase getLocale(BuildContext context) {
    return GosundLocalizations.of(context).currentLocalized;
  }

  static Future<Null> showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Material(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: () => new Future.value(false),
                child: Center(
                  child: new Container(
                    width: 200.0,
                    height: 200.0,
                    padding: new EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      //用一个BoxDecoration装饰器提供背景图片
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            child: SpinKitCubeGrid(color: Colors.greenAccent)),
                        new Container(height: 10.0),
                        new Container(child: new Text('loading')),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  ///电话验证码
  static regMobile(text) {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return exp.hasMatch(text);
  }

  ///邮件验证码
  static regEmail(text) {
    RegExp exp = RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)");
    return exp.hasMatch(text);
  }

  ///邮件验证码
  static regPasswd(String text) {
    if (text != null) {
      if (text.length > 0 && text.length < 128) {
        return true;
      }
    }
    return false;
  }

  /// Utility to encode a blob to allow blow query using
  /// "hex(blob_field) = ?", Sqlite.hex([1,2,3])
  String hex(List<int> bytes) {
    final StringBuffer buffer = StringBuffer();
    for (int part in bytes) {
      if (part & 0xff != part) {
        throw FormatException("$part is not a byte integer");
      }
      buffer.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return buffer.toString().toUpperCase();
  }

  int parseInt(Object object) {
    if (object is int) {
      return object;
    } else if (object is String) {
      try {
        return int.parse(object);
      } catch (_) {}
    }
    return null;
  }
}
