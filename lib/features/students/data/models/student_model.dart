import 'package:equatable/equatable.dart';
import 'package:student_id/core/constants/api_constants.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';

class StudentModel extends Equatable {
  final int? id;
  final String? name;
  final String? admissionNumber;
  final String? bloodGroup;
  final int? schoolId;
  final String? classNo;
  final String? sectionName;
  final String? infoStatus;
  final String? profileUrl;

  const StudentModel({
    this.id,
    this.name,
    this.admissionNumber,
    this.bloodGroup,
    this.schoolId,
    this.classNo,
    this.sectionName,
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
      sectionName: json['sectionName'],
      infoStatus: json['infoStatus'],
      profileUrl: '$baseUrl${json['imageUrl']}',
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
        schoolId,
      ];
}

extension StudentModelMapper on StudentModel {
  StudentEntity get toEntity => StudentEntity(
        id: id,
        name: name,
        admissionNumber: admissionNumber,
        profileUrl: profileUrl,
        bloodGroup: bloodGroup,
        infoStatus: infoStatus,
        schoolId: schoolId,
        classNo: classNo,
        sectionName: sectionName,
      );
}
