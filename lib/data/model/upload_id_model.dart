import 'package:equatable/equatable.dart';
import 'package:student_id/domain/entities/login_entity.dart';
import 'package:student_id/domain/entities/upload_id_entity.dart';

class UploadIdModel extends Equatable {
  final String? message;

  const UploadIdModel({
    required this.message,
  });

  factory UploadIdModel.fromJson(Map<String, dynamic> json) {
    return UploadIdModel(
      message: json['name'] == null ? "Unknown" : json["name"],
    );
  }

  @override
  List<Object?> get props => [message];
}

extension SourceModelExtension on UploadIdModel {
  UploadIdEntitiy get toUploadIdEntitiy => UploadIdEntitiy(message: message);
}
