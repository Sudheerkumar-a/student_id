import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:student_id/core/errors/exceptions.dart';

/// Single shared HTTP layer. Only generic verbs — no feature-specific API methods.
/// Add new endpoints in feature repositories via [get], [post], [put], [postWithMultipart].
class RemoteDataStore {
  final Dio _dio;

  RemoteDataStore(this._dio);

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic data) parser,
  }) {
    return _request(
      () => _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: _options(headers),
      ),
      parser,
    );
  }

  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic data) parser,
  }) {
    return _request(
      () => _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _options(headers),
      ),
      parser,
    );
  }

  Future<T> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(dynamic data) parser,
  }) {
    return _request(
      () => _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _options(headers),
      ),
      parser,
    );
  }

  Future<T> postWithMultipart<T>(
    String path, {
    required Map<String, String> fields,
    String? filePath,
    String fileField = 'file',
    Map<String, dynamic>? headers,
    required T Function(dynamic data) parser,
  }) {
    return _request(
      () async => _dio.post<dynamic>(
        path,
        data: await _buildMultipartForm(
          fields: fields,
          filePath: filePath,
          fileField: fileField,
        ),
        options: _options(headers),
      ),
      parser,
    );
  }

  static Map<String, String> bearerAuth(String token) => {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };

  Options? _options(Map<String, dynamic>? headers) {
    if (headers == null || headers.isEmpty) return null;
    return Options(headers: headers);
  }

  Future<FormData> _buildMultipartForm({
    required Map<String, String> fields,
    String? filePath,
    String fileField = 'file',
  }) async {
    final formData = FormData.fromMap(fields);
    if (!kIsWeb && filePath != null && filePath.isNotEmpty) {
      final file = File(filePath);
      formData.files.add(
        MapEntry(
          fileField,
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    return formData;
  }

  Future<T> _request<T>(
    Future<Response<dynamic>> Function() send,
    T Function(dynamic data) parser,
  ) {
    return _guard(() async {
      final response = await send();
      return _mapResponse(response, parser);
    });
  }

  T _mapResponse<T>(
    Response<dynamic> response,
    T Function(dynamic data) parser,
  ) {
    final message = _responseMessage(response);
    switch (response.statusCode) {
      case 200:
        return parser(response.data);
      case 400:
        throw ServerException(message: message);
      case 401:
        throw const ServerException(message: 'Unauthorized');
      case 500:
        throw const ServerException(message: 'Internal Server Error');
      default:
        throw const ServerException(message: 'Unknown Error');
    }
  }

  String _responseMessage(Response<dynamic> response) {
    final data = response.data;
    if (data == null) return '';
    if (data is String) return data;
    return data.toString();
  }

  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      if (e.error is ServerException) throw e.error as ServerException;
      throw ServerException(message: e.message ?? e.toString());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
