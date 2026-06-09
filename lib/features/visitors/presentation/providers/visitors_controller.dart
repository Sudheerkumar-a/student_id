import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_id/features/students/presentation/providers/students_providers.dart';
import 'package:student_id/features/visitors/presentation/providers/visitor_providers.dart';
import 'package:student_id/core/utils/failure_message.dart';
import 'package:student_id/features/students/domain/entities/student_entity.dart';
import 'package:student_id/features/students/domain/requests/student_request.dart';
import 'package:student_id/features/visitors/domain/requests/visitor_request.dart';

enum VisitorsStatus { initial, loading, success, error }

class VisitorsState {
  final VisitorsStatus status;
  final StudentEntity? lookedUpStudent;
  final String? uploadMessage;
  final String? errorMessage;

  const VisitorsState({
    this.status = VisitorsStatus.initial,
    this.lookedUpStudent,
    this.uploadMessage,
    this.errorMessage,
  });

  bool get isLoading => status == VisitorsStatus.loading;

  VisitorsState copyWith({
    VisitorsStatus? status,
    StudentEntity? lookedUpStudent,
    String? uploadMessage,
    String? errorMessage,
    bool clearError = false,
  }) {
    return VisitorsState(
      status: status ?? this.status,
      lookedUpStudent: lookedUpStudent ?? this.lookedUpStudent,
      uploadMessage: uploadMessage ?? this.uploadMessage,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class VisitorsController extends Notifier<VisitorsState> {
  @override
  VisitorsState build() => const VisitorsState();

  Future<StudentEntity> lookupStudent(StudentRequest request) async {
    state = state.copyWith(status: VisitorsStatus.loading, clearError: true);
    final result =
        await ref.read(studentsUseCaseProvider).getStudentById(request);
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: VisitorsStatus.error,
          errorMessage: failureMessage(failure),
        );
        return const StudentEntity();
      },
      (student) {
        state = state.copyWith(
          status: VisitorsStatus.success,
          lookedUpStudent: student,
        );
        return student;
      },
    );
  }

  Future<String?> uploadVisitor(VisitorRequest request) async {
    state = state.copyWith(status: VisitorsStatus.loading, clearError: true);
    final result =
        await ref.read(visitorUseCaseProvider).uploadVisitor(request);
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: VisitorsStatus.error,
          errorMessage: failureMessage(failure),
        );
        return null;
      },
      (upload) {
        state = state.copyWith(
          status: VisitorsStatus.success,
          uploadMessage: upload.message,
        );
        return upload.message;
      },
    );
  }
}

final visitorsControllerProvider =
    NotifierProvider<VisitorsController, VisitorsState>(
  VisitorsController.new,
);
