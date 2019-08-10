import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skyroad/common/localization/default_localization.dart';

/**
 *
 * Project Name: skyRoad
 * Package Name: common.localization
 * File Name: location_delegate
 * USER: Aige
 * Create Time: 2019-07-31-18:55
 *
 */

class GosundLocationDelegate
    extends LocalizationsDelegate<GosundLocalizations> {
  @override
  bool isSupported(Locale locale) {
    ///支持中、英文
    return ['zh', 'en'].contains(locale.languageCode);
  }


  @override
  Future<GosundLocalizations> load(Locale locale) {
    //根据locale，创建一个对象用于提供当前locale下的文本显示
    return SynchronousFuture<GosundLocalizations>(GosundLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<GosundLocalizations> old) {
    return false;
  }

  ///全局静态的代理
  static GosundLocationDelegate delegate = new GosundLocationDelegate();
}


