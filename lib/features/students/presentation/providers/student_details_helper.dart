import 'package:student_id/features/students/domain/entities/student_entity.dart';

/// College/staff form rules and entity building for the student details flow.
class StudentDetailsHelper {
  static bool isCollegeStudent(StudentEntity args) =>
      ['FIRST_YEAR', 'SECOND_YEAR', 'LONG_TERM'].contains(args.classNo);

  static bool isStaff(StudentEntity args) => args.className == 'STAFF';

  static StudentEntity buildPreviewEntity({
    required StudentEntity args,
    required String name,
    required String admissionNumber,
    required String sectionName,
    required String? transportType,
    required String photoPath,
  }) {
    final isCollege = isCollegeStudent(args);
    final isStaffMember = isStaff(args);

    return StudentEntity(
      name: (isCollege && !isStaffMember) ? admissionNumber : name,
      admissionNumber: admissionNumber,
      sectionName: (isCollege && !isStaffMember) ? admissionNumber : sectionName,
      profileUrl: photoPath,
      schoolId: args.schoolId ?? 0,
      schoolName: args.schoolName,
      classNo: args.classNo,
      className: args.className,
      transport: (isCollege && !isStaffMember) ? admissionNumber : transportType,
    );
  }
}
