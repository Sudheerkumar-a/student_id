import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/login_entity.dart';
import '../repositories/api_repository.dart';

class LoginUsecase {
  final ApisRepository repository;

  LoginUsecase({required this.repository});

  Future<Either<Failure, LoginEntity>> login(
      String username, String password) async {
    return repository.login(username, password);
  }
}
