import 'package:equatable/equatable.dart';

class Zones extends Equatable {
  final dynamic id;
  final String? name;
  final String? state;

  const Zones({required this.id, required this.name, this.state});

  @override
  List<Object?> get props => [id, name, state];

  @override
  String toString() => name ?? '';
}
