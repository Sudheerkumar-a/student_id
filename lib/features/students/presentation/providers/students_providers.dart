import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_id/core/network/network_providers.dart';
import 'package:student_id/features/students/data/repositories/students_repository_impl.dart';
import 'package:student_id/features/students/domain/repositories/students_repository.dart';
import 'package:student_id/features/students/domain/usecases/students_usecase.dart';

final studentsRepositoryProvider = Provider<StudentsRepository>(
  (ref) => StudentsRepositoryImpl(ref.watch(remoteDataStoreProvider)),
);

final studentsUseCaseProvider = Provider<StudentsUseCase>(
  (ref) => StudentsUseCase(ref.watch(studentsRepositoryProvider)),
);
