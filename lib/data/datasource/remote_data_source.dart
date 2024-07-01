import 'dart:convert';
import 'dart:io';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:http/http.dart' as http;
import 'package:student_id/data/model/student_model.dart';
import 'package:student_id/data/model/upload_id_model.dart';
import 'package:student_id/data/model/zone_model.dart';
import 'package:student_id/domain/requests/student_request.dart';

import '../../core/errors/exceptions.dart';
import '../model/login_model.dart';

const BASE_URL = "http://ec2-100-25-198-132.compute-1.amazonaws.com:8956/v1";

abstract class RemoteDataSource {
  Future<List<ZoneModel>> getZones({required String path});
  Future<LoginModel> login(String username, String password);
  Future<List<StudentModel>> getStudents(
      {required StudentRequest studentRequest});
  Future<UploadIdModel> uploadStudentId(
      {required StudentRequest studentRequest});
  Future<UploadIdModel> updateStudentId(
      {required StudentRequest studentRequest});
  Future<UploadIdModel> updateStudentImage(
      {required StudentRequest studentRequest});
}

class RemoteDataSourceImpl implements RemoteDataSource {
  //final http.Client client;

  RemoteDataSourceImpl();

  @override
  Future<List<ZoneModel>> getZones({required String path}) =>
      _getDataFromUrl(path: path);

