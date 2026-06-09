import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/core/network/remote_data_store.dart';
import 'package:student_id/core/utils/repository_guard.dart';
import 'package:student_id/features/students/data/models/student_model.dart';
import 'package:student_id/features/students/data/models/upload_id_model.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/features/students/domain/entities/upload_id_entity.dart';
import 'package:student_id/features/students/domain/repositories/students_repository.dart';
import 'package:student_id/features/students/domain/requests/student_request.dart';

class StudentsRepositoryImpl implements StudentsRepository {
  final RemoteDataStore _remote;

  StudentsRepositoryImpl(this._remote);

  static List<StudentModel> _parseStudentList(dynamic data) =>
      (data as List).map((e) => StudentModel.fromJson(e)).toList();

  static StudentModel _parseStudent(dynamic data) =>
      StudentModel.fromJson(data as Map<String, dynamic>);

  static UploadIdModel _parseUploadMessage(dynamic data) =>
      UploadIdModel(message: data?.toString());

  @override
  Future<Either<Failure, List<StudentEntity>>> getStudents(
    StudentRequest request,
  ) {
    return guardRepository(() async {
      final models = await _remote.get(
        '/student-info/by-class',
        queryParameters: <String, String>{
          'schoolId': request.instituteId,
          'className': request.classId,
        },
        headers: RemoteDataStore.bearerAuth(request.accessToken),
        parser: _parseStudentList,
      );
      return models.map((e) => e.toEntity).toList();
    });
  }

  @override
  Future<Either<Failure, StudentEntity>> getStudentById(
    StudentRequest request,
  ) {
    return guardRepository(() async {
      final model = await _remote.get(
        '/student-info/single/${request.instituteId}/${request.classId}/${request.admissionNumber}',
        headers: <String, String>{
          HttpHeaders.contentTypeHeader:
              'application/json; charset=utf-8; application/x-www-form-urlencoded',
          ...RemoteDataStore.bearerAuth(request.accessToken),
        },
        parser: _parseStudent,
      );
      return model.toEntity;
    });
  }

  @override
  Future<Either<Failure, UploadIdEntity>> uploadStudentId(
    StudentRequest request,
  ) {
    return guardRepository(() async {
      final model = await _remote.postWithMultipart(
        '/student-info/save',
        filePath: request.idPath,
        fields: <String, String>{
          'schoolId': request.instituteId,
          'classNo': request.classId,
          'name': request.studentName,
          'sectionName': request.sectionName,
          'idNumber': request.admissionNumber,
          'transport': request.transport,
        },
        parser: _parseUploadMessage,
      );
      return model.toEntity;
    });
  }

  @override
  Future<Either<Failure, UploadIdEntity>> updateStudentId(
    StudentRequest request,
  ) {
    final status = request.isAccepted ? 'APPROVED' : 'REJECTED';
    return guardRepository(() async {
      final model = await _remote.put(
        '/student-info/approve-reject/${request.id}',
        queryParameters: <String, String>{'status': status},
        headers: RemoteDataStore.bearerAuth(request.accessToken),
        parser: _parseUploadMessage,
      );
      return model.toEntity;
    });
  }

  @override
  Future<Either<Failure, UploadIdEntity>> updateStudentImage(
    StudentRequest request,
  ) {
    return guardRepository(() async {
      final model = await _remote.postWithMultipart(
        '/student-info/pic-update/${request.id}',
        filePath: request.idPath,
        fields: const <String, String>{},
        headers: RemoteDataStore.bearerAuth(request.accessToken),
        parser: _parseUploadMessage,
      );
      return model.toEntity;
    });
  }

}
