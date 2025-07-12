import 'package:equatable/equatable.dart';

class Zones extends Equatable {
  var id;
  final String? name;

  Zones({required this.id, required this.name});
  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return name ?? '';
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    return super == other;
  }
}
