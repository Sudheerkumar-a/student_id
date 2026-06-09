import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:student_id/core/constants/api_constants.dart';
import 'package:student_id/core/network/debug_logging_interceptor.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      },
      validateStatus: (status) => status != null && status < 600,
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(DebugLoggingInterceptor());
  }

  return dio;
}
