import 'package:dio/dio.dart';
import 'package:elia/core/network/config/api_config.dart';
import 'package:elia/core/network/interceptors/logging_interceptor.dart';

class ApiClient {
  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: ApiConfig.connectTimeout,
          receiveTimeout: ApiConfig.receiveTimeout,
          headers: {'Accept': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(LoggingInterceptor());
  }

  final Dio _dio;

  Future<Response<dynamic>> postJson(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> postMultipart(
    String path, {
    required FormData data,
  }) {
    return _dio.post(
      path,
      data: data,
      options: Options(contentType: 'multipart/form-data'),
    );
  }
}
