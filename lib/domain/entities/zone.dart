import 'package:equatable/equatable.dart';

class Zones extends Equatable {
  var id;
  final String? name;

  Zones({required this.id, required this.name});
  @override
  List<Object?> get props => [name, id];
}
