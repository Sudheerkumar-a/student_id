import 'package:flutter/material.dart';

/// Shared spacing, radius, and layout constants for all forms.
abstract final class FormTokens {
  static const double spacingXs = 8;
  static const double spacingSm = 12;
  static const double spacingMd = 16;
  static const double spacingLg = 20;
  static const double spacingXl = 24;

  static const double radiusMd = 12;
  static const double radiusLg = 16;

  static const double buttonHeight = 52;
  static const double iconSize = 22;

  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: spacingMd, vertical: spacingMd);
  static const EdgeInsets cardPadding = EdgeInsets.all(spacingMd);
  static const EdgeInsets fieldContentPadding =
      EdgeInsets.symmetric(horizontal: spacingMd, vertical: 14);

  /// Brand purple aligned with app seed color.
  static const Color brandPurple = Color(0xFF603BB5);
  static const Color brandPurpleLight = Color(0xFFEDE7F6);
  static const Color surfaceMuted = Color(0xFFF5F5F7);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color errorColor = Color(0xFFB3261E);
}
