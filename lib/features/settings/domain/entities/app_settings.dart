class AppSettings {
  final bool autoCopyToClipboard;
  final bool closeOverlayOnCopy;
  final bool playSoundEffects;
  final String saveDirectory;
  final String exportFormat; // 'png', 'jpg', 'webp'
  final bool isDarkMode;
  final String captureHotkey;

  const AppSettings({
    this.autoCopyToClipboard = true,
    this.closeOverlayOnCopy = true,
    this.playSoundEffects = false,
    this.saveDirectory = '',
    this.exportFormat = 'png',
    this.isDarkMode = true,
    this.captureHotkey = 'Shift+Cmd+9',
  });

  AppSettings copyWith({
    bool? autoCopyToClipboard,
    bool? closeOverlayOnCopy,
    bool? playSoundEffects,
    String? saveDirectory,
    String? exportFormat,
    bool? isDarkMode,
    String? captureHotkey,
  }) {
    return AppSettings(
      autoCopyToClipboard: autoCopyToClipboard ?? this.autoCopyToClipboard,
      closeOverlayOnCopy: closeOverlayOnCopy ?? this.closeOverlayOnCopy,
      playSoundEffects: playSoundEffects ?? this.playSoundEffects,
      saveDirectory: saveDirectory ?? this.saveDirectory,
      exportFormat: exportFormat ?? this.exportFormat,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      captureHotkey: captureHotkey ?? this.captureHotkey,
    );
  }

  Map<String, dynamic> toJson() => {
    'autoCopyToClipboard': autoCopyToClipboard,
    'closeOverlayOnCopy': closeOverlayOnCopy,
    'playSoundEffects': playSoundEffects,
    'saveDirectory': saveDirectory,
    'exportFormat': exportFormat,
    'isDarkMode': isDarkMode,
    'captureHotkey': captureHotkey,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      autoCopyToClipboard: json['autoCopyToClipboard'] as bool? ?? true,
      closeOverlayOnCopy: json['closeOverlayOnCopy'] as bool? ?? true,
      playSoundEffects: json['playSoundEffects'] as bool? ?? false,
      saveDirectory: json['saveDirectory'] as String? ?? '',
      exportFormat: json['exportFormat'] as String? ?? 'png',
      isDarkMode: json['isDarkMode'] as bool? ?? true,
      captureHotkey: json['captureHotkey'] as String? ?? 'Shift+Cmd+9',
    );
  }
}
