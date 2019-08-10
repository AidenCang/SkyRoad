import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:skyroad/common/model/user_model.dart';
import 'package:skyroad/common/redux/user_redux.dart';

import 'locale_redux.dart';
import 'middleware/epic_middleware.dart';

/**
 *
 * Project Name: skyRoad
 * Package Name: common.redux
 * File Name: gosund_state
 * USER: Aige
 * Create Time: 2019-07-29-16:16
 *
 */
class GosundState {
  ///用户信息
  UserInfo userInfo;

  ///语言
  Locale locale;

  ///当前手机平台默认语言
  Locale platformLocale;

  GosundState({this.userInfo, this.locale, this.platformLocale});
}

GosundState appReducer(GosundState state, action) {
  return GosundState(
      userInfo: UserReducer(state.userInfo, action),
      locale: LocaleReducer(state.locale, action));
}

List<Middleware<GosundState>> middleware = [
  EpicMiddleware<GosundState>(UserInfoEpic()),
  UserInfoMiddleware()
];
