import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository repository;

  AppSettings _settings = const AppSettings();
  bool _isLoaded = false;

  SettingsProvider(this.repository);

  AppSettings get settings => _settings;
  bool get isLoaded => _isLoaded;
  bool get isDarkMode => _settings.isDarkMode;
  bool get autoCopyToClipboard => _settings.autoCopyToClipboard;
  String get exportFormat => _settings.exportFormat;
  String get saveDirectory => _settings.saveDirectory;

  Future<void> loadSettings() async {
    _settings = await repository.getSettings();

    // Default save directory to Downloads/SnapMark or Documents/SnapMark if empty
    if (_settings.saveDirectory.isEmpty) {
      try {
        final docsDir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
        final defaultPath = '${docsDir.path}/SnapMark';
        final dir = Directory(defaultPath);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
        _settings = _settings.copyWith(saveDirectory: defaultPath);
        await repository.saveSettings(_settings);
      } catch (_) {}
    }

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    _settings = newSettings;
    notifyListeners();
    await repository.saveSettings(_settings);
  }

  Future<void> toggleDarkMode(bool isDark) async {
    await updateSettings(_settings.copyWith(isDarkMode: isDark));
  }

  Future<void> setSaveDirectory(String dirPath) async {
    await updateSettings(_settings.copyWith(saveDirectory: dirPath));
  }

  Future<void> setExportFormat(String format) async {
    await updateSettings(_settings.copyWith(exportFormat: format));
  }

  Future<void> toggleAutoCopy(bool autoCopy) async {
    await updateSettings(_settings.copyWith(autoCopyToClipboard: autoCopy));
  }
}
