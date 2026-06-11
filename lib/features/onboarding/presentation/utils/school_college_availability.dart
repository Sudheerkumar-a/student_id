abstract final class SchoolCollegeAvailability {
  static const _selectionPeriod = Duration(days: 30);

  /// Fixed start date — clearing app data cannot reset the selection window.
  static final DateTime selectionStartDate = DateTime(2026, 6, 9);

  static bool get isSelectionExpired =>
      DateTime.now().isAfter(selectionStartDate.add(_selectionPeriod));
}
