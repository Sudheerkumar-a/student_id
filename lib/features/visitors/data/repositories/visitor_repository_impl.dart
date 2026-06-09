import 'package:dartz/dartz.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/core/network/remote_data_store.dart';
import 'package:student_id/core/utils/repository_guard.dart';
import 'package:student_id/features/visitors/data/models/visitor_upload_model.dart';
import 'package:student_id/features/visitors/domain/entities/visitor_upload_result.dart';
import 'package:student_id/features/visitors/domain/repositories/visitor_repository.dart';
import 'package:student_id/features/visitors/domain/requests/visitor_request.dart';

class VisitorRepositoryImpl implements VisitorRepository {
  final RemoteDataStore _remote;

  VisitorRepositoryImpl(this._remote);

  static VisitorUploadModel _parseUploadMessage(dynamic data) =>
      VisitorUploadModel(message: data?.toString());

  @override
  Future<Either<Failure, VisitorUploadResult>> uploadVisitor(
    VisitorRequest request,
  ) {
    return guardRepository(() async {
      final model = await _remote.postWithMultipart(
        '/student-info/${request.admissionNumber}/add-visitor',
        filePath: request.photoPath,
        fields: <String, String>{
          'studentName': request.studentName,
          'sectionName': request.sectionName,
          'schoolId': request.instituteId,
          'className': request.classId,
          'name': request.visitorName,
          'relationship': request.relationship.toUpperCase(),
          'contactNumber': request.contactNumber,
        },
        parser: _parseUploadMessage,
      );
      return model.toEntity;
    });
  }
}
