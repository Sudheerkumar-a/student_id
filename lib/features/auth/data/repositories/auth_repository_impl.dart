import 'package:dartz/dartz.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/core/network/remote_data_store.dart';
import 'package:student_id/core/utils/repository_guard.dart';
import 'package:student_id/features/auth/data/models/login_model.dart';
import 'package:student_id/features/auth/domain/entities/login_entity.dart';
import 'package:student_id/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataStore _remote;

  AuthRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, LoginEntity>> login(
    String username,
    String password,
  ) {
    return guardRepository(() async {
      final model = await _remote.post(
        '/auth/authenticate',
        data: <String, String>{
          'email': username,
          'password': password,
        },
        parser: (data) => LoginModel.fromJson(data as Map<String, dynamic>),
      );
      return model.toEntity;
    });
  }
}
