import 'dart:convert';
/**
 *
 * Project Name: SkyRoad
 * Package Name: common.utils
 * File Name: code_utils
 * USER: Aige
 * Create Time: 2019-07-30-13:53
 *
 */

class CodeUtils {
  static List<dynamic> decodeListResult(String data) {
    return json.decode(data);
  }

  static Map<String, dynamic> decodeMapResult(String data) {
    return json.decode(data);
  }

  static String decodeToString(String data) {
    return json.encode(data);
  }
}
