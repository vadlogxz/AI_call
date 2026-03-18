import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('→ ${options.method} ${options.uri}');
    if (options.data is FormData) {
      final fields = (options.data as FormData).fields;
      final files = (options.data as FormData).files
          .map((f) => '${f.key}: ${f.value.filename} (${f.value.length}b)')
          .toList();
      if (fields.isNotEmpty) debugPrint('  fields: $fields');
      if (files.isNotEmpty) debugPrint('  files: $files');
    } else if (options.data != null) {
      debugPrint('  body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('← ${response.statusCode} ${response.requestOptions.uri}');
    debugPrint('  body: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('✗ ${err.requestOptions.method} ${err.requestOptions.uri}');
    debugPrint('  [${err.type.name}] ${err.message}');
    if (err.response != null) {
      debugPrint('  status: ${err.response?.statusCode}');
      debugPrint('  body: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}
