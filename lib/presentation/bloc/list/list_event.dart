part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {}

class GetZonesEvent extends ListEvent {
  GetZonesEvent();
  @override
  List<Object?> get props => [];
}
