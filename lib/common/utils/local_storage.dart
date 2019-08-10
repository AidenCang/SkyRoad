import 'package:shared_preferences/shared_preferences.dart';
/**
 *
 * Project Name: SkyRoad
 * Package Name: common.utils
 * File Name: local_storage
 * USER: Aige
 * Create Time: 2019-07-30-10:56
 *
 */

class LocalStorage {
  static save(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
