import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class GlobalHotkeyService {
  static Future<void> initialize() async {
    await hotKeyManager.unregisterAll();
  }

  static Future<void> registerCaptureHotkey({
    required VoidCallback onTrigger,
  }) async {
    await hotKeyManager.unregisterAll();

    // Default: Shift + Cmd + 9 on macOS, Ctrl + Shift + A on Windows / Linux
    final HotKey captureKey;
    if (Platform.isMacOS) {
      captureKey = HotKey(
        key: PhysicalKeyboardKey.digit9,
        modifiers: [HotKeyModifier.meta, HotKeyModifier.shift],
        scope: HotKeyScope.system,
      );
    } else {
      captureKey = HotKey(
        key: PhysicalKeyboardKey.keyA,
        modifiers: [HotKeyModifier.control, HotKeyModifier.shift],
        scope: HotKeyScope.system,
      );
    }

    await hotKeyManager.register(
      captureKey,
      keyDownHandler: (_) => onTrigger(),
    );
  }

  static Future<void> unregisterAll() async {
    await hotKeyManager.unregisterAll();
  }
}
