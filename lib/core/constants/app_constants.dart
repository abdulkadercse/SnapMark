import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'SnapMark';
  static const String appVersion = '1.0.0';
  static const String defaultSaveSubfolder = 'SnapMark';

  // Hotkey Defaults
  static const String defaultCaptureHotkeyName = 'Shift + Cmd/Ctrl + 9';

  // Selection & UI Handles
  static const double handleSize = 7.0;
  static const double handleHitRadius = 14.0;
  static const double minSelectionSize = 10.0;
  static const double toolbarGap = 6.0;
  static const double toolbarButtonSize = 28.0;

  // Default Drawing Values
  static const Color defaultDrawColor = Color(0xFFFF2A2A); // High-visibility red
  static const double defaultStrokeWidth = 3.0;
  static const double defaultFontSize = 16.0;

  // Local Storage Keys
  static const String prefsSettingsKey = 'snapmark_settings_v1';
  static const String prefsHistoryKey = 'snapmark_history_v1';
}
