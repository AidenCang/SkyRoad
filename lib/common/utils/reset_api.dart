/**
 *
 * Project Name: SkyRoad
 * Package Name: common.utils
 * File Name: api_utils
 * USER: Aige
 * Create Time: 2019-08-01-15:22
 *
 */

import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'reset_api.g.dart';

@RestApi(baseUrl: "http://192.168.10.137:8000/")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @POST('users/')
  @Headers({"Accept": "application/json"})
  Future<String> createUser(@Body() Map<String, dynamic> map);

  @GET("sms_code_1/{mobile}/")
  @Headers({"Accept": "application/json"})
  Future<String> getSms(@Query("mobile") String mobile);
}
