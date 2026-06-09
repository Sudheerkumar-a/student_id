import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DebugLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌────── HTTP Request ──────');
      debugPrint('│ ${options.method} ${options.uri}');
      debugPrint('│ Headers: ${options.headers}');
      if (options.queryParameters.isNotEmpty) {
        debugPrint('│ Query: ${options.queryParameters}');
      }
      if (options.data != null) {
        debugPrint('│ Body: ${options.data}');
      }
      debugPrint('└──────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌────── HTTP Response ──────');
      debugPrint('│ ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('│ Data: ${response.data}');
      debugPrint('└───────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌────── HTTP Error ──────');
      debugPrint('│ ${err.requestOptions.method} ${err.requestOptions.uri}');
      debugPrint('│ Type: ${err.type}');
      debugPrint('│ Message: ${err.message}');
      final response = err.response;
      if (response != null) {
        debugPrint('│ Status: ${response.statusCode}');
        debugPrint('│ Data: ${response.data}');
      }
      debugPrint('└────────────────────────');
    }
    handler.next(err);
  }
}
