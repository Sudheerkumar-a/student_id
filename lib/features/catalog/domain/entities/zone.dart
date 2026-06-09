import 'package:equatable/equatable.dart';

class Zones extends Equatable {
  final dynamic id;
  final String? name;

  const Zones({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() => name ?? '';
}
