import 'package:dartz/dartz.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/features/visitors/domain/entities/visitor_upload_result.dart';
import 'package:student_id/features/visitors/domain/requests/visitor_request.dart';

abstract class VisitorRepository {
  Future<Either<Failure, VisitorUploadResult>> uploadVisitor(
    VisitorRequest request,
  );
}
