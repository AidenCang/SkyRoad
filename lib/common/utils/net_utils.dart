import 'package:connectivity/connectivity.dart';
import 'dart:async';

/**
 *
 * Project Name: SkyRoad
 * Package Name: common.utils
 * File Name: net_utils
 * USER: Aige
 * Create Time: 2019-07-30-16:04
 *
 */
enum NetConnectivityType { none, wifi, mobile }

class NetUtils {
  //  判断网络是否连接
  static Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    return connectivityResult != ConnectivityResult.none;
  }

//  判断当前的网络状态
  static Future<NetConnectivityType> connectiveType() async {
    var connectivityResult = await Connectivity().checkConnectivity();
//    return NetConnectivityType.none;
    if (connectivityResult == ConnectivityResult.mobile) {
      return NetConnectivityType.mobile;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return NetConnectivityType.wifi;
    } else if (connectivityResult == ConnectivityResult.none) {
      return NetConnectivityType.none;
    }
  }
}
