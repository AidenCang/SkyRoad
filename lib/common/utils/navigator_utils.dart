import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 *
 * Project Name: SkyRoad
 * Package Name: common.utils
 * File Name: navigator_utils
 * USER: Aige
 * Create Time: 2019-07-30-15:49
 *
 */

class NavigatorUtils {
  ///替换
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  ///切换无参数页面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}
