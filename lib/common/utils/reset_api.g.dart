// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio) {
    ArgumentError.checkNotNull(_dio, '_dio');
    _dio.options.baseUrl = 'http://192.168.10.137:8000/';
  }

  final Dio _dio;

  @override
  createUser(map) async {
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map ?? {});
    final _result = await _dio.request('users/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: {'Accept': 'application/json'},
            extra: _extra),
        data: _data);
    var value = _result.data;
    return Future.value(value);
  }

  @override
  getSms(mobile) async {
    ArgumentError.checkNotNull(mobile, 'mobile');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'mobile': mobile};
    const _data = null;
    final _result = await _dio.request('sms_code_1/{mobile}/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: {'Accept': 'application/json'},
            extra: _extra),
        data: _data);
    var value = _result.data;
    return Future.value(value);
  }
}