  Future<List<ZoneModel>> _getDataFromUrl({required String path}) async {
    try {
      final response = await http.get(Uri.parse('$BASE_URL/$path'), headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      });
      switch (response.statusCode) {
        case 200:
          final results = json.decode(response.body);
          final news =
              (results as List).map((e) => ZoneModel.fromJson(e)).toList();
          return news;
        case 400:
          throw ServerException(message: response.body);
        case 401:
          throw const ServerException(message: 'Unauthorized');
        case 500:
          throw const ServerException(message: 'Internal Server Error');
        default:
          throw const ServerException(message: 'Unknown Error');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<LoginModel> login(String username, String password) async {
    try {
      // final results =
      //     (json.decode(loginResponse)); //(json.decode(response.body));
      // final loginModel = LoginModel.fromJson(results);
      // return loginModel;
      final response = await http.post(
        Uri.parse('$BASE_URL/auth/authenticate'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, String>{
          'email': username,
          'password': password,
        }),
      );
      switch (response.statusCode) {
        case 200:
          final results = (json.decode(response.body));
          final loginModel = LoginModel.fromJson(results);
          return loginModel;
        case 400:
          throw ServerException(message: response.body);
        case 401:
          throw const ServerException(message: 'Unauthorized');
        case 500:
          throw const ServerException(message: 'Internal Server Error');
        default:
          throw const ServerException(message: 'Unknown Error');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<List<StudentModel>> getStudents(
      {required StudentRequest studentRequest}) async {
    try {
      // final results =
      //     (json.decode(studentResponse)); //(json.decode(response.body));
      // final studentModel =
      //     (results as List).map((e) => StudentModel.fromJson(e)).toList();
      // return studentModel;
      final response = await http.get(
          Uri.parse(
              '$BASE_URL/student-info/by-class?schoolId=${studentRequest.instituteId}&className=${studentRequest.classId}'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            HttpHeaders.authorizationHeader:
                'Bearer ${studentRequest.accessToken}',
          });
      switch (response.statusCode) {
        case 200:
          final results = (json.decode(response.body));
          final studentModel =
              (results as List).map((e) => StudentModel.fromJson(e)).toList();
          return studentModel;
        case 400:
          throw ServerException(message: response.body);
        case 401:
          throw const ServerException(message: 'Unauthorized');
        case 500:
          throw const ServerException(message: 'Internal Server Error');
        default:
          throw const ServerException(message: 'Unknown Error');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<UploadIdModel> uploadStudentId(
      {required StudentRequest studentRequest}) async {
    try {
      // final results =
      //     (json.decode(uploadIdResponse)); //(json.decode(response.body));
      // final uploadModel = UploadIdModel.fromJson(results);
      // return uploadModel;
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse('$BASE_URL/student-info/save'));
      // request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
      if (GetPlatform.isMobile && studentRequest.idPath.isNotEmpty) {
        File file = File(studentRequest.idPath);
        request.files.add(http.MultipartFile(
            'file', file.readAsBytes().asStream(), file.lengthSync(),
            filename: file.path.split('/').last));
      }
      Map<String, String> fields = {};
      fields.addAll(<String, String>{
        //'login_id': studentRequest.loginId,
        //'zone_id': studentRequest.zoneId,
        'schoolId': studentRequest.instituteId,
        'classNo': studentRequest.classId,
        'name': studentRequest.studentName,
        'sectionName': studentRequest.sectionName,
        'idNumber': studentRequest.admissionNumber,
        'transport': studentRequest.transport,
      });
      request.fields.addAll(fields);
      http.StreamedResponse response = await request.send();
      final results = await response.stream.bytesToString();
      switch (response.statusCode) {
        case 200:
          //(json.decode(await response.stream.bytesToString()));
          final uploadModel = UploadIdModel(
              message: results); //UploadIdModel.fromJson(results);
          return uploadModel;
        case 400:
          throw ServerException(message: results);
        case 401:
          throw const ServerException(message: 'Unauthorized');
        case 500:
          throw const ServerException(message: 'Internal Server Error');
        default:
          throw const ServerException(message: 'Unknown Error');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<UploadIdModel> updateStudentId(
      {required StudentRequest studentRequest}) async {
    try {
      String status = '';
      if (studentRequest.isAccepted) {
        status = 'APPROVED';
      } else {
        status = 'REJECTED';
      }
      final response = await http.put(
        Uri.parse(
            '$BASE_URL/student-info/approve-reject/${studentRequest.id}?status=$status'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          HttpHeaders.authorizationHeader:
              'Bearer ${studentRequest.accessToken}',
        },
      );
      switch (response.statusCode) {
        case 200:
          final results = response.body;
          final uploadIdModel = UploadIdModel(message: results);
          return uploadIdModel;
        case 400:
          throw ServerException(message: response.body);
        case 401:
          throw const ServerException(message: 'Unauthorized');
        case 500:
          throw const ServerException(message: 'Internal Server Error');
        default:
          throw const ServerException(message: 'Unknown Error');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }

  @override
  Future<UploadIdModel> updateStudentImage(
      {required StudentRequest studentRequest}) async {
    try {
      // final results =
      //     (json.decode(uploadIdResponse)); //(json.decode(response.body));
      // final uploadModel = UploadIdModel.fromJson(results);
      // return uploadModel;
      http.MultipartRequest request = http.MultipartRequest('POST',
          Uri.parse('$BASE_URL/student-info/pic-update/${studentRequest.id}'));
      request.headers.addAll(<String, String>{
        'Authorization': 'Bearer ${studentRequest.accessToken}'
      });
      if (GetPlatform.isMobile && studentRequest.idPath.isNotEmpty) {
        File file = File(studentRequest.idPath);
        request.files.add(http.MultipartFile(
            'file', file.readAsBytes().asStream(), file.lengthSync(),
            filename: file.path.split('/').last));
      }
      http.StreamedResponse response = await request.send();
      final results = await response.stream.bytesToString();
      switch (response.statusCode) {
        case 200:
          //(json.decode(await response.stream.bytesToString()));
          final uploadModel = UploadIdModel(
              message: results); //UploadIdModel.fromJson(results);
          return uploadModel;
        case 400:
          throw ServerException(message: results);
        case 401:
          throw const ServerException(message: 'Unauthorized');
        case 500:
          throw const ServerException(message: 'Internal Server Error');
        default:
          throw const ServerException(message: 'Unknown Error');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw e.toString();
    }
  }
}
