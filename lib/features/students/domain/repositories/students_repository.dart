import 'package:dartz/dartz.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/features/students/domain/entities/upload_id_entity.dart';
import 'package:student_id/features/students/domain/requests/student_request.dart';

abstract class StudentsRepository {
  Future<Either<Failure, List<StudentEntity>>> getStudents(
    StudentRequest studentRequest,
  );
  Future<Either<Failure, StudentEntity>> getStudentById(
    StudentRequest studentRequest,
  );
  Future<Either<Failure, UploadIdEntity>> uploadStudentId(
    StudentRequest studentRequest,
  );
  Future<Either<Failure, UploadIdEntity>> updateStudentId(
    StudentRequest studentRequest,
  );
  Future<Either<Failure, UploadIdEntity>> updateStudentImage(
    StudentRequest studentRequest,
  );
}
