import 'package:student_id/features/catalog/domain/entities/zone.dart';

enum ZoneStateTab {
  andhraPradesh('Andhra Pradesh'),
  telangana('Telangana');

  const ZoneStateTab(this.label);

  final String label;
}

abstract final class ZoneStateFilter {
  static bool isTelangana(String? state) => matches(state, ZoneStateTab.telangana);

  static List<Zones> filter(List<Zones> zones, ZoneStateTab tab) {
    return zones.where((zone) => matches(zone.state, tab)).toList();
  }

  static bool matches(String? state, ZoneStateTab tab) {
    final normalized = (state ?? '').toLowerCase().trim();
    if (normalized.isEmpty) {
      return tab == ZoneStateTab.andhraPradesh;
    }

    return switch (tab) {
      ZoneStateTab.andhraPradesh => normalized.contains('andhra'),
      ZoneStateTab.telangana =>
        normalized.contains('telangana') || normalized.contains('telangna'),
    };
  }
}
