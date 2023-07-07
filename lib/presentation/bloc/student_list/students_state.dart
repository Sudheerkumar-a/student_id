part of 'students_bloc.dart';

abstract class StudentsState extends Equatable {}

class StudentsInitial extends StudentsState {
  @override
  List<Object?> get props => [];
}

class StudentsLoading extends StudentsState {
  @override
  List<Object?> get props => [];
}

class StudentsWithSuccess extends StudentsState {
  final List<StudentEntity> studentEntity;

  StudentsWithSuccess({required this.studentEntity});
  @override
  List<Object?> get props => [studentEntity];
}

class UploadIdWithSuccess extends StudentsState {
  final UploadIdEntitiy uploadIdEntitiy;

  UploadIdWithSuccess({required this.uploadIdEntitiy});
  @override
  List<Object?> get props => [uploadIdEntitiy];
}

class StudentsWithError extends StudentsState {
  final String message;

  StudentsWithError({required this.message});
  @override
  List<Object?> get props => [message];
}
