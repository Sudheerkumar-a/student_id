import 'package:dartz/dartz.dart';
import 'package:student_id/domain/entities/student_entity.dart';
import 'package:student_id/domain/entities/upload_id_entity.dart';
import 'package:student_id/domain/requests/student_request.dart';

import '../../core/errors/failures.dart';
import '../repositories/api_repository.dart';

class StudentsUsecase {
  final ApisRepository repository;

  StudentsUsecase({required this.repository});

  Future<Either<Failure, List<StudentEntity>>> getStudents(
      {required StudentRequest studentRequest}) async {
    return repository.getStudents(studentRequest);
  }

  Future<Either<Failure, UploadIdEntitiy>> uploadStudentId(
      {required StudentRequest studentRequest}) async {
    return repository.uploadStudentId(studentRequest);
  }

  Future<Either<Failure, UploadIdEntitiy>> updateStudentId(
      {required StudentRequest studentRequest}) async {
    return repository.updateStudentId(studentRequest);
  }

  Future<Either<Failure, UploadIdEntitiy>> updateStudentImage(
      {required StudentRequest studentRequest}) async {
    return repository.updateStudentImage(studentRequest);
  }
}
