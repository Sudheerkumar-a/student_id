part of 'login_bloc.dart';

abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginWithSuccess extends LoginState {
  final LoginEntity loginEntity;

  LoginWithSuccess({required this.loginEntity});
  @override
  List<Object?> get props => [loginEntity];
}

class LoginWithError extends LoginState {
  final String message;

  LoginWithError({required this.message});
  @override
  List<Object?> get props => [message];
}
