import 'package:equatable/equatable.dart';
import 'package:student_id/features/catalog/domain/entities/zone.dart';

class ZoneModel extends Equatable {
  final dynamic id;
  final String? name;
  final String? stateName;

  const ZoneModel({required this.id, required this.name, this.stateName});

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'] ?? '0',
      name: json['name'] ?? 'Unknown',
      stateName: json['state'] ?? 'Andhra Pradesh'.toString(),
    );
  }

  @override
  List<Object?> get props => [id, name, stateName];
}

extension ZoneModelMapper on ZoneModel {
  Zones get toEntity => Zones(id: id, name: name, stateName: stateName);
}
