import 'package:equatable/equatable.dart';
import '../errors/error_pop.dart';
import '../utils/loading.dart';

abstract class BaseState<STATE> with EquatableMixin {
  LoadingIndicatorViewModel get loader;
  ErrorPopup get error;

  const BaseState();

  STATE copyWith({
    LoadingIndicatorViewModel loader = const LoadingIndicatorViewModel.loaded(),
    ErrorPopup? error,
  });

  STATE loading() {
    return copyWith(
      loader: const LoadingIndicatorViewModel.loading(),
    );
  }

  STATE loaded() {
    return copyWith(
      loader: const LoadingIndicatorViewModel.loaded(),
    );
  }

  STATE withError(ErrorPopup error) {
    return copyWith(
      error: error,
    );
  }
}
