import 'package:equatable/equatable.dart';
import 'package:student_id/domain/entities/student_entity.dart';

import '../datasource/remote_data_source.dart';

class StudentModel extends Equatable {
  final int? id;
  final String? name;
  final String? admissionNumber;
  final String? bloodGroup;
  final int? schoolId;
  final String? classNo;
  final String? infoStatus;
  final String? profileUrl;

  const StudentModel({
    this.id,
    this.name,
    this.admissionNumber,
    this.bloodGroup,
    this.schoolId,
    this.classNo,
    this.infoStatus,
    this.profileUrl,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      admissionNumber: json['idNumber'],
      bloodGroup: json['bloodGroup'],
      schoolId: json['schoolId'],
      classNo: json['classNo'],
      infoStatus: json['infoStatus'],
      profileUrl: '$BASE_URL${json['imageUrl']}',
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        admissionNumber,
        profileUrl,
        bloodGroup,
        infoStatus,
        classNo,
        schoolId
      ];
}

extension SourceModelExtension on StudentModel {
  StudentEntity get toStudentEntity => StudentEntity(
      id: id,
      name: name,
      admissionNumber: admissionNumber,
      profileUrl: profileUrl,
      bloodGroup: bloodGroup,
      infoStatus: infoStatus,
      schoolId: schoolId,
      classNo: classNo);
}
