import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/domain/entities/student_entity.dart';
import 'package:student_id/domain/entities/upload_id_entity.dart';
import 'package:student_id/domain/requests/student_request.dart';
import 'package:student_id/domain/use_cases/students_usecases.dart';

part 'students_state.dart';

class StudentsBloc extends Cubit<StudentsState> {
  final StudentsUsecase studentsUsecase;
  StudentsBloc({required this.studentsUsecase}) : super(StudentsInitial());

  Future<void> getStudents({required StudentRequest studentRequest}) async {
    emit(StudentsLoading());

    final result =
        await studentsUsecase.getStudents(studentRequest: studentRequest);
    emit(result.fold((l) => StudentsWithError(message: _getErrorMessage(l)),
        (r) => StudentsWithSuccess(studentEntity: r)));
  }

  Future<void> uploadStudentId({required StudentRequest studentRequest}) async {
    emit(StudentsLoading());

    final result =
        await studentsUsecase.uploadStudentId(studentRequest: studentRequest);
    emit(result.fold((l) => StudentsWithError(message: _getErrorMessage(l)),
        (r) => UploadIdWithSuccess(uploadIdEntitiy: r)));
  }

  Future<void> updateStudentId({required StudentRequest studentRequest}) async {
    emit(StudentsLoading());

    final result =
        await studentsUsecase.updateStudentId(studentRequest: studentRequest);
    emit(result.fold((l) => StudentsWithError(message: _getErrorMessage(l)),
        (r) => UploadIdWithSuccess(uploadIdEntitiy: r)));
  }

  Future<void> updateStudentImage(
      {required StudentRequest studentRequest}) async {
    emit(StudentsLoading());

    final result = await studentsUsecase.updateStudentImage(
        studentRequest: studentRequest);
    emit(result.fold((l) => StudentsWithError(message: _getErrorMessage(l)),
        (r) => UploadIdWithSuccess(uploadIdEntitiy: r)));
  }

  String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case CacheFailure:
        return (failure as CacheFailure).message;
      default:
        return 'An unknown error has occured';
    }
  }
}
