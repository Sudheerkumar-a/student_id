import 'package:equatable/equatable.dart';

class Zones extends Equatable {
  final dynamic id;
  final String? name;
  final String? stateName;

  const Zones({
    required this.id,
    required this.name,
    this.stateName,
  });

  @override
  List<Object?> get props => [id, name, stateName];

  @override
  String toString() => name ?? '';
}
