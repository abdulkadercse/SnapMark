import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds & Surfaces
  static const Color darkBg = Color(0xFF131417);
  static const Color darkSurface = Color(0xFF1D1F24);
  static const Color darkCard = Color(0xFF262830);
  static const Color darkBorder = Color(0xFF333640);

  static const Color lightBg = Color(0xFFF6F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF0F2F5);
  static const Color lightBorder = Color(0xFFD0D7DE);

  // Accents
  static const Color primaryBlue = Color(0xFF2F81F7);
  static const Color accentCyan = Color(0xFF38BDF8);
  static const Color successGreen = Color(0xFF238636);
  static const Color dangerRed = Color(0xFFDA3633);
  static const Color warningAmber = Color(0xFFD29922);

  // Lightshot-style Toolbar colors
  static const Color toolbarBgLight = Color(0xFFF3F4F6);
  static const Color toolbarBgDark = Color(0xFF1E2025);
  static const Color toolbarBorderLight = Color(0xFFCCCCCC);
  static const Color toolbarBorderDark = Color(0xFF3B3E48);
  static const Color toolbarButtonHoverLight = Color(0xFFE5E7EB);
  static const Color toolbarButtonHoverDark = Color(0xFF2C2F38);

  // Selection Overlay
  static const Color overlayMask = Color(0x73000000); // 45% dark scrim
  static const Color selectionBorder = Color(0xFF38BDF8);
  static const Color handleFill = Color(0xFFFFFFFF);
  static const Color handleBorder = Color(0xFF000000);

  // Preset Annotation Colors
  static const List<Color> annotationPalette = [
    Color(0xFFFF2A2A), // Red (Default)
    Color(0xFF22C55E), // Green
    Color(0xFF3B82F6), // Blue
    Color(0xFFEAB308), // Yellow
    Color(0xFFA855F7), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFFFFFFFF), // White
    Color(0xFF000000), // Black
  ];
}
