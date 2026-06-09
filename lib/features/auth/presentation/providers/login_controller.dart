import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_id/features/auth/presentation/providers/auth_providers.dart';
import 'package:student_id/core/utils/failure_message.dart';
import 'package:student_id/features/auth/domain/entities/login_entity.dart';

class LoginState {
  final bool isLoading;
  final LoginEntity? login;
  final String? errorMessage;

  const LoginState({
    this.isLoading = false,
    this.login,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    LoginEntity? login,
    String? errorMessage,
    bool clearLogin = false,
    bool clearError = false,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      login: clearLogin ? null : login ?? this.login,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result =
        await ref.read(loginUseCaseProvider).call(username, password);
    state = result.fold(
      (failure) => state.copyWith(
        isLoading: false,
        errorMessage: failureMessage(failure),
      ),
      (login) => state.copyWith(isLoading: false, login: login),
    );
  }

  void reset() => state = const LoginState();
}

final loginControllerProvider =
    NotifierProvider<LoginController, LoginState>(LoginController.new);
