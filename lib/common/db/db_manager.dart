import 'dart:io';

import 'package:path/path.dart';
/**
 *
 * Project Name: SkyRoad
 * Package Name: common.db
 * File Name: db_manager
 * USER: Aige
 * Create Time: 2019-08-08-09:17
 * 数据库升级处理
 *https://github.com/tekartik/sqflite/blob/master/sqflite/doc/migration_example.md
 * 数据库优化、异常处理
 * https://github.com/tekartik/sqflite/blob/master/sqflite/doc/opening_db.md#prevent-database-locked-issue
 */

import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DBManager {
  static const String db_name = "gosund.db";
  bool delete_db = false;
  static Database _database;

//  数据库加锁，避免出现异常android.database.sqlite.SQLiteDatabaseLockedException: database is locked (code 5)
  static final _lock = new Lock();

  ///初始化数据库
  static init({delete_db = false, version = 1, readOnly = false}) async {
    var db_path = await getDatabasesPath();
    String path = join(db_path, db_name);
    try {
      ///确保数据库路径存在
      await Directory(db_path).create(recursive: true);
    } catch (_) {
      print("数据库路径不存在！！！！");
    }
    if (delete_db) {
      deleteDatabase(path);
    }

    _database = await openDatabase(path,
        version: version,
        onCreate: (Database db, int version) {
//      创建时调用
        },
        onConfigure: onConfigure,
        onDowngrade: (Database db, int oldVersion, int newVersion) {
//      降级时调用
        },
        onOpen: (Database db) {
//      打开时调用
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) {
//      升级时调用
        },
        readOnly: readOnly);
  }

  /// Check if a file is a valid database file
  /// An empty file is a valid empty sqlite file
  Future<bool> isDatabase(String path) async {
    Database db;
    bool isDatabase = false;
    try {
      db = await openReadOnlyDatabase(path);
      int version = await db.getVersion();
      if (version != null) {
        isDatabase = true;
      }
    } catch (_) {} finally {
      await db?.close();
    }
    return isDatabase;
  }

  /// Let's use FOREIGN KEY constraints
  static Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  ///初始化当前的数据库
  static getCurrentDb() async {
    if (_database == null) {
      await _lock.synchronized(() async {
        ///加锁，避免Lock异常发生
        // Check again once entering the synchronized block
        if (_database == null) {
          _database = init();
        }
      });
    }
    return _database;
  }

  ///  表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDb();
    var res = await _database.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  ///关闭数据库
  static close() {
    _database?.close();
    _database = null;
  }
}
