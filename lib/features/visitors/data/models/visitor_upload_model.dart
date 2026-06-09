import 'package:equatable/equatable.dart';
import 'package:student_id/features/visitors/domain/entities/visitor_upload_result.dart';

class VisitorUploadModel extends Equatable {
  final String? message;

  const VisitorUploadModel({required this.message});

  @override
  List<Object?> get props => [message];
}

extension VisitorUploadModelMapper on VisitorUploadModel {
  VisitorUploadResult get toEntity => VisitorUploadResult(message: message);
}
