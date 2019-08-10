import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:skyroad/common/conf/config.dart';
import 'package:skyroad/common/model/user_model.dart';
import 'package:skyroad/common/net/address.dart';
import 'package:skyroad/common/net/api.dart';
import 'package:skyroad/common/redux/user_redux.dart';
import 'package:skyroad/common/utils/local_storage.dart';
/**
 *
 * Project Name: skyRoad
 * Package Name: common.dao
 * File Name: user_dao
 * USER: Aige
 * Create Time: 2019-08-02-15:31
 *
 */

class UserDao {
  static register(
    type,
    mobile,
    email,
    password,
    code,
  ) async {
    httpManager.clearAuthorization();

    var res = await httpManager.netFetch(
        Address.getRegister(),
        {
          "code": code,
          "type": type,
          "mobile": mobile,
          "email": email,
          "password": password
        },
        null,
        new Options(method: "post"));
    return res;
  }

  ///获取验证码
  static getCode(String mobile, {type = "other"}) async {
    httpManager.clearAuthorization();
    var res = await httpManager.netFetch(Address.getCode(),
        {"mobile": mobile, "code_type": type}, null, Options(method: 'post'));
    return res;
  }

  ///用户登录接口
  static login(username, password, Store store) async {
    Map requestParams = {
      "username": username,
      "password": password,
    };

    String type = username + ":" + password;
    var bytes = utf8.encode(type);
    var base64Str = base64.encode(bytes);
    if (Config.DEBUG) {
      print("base64Str login " + base64Str);
    }
    await LocalStorage.save(Config.KEY_USER_NAME, username);
    await LocalStorage.save(Config.USER_BASIC_CODE, base64Str);

    httpManager.clearAuthorization();
    var res = await httpManager.netFetch(Address.getAuthorization(),
        json.encode(requestParams), null, Options(method: 'post'));
    if (res != null && res.result) {
      await LocalStorage.save(Config.KEY_PW, password);
      var resultData = await getUserInfo();
//      if (resultData != null || resultData.result) {
//        store.dispatch(
//            new UpdateUserAction(UserInfo.fromJson(resultData.data?.data)));
//      }
    }
    return res;
  }

  ///获取用户详细信息
  static getUserInfo() async {
    var res = await httpManager.netFetch(
        Address.getMyUserInfo(), null, null, Options(method: 'get'));
    if (res != null && res.result) {
      print(res?.result);
      UserInfo user = UserInfo.fromJson(res?.data?.data);
      print(user.mobile);
      LocalStorage.save(Config.USER_INFO, json.encode(user.toJson()));
//      数据库中保存用户信息
    }
    return res;
  }

  ///获取用户详细信息
  static restPasswd(username, code, password) async {
    var res = await httpManager.netFetch(
        Address.restPasswd(),
        {"code": code, "username": username, "password": password},
        null,
        Options(method: 'post'));
    if (res != null && res.result) {
      print(res?.result);
      UserInfo user = UserInfo.fromJson(res?.data?.data);
      print(user.mobile);
      LocalStorage.save(Config.USER_INFO, json.encode(user.toJson()));
//      数据库中保存用户信息
    }
    return res;
  }
}
