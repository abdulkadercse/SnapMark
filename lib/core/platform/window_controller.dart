import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

class WindowController {
  static Future<void> initialize() async {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: true,
      titleBarStyle: TitleBarStyle.hidden,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setPreventClose(true);
      await windowManager.setHasShadow(false);
      // Keep hidden on startup so app runs strictly as a Menu Bar / Tray icon
      await windowManager.hide();
    });
  }

  /// Expands window to cover the entire primary screen borderless and transparently
  static Future<void> showOverlayWindow() async {
    try {
      final primaryDisplay = await ScreenRetriever.instance.getPrimaryDisplay();
      final size = primaryDisplay.size;
      final pos = primaryDisplay.visiblePosition ?? Offset.zero;

      await windowManager.setHasShadow(false);
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      await windowManager.setPosition(pos);
      await windowManager.setSize(size);
      await windowManager.setAlwaysOnTop(true);
      await windowManager.setFullScreen(true);
      await windowManager.show();
      await windowManager.focus();
    } catch (_) {}
  }

  /// Hides the overlay window to system tray
  static Future<void> hideOverlayWindow() async {
    try {
      await windowManager.setFullScreen(false);
      await windowManager.setAlwaysOnTop(false);
      await windowManager.hide();
    } catch (_) {}
  }

  /// Shows standard window for History or Preferences
  static Future<void> showStandardWindow({
    required Size size,
    required String title,
  }) async {
    try {
      await windowManager.setFullScreen(false);
      await windowManager.setAlwaysOnTop(false);
      await windowManager.setTitleBarStyle(TitleBarStyle.normal);
      await windowManager.setSize(size);
      await windowManager.center();
      await windowManager.setTitle(title);
      await windowManager.show();
      await windowManager.focus();
    } catch (_) {}
  }

  /// Shows pinned reference window
  static Future<void> showPinnedWindow({
    required Size size,
    required Offset position,
  }) async {
    try {
      await windowManager.setFullScreen(false);
      await windowManager.setAlwaysOnTop(true);
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      await windowManager.setPosition(position);
      await windowManager.setSize(size);
      await windowManager.show();
      await windowManager.focus();
    } catch (_) {}
  }
}
