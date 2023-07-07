import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/domain/use_cases/login_usecases.dart';

import '../../../domain/entities/login_entity.dart';

part 'login_state.dart';

class LoginBloc extends Cubit<LoginState> {
  final LoginUsecase loginUsecase;
  LoginBloc({required this.loginUsecase}) : super(LoginInitial());

  Future<void> login(String username, String password) async {
    emit(LoginLoading());

    final result = await loginUsecase.login(username, password);
    emit(result.fold((l) => LoginWithError(message: _getErrorMessage(l)),
        (r) => LoginWithSuccess(loginEntity: r)));
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
