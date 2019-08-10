/**
 *
 * Project Name: SkyRoad
 * Package Name: common.redux
 * File Name: locale_redux
 * USER: Aige
 * Create Time: 2019-07-31-18:06
 *
 */

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

final LocaleReducer = combineReducers<Locale>([
  TypedReducer<Locale, RefreshLocaleAction>(_refresh),
]);

Locale _refresh(Locale locale, RefreshLocaleAction action) {
  locale = action.locale;
  return locale;
}

class RefreshLocaleAction {
  final Locale locale;

  RefreshLocaleAction(this.locale);
}
