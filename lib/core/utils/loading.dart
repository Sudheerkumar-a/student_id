import 'package:equatable/equatable.dart';

class LoadingIndicatorViewModel with EquatableMixin {
  final bool isLoading;

  @override
  get props => [isLoading];

  const LoadingIndicatorViewModel._(this.isLoading);

  const LoadingIndicatorViewModel.loading() : this._(true);

  const LoadingIndicatorViewModel.loaded() : this._(false);

  const LoadingIndicatorViewModel.initialized() : this._(false);
}
