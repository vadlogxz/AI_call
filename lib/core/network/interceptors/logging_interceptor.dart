import 'package:dio/dio.dart';
import 'package:elia/core/logging/app_logger.dart';

class LoggingInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final query = options.queryParameters.isNotEmpty ? ' | QUERY: ${options.queryParameters}' : '';
    final data = options.data != null ? ' | DATA: ${options.data}' : '';
    AppLogger.info(
      '→ ${options.method} ${options.path}$query$data',
      tag: LogTag.network,
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.info(
      '← ${response.requestOptions.method} ${response.requestOptions.path} ${response.statusCode}',
      tag: LogTag.network,
      data: response.data,
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    AppLogger.error(
      '✕ ${err.requestOptions.method} ${err.requestOptions.path}${status != null ? ' $status' : ''}',
      tag: LogTag.network,
      error: err.error ?? err.message,
      stackTrace: err.stackTrace,
      data: err.response?.data,
    );
    super.onError(err, handler);
  }
}
