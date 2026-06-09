import 'package:dartz/dartz.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/features/auth/domain/entities/login_entity.dart';
import 'package:student_id/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, LoginEntity>> call(
    String username,
    String password,
  ) {
    return repository.login(username, password);
  }
}
