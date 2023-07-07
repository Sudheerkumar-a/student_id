import 'package:equatable/equatable.dart';

import '../../domain/entities/zone.dart';

class ZoneModel extends Equatable {
  final String? name;
  var id;

  ZoneModel({
    required this.id,
    required this.name,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'] == null ? "0" : json["id"],
      name: json['name'] == null ? "Unknown" : json["name"],
    );
  }

  @override
  List<Object?> get props => [id, name];
}

extension SourceModelExtension on ZoneModel {
  Zones get toZone => Zones(id: id, name: name);
}
