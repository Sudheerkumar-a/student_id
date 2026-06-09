import 'package:dartz/dartz.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/features/visitors/domain/entities/visitor_upload_result.dart';
import 'package:student_id/features/visitors/domain/repositories/visitor_repository.dart';
import 'package:student_id/features/visitors/domain/requests/visitor_request.dart';

class VisitorUseCase {
  final VisitorRepository repository;

  VisitorUseCase(this.repository);

  Future<Either<Failure, VisitorUploadResult>> uploadVisitor(
    VisitorRequest request,
  ) {
    return repository.uploadVisitor(request);
  }
}
