import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_id/features/students/presentation/providers/students_providers.dart';
import 'package:student_id/core/utils/failure_message.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/features/students/domain/entities/upload_id_entity.dart';
import 'package:student_id/features/students/domain/requests/student_request.dart';

enum StudentsStatus { initial, loading, success, uploadSuccess, error }

class StudentsState {
  final StudentsStatus status;
  final List<StudentEntity> students;
  final StudentEntity? student;
  final UploadIdEntity? uploadResult;
  final String? errorMessage;

  const StudentsState({
    this.status = StudentsStatus.initial,
    this.students = const [],
    this.student,
    this.uploadResult,
    this.errorMessage,
  });

  bool get isLoading => status == StudentsStatus.loading;

  StudentsState copyWith({
    StudentsStatus? status,
    List<StudentEntity>? students,
    StudentEntity? student,
    UploadIdEntity? uploadResult,
    String? errorMessage,
    bool clearError = false,
  }) {
    return StudentsState(
      status: status ?? this.status,
      students: students ?? this.students,
      student: student ?? this.student,
      uploadResult: uploadResult ?? this.uploadResult,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class StudentsController extends Notifier<StudentsState> {
  @override
  StudentsState build() => const StudentsState();

  Future<void> getStudents(StudentRequest request) async {
    state = state.copyWith(status: StudentsStatus.loading, clearError: true);
    final result = await ref.read(studentsUseCaseProvider).getStudents(request);
    state = result.fold(
      (failure) => state.copyWith(
        status: StudentsStatus.error,
        errorMessage: failureMessage(failure),
      ),
      (students) => state.copyWith(
        status: StudentsStatus.success,
        students: students,
      ),
    );
  }

  Future<StudentEntity> getStudentById(StudentRequest request) async {
    final result =
        await ref.read(studentsUseCaseProvider).getStudentById(request);
    return result.fold((_) => const StudentEntity(), (student) {
      state = state.copyWith(student: student);
      return student;
    });
  }

  Future<void> uploadStudentId(StudentRequest request) async {
    state = state.copyWith(status: StudentsStatus.loading, clearError: true);
    final result =
        await ref.read(studentsUseCaseProvider).uploadStudentId(request);
    state = result.fold(
      (failure) => state.copyWith(
        status: StudentsStatus.error,
        errorMessage: failureMessage(failure),
      ),
      (upload) => state.copyWith(
        status: StudentsStatus.uploadSuccess,
        uploadResult: upload,
      ),
    );
  }

  Future<void> updateStudentId(StudentRequest request) async {
    state = state.copyWith(status: StudentsStatus.loading, clearError: true);
    final result =
        await ref.read(studentsUseCaseProvider).updateStudentId(request);
    state = result.fold(
      (failure) => state.copyWith(
        status: StudentsStatus.error,
        errorMessage: failureMessage(failure),
      ),
      (upload) => state.copyWith(
        status: StudentsStatus.uploadSuccess,
        uploadResult: upload,
      ),
    );
  }

  Future<void> updateStudentImage(StudentRequest request) async {
    state = state.copyWith(status: StudentsStatus.loading, clearError: true);
    final result =
        await ref.read(studentsUseCaseProvider).updateStudentImage(request);
    state = result.fold(
      (failure) => state.copyWith(
        status: StudentsStatus.error,
        errorMessage: failureMessage(failure),
      ),
      (upload) => state.copyWith(
        status: StudentsStatus.uploadSuccess,
        uploadResult: upload,
      ),
    );
  }

  void reset() => state = const StudentsState();
}

final studentsControllerProvider =
    NotifierProvider<StudentsController, StudentsState>(
  StudentsController.new,
);
