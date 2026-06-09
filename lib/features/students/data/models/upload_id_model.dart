import 'package:equatable/equatable.dart';
import 'package:student_id/features/students/domain/entities/upload_id_entity.dart';

class UploadIdModel extends Equatable {
  final String? message;

  const UploadIdModel({required this.message});

  @override
  List<Object?> get props => [message];
}

extension UploadIdModelMapper on UploadIdModel {
  UploadIdEntity get toEntity => UploadIdEntity(message: message);
}
