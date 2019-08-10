import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'db_manager.dart';

/**
 *
 * Project Name: skyRoad
 * Package Name: common.db
 * File Name: db_provider
 * USER: Aige
 * Create Time: 2019-08-08-09:25
 *
 */
//import 'package:sqflite/sqflite.dart';
abstract class BaseProvider {
  bool isTableExits = false;

  tableName();

  createSql();

  tableBaseString(String name, String columnId) {
    return '''
        create table $name (
        $columnId integer primary key autoincrement,
      ''';
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExits = await DBManager.isTableExits(name);
    if (!isTableExits) {
      Database _db = DBManager.getCurrentDb();
      return await _db.execute(createSql);
    }
  }

  @mustCallSuper
  open() async {
    if (!isTableExits) {
      await prepare(tableName(), createSql());
    }
    return DBManager.init();
  }
}
