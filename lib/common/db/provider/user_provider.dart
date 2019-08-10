import 'package:flutter/foundation.dart';
import 'package:skyroad/common/model/user_model.dart';
import 'package:skyroad/common/utils/code_utils.dart';
import 'package:sqflite/sqflite.dart';

import '../db_provider.dart';

/**
 *
 * Project Name: skyRoad
 * Package Name: common.db.provider
 * File Name: userProvider
 * USER: Aige
 * Create Time: 2019-08-08-10:29
 *
 */

class UserInfoProvider extends BaseProvider {
  UserInfoProvider();

  final table_name = "UserInfo";

  final columnId = "_id";
  final columnUserName = "userName";
  final columnData = "data";

  int id;
  String userName;
  String data;

  @override
  createSql() {
    return tableBaseString(table_name, columnId) +
        '''
        $columnUserName text not null,
        $columnData text not null)
    ''';
  }

  @override
  tableName() {
    return table_name;
  }

  Map<String, dynamic> toMap(String username, String data) {
    Map<String, dynamic> map = {columnUserName: username, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  UserInfoProvider.fromMap(Map map) {
    id = map[columnId];
    userName = map[columnUserName];
    data = map[columnData];
  }

  ///获取数据库中的用户信息
  Future getUserProvider(String usernmae, Database db) async {
    List<Map<String, dynamic>> map = await db.query(table_name,
        columns: [columnId, columnUserName, columnData],
        where: "$columnUserName = ?",
        whereArgs: [usernmae]);
    if (map.length > 0) {
      return UserInfoProvider.fromMap(map.first);
    }
    return null;
  }

  ///插入数据库
  Future insertDb(String usernmae, String data) async {
    Database db = await getDataBase();
    var userInfoProvider = await getUserProvider(usernmae, db);
    if (userInfoProvider != null) {
      await db.delete(table_name,
          where: "$columnUserName = ?", whereArgs: [usernmae]);
    }
    return db.insert(table_name, toMap(usernmae, data));
  }

  ///获取用户信息
  Future<UserInfo> getUserInfo(String username) async {
    Database db = await getDataBase();
    var userprovider = await getUserProvider(username, db);
    if (userprovider != null) {
      ///使用 compute 的 Isolate 优化 json decode
      var mapData =
          await compute(CodeUtils.decodeMapResult, userprovider.data as String);
      return UserInfo.fromJson(mapData);
    }
  }

  ///更新用户数据
  Future<int> updateDb(String username, String data) async {
    return insertDb(username, data);
  }
}
