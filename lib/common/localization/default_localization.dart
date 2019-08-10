import 'dart:ui';

import 'package:flutter/material.dart';

import 'gosundstring_en.dart';
import 'gosundstring_zh.dart';
import 'local_string_base.dart';

/**
 *
 * Project Name: skyRoad
 * Package Name: common.localization
 * File Name: default_localization
 * USER: Aige
 * Create Time: 2019-07-31-16:40
 *
 */

class GosundLocalizations {
  final Locale locale;

  GosundLocalizations(this.locale);

  static Map<String, GosundStringBase> _localizedValues = {
    'zh': GosundStringZH(),
    'en': GosundStringEN()
  };

  GosundStringBase get currentLocalized {
    return _localizedValues[locale.languageCode];
  }

  static GosundLocalizations of(BuildContext context) {
    return Localizations.of(context, GosundLocalizations);
  }
}



