import 'package:student_id/features/camera/domain/entities/camera_capture.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';

class TeacherReviewArgs {
  final int? studentId;
  final String name;
  final String admissionNumber;
  final String imagePath;

  const TeacherReviewArgs({
    this.studentId,
    required this.name,
    required this.admissionNumber,
    required this.imagePath,
  });

  static TeacherReviewArgs fromExtra(Object extra) {
    if (extra is StudentEntity) {
      return TeacherReviewArgs(
        studentId: extra.id,
        name: extra.name ?? '',
        admissionNumber: extra.admissionNumber ?? '',
        imagePath: extra.profileUrl ?? 'assets/images/user_profile.png',
      );
    }
    if (extra is CapturedPhoto) {
      return TeacherReviewArgs(
        name: extra.subject.name,
        admissionNumber: extra.subject.admissionNumber,
        imagePath: extra.path,
      );
    }
    throw ArgumentError('Unsupported teacher review extra: $extra');
  }
}
