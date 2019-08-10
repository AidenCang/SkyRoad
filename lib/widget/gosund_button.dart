import 'dart:ui';

import 'package:flutter/material.dart';
/**
 *
 * Project Name: SkyRoad
 * Package Name: widget
 * File Name: GosundButton
 * USER: Aige
 * Create Time: 2019-07-31-08:53
 *
 */

class GosundButton extends StatelessWidget {
  final width = window.physicalSize.width;
  final height = window.physicalSize.height;
  final double radius; //圆角
  final Function onTap; //触摸
  final Widget child; //child
  final double elevation; //水波纹
  final Color background; //背景
  final Color splashColor; //点击水波纹效果
  final Function onLongTap; //长按
  EdgeInsetsGeometry padding; //内部填充
  EdgeInsetsGeometry margin; //内部填充
  final double widthbutton;
  final double heightbutton;

  GosundButton(
      {Key key,
      this.radius = 10.0,
      this.onTap,
      this.child,
      this.elevation = 0.0,
      this.background = Colors.blueAccent,
      this.splashColor,
      this.onLongTap,
      this.padding,
      this.widthbutton,
      this.heightbutton = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget w = InkWell(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          borderRadius: BorderRadius.circular(radius),
          color: background,
          elevation: elevation,
          child: Container(
            width: widthbutton ?? MediaQuery.of(context).size.width / 2,
            height: heightbutton,
            margin: margin ??
                EdgeInsets.only(
                    left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
      onTap: onTap,
      onLongPress: onLongTap,
    );
    if (this.splashColor != null) {
      return Theme(
          data: Theme.of(context).copyWith(splashColor: this.splashColor),
          child: w);
    }
    return w;
  }
}
