/**
 *
 * Project Name: SkyRoad
 * Package Name: common.dao
 * File Name: dao_result
 * USER: Aige
 * Create Time: 2019-08-02-15:45
 *
 */

import 'dart:async';

class DataResult {
  var data;
  bool result;
  Future next;

  DataResult(this.data, this.result, {this.next});
}
