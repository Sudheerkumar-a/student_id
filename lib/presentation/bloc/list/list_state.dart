
part of 'list_bloc.dart';

abstract class ListState extends Equatable {}

class ListInitial extends ListState {
  @override
  List<Object?> get props => [];
}

class ListLoading extends ListState {
  @override
  List<Object?> get props => [];
}

class ListLoadedWithSuccess extends ListState {
  final List<Zones> zones;

  ListLoadedWithSuccess({required this.zones});
  @override
  List<Object?> get props => [zones];
}

class ListLoadedWithError extends ListState {
  final String message;

  ListLoadedWithError({required this.message});
  @override
  List<Object?> get props => [message];
}
