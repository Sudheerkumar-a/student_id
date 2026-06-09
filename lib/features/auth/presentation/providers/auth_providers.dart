import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_id/core/network/network_providers.dart';
import 'package:student_id/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:student_id/features/auth/domain/repositories/auth_repository.dart';
import 'package:student_id/features/auth/domain/usecases/login_usecase.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(remoteDataStoreProvider)),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);
