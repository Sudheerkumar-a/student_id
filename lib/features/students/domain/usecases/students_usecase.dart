import 'package:dartz/dartz.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/features/students/domain/entities/upload_id_entity.dart';
import 'package:student_id/features/students/domain/repositories/students_repository.dart';
import 'package:student_id/features/students/domain/requests/student_request.dart';

class StudentsUseCase {
  final StudentsRepository repository;

  StudentsUseCase(this.repository);

  Future<Either<Failure, List<StudentEntity>>> getStudents(
    StudentRequest request,
  ) {
    return repository.getStudents(request);
  }

  Future<Either<Failure, StudentEntity>> getStudentById(
    StudentRequest request,
  ) {
    return repository.getStudentById(request);
  }

  Future<Either<Failure, UploadIdEntity>> uploadStudentId(
    StudentRequest request,
  ) {
    return repository.uploadStudentId(request);
  }

  Future<Either<Failure, UploadIdEntity>> updateStudentId(
    StudentRequest request,
  ) {
    return repository.updateStudentId(request);
  }

  Future<Either<Failure, UploadIdEntity>> updateStudentImage(
    StudentRequest request,
  ) {
    return repository.updateStudentImage(request);
  }
}
