import 'package:dartz/dartz.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/features/auth/domain/entities/login_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginEntity>> login(String username, String password);
}
