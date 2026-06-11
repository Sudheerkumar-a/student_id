import 'package:equatable/equatable.dart';
import 'package:student_id/features/catalog/domain/entities/zone.dart';

class ZoneModel extends Equatable {
  final dynamic id;
  final String? name;
  final String? state;

  const ZoneModel({required this.id, required this.name, this.state});

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'] ?? '0',
      name: json['name'] ?? 'Unknown',
      state: _parseState(json),
    );
  }

  static String? _parseState(Map<String, dynamic> json) {
    final raw = json['state'] ?? json['stateName'];
    if (raw == null) return null;
    final value = raw.toString().trim();
    return value.isEmpty ? null : value;
  }

  @override
  List<Object?> get props => [id, name, state];
}

extension ZoneModelMapper on ZoneModel {
  Zones get toEntity => Zones(id: id, name: name, state: state);
}
