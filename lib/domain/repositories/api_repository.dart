import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:student_id/domain/entities/login_entity.dart';
import 'package:student_id/domain/entities/student_entity.dart';
import 'package:student_id/domain/entities/upload_id_entity.dart';
import 'package:student_id/domain/entities/zone.dart';
import 'package:student_id/domain/requests/student_request.dart';

import '../../core/errors/failures.dart';

abstract class ApisRepository {
  Future<Either<Failure, List<Zones>>> getZones();
  Future<Either<Failure, List<Zones>>> getInstitutes(
      {required String lookupId});
  Future<Either<Failure, List<Zones>>> getColleges();
  Future<Either<Failure, List<Zones>>> getClasses();
  Future<Either<Failure, List<Zones>>> getClassesColleges();
  Future<Either<Failure, LoginEntity>> login(String username, String password);
  Future<Either<Failure, List<StudentEntity>>> getStudents(
      StudentRequest studentRequest);
  Future<Either<Failure, UploadIdEntitiy>> uploadStudentId(
      StudentRequest studentRequest);
  Future<Either<Failure, UploadIdEntitiy>> updateStudentId(
      StudentRequest studentRequest);
  Future<Either<Failure, UploadIdEntitiy>> updateStudentImage(
      StudentRequest studentRequest);
}
