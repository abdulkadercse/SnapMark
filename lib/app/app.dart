import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../core/platform/window_controller.dart';
import '../features/capture/presentation/providers/capture_provider.dart';
import '../features/capture/presentation/views/capture_overlay_view.dart';
import '../features/editor/data/datasources/export_datasource.dart';
import '../features/editor/presentation/providers/editor_provider.dart';
import '../features/history/presentation/views/history_view.dart';
import '../features/pin/presentation/views/pinned_overlay_view.dart';
import '../features/settings/presentation/providers/settings_provider.dart';
import '../features/settings/presentation/views/settings_view.dart';
import 'theme/app_theme.dart';

enum AppCurrentScreen {
  hidden,
  captureOverlay,
  history,
  settings,
  pinned,
}

class SnapMarkApp extends StatefulWidget {
  static final GlobalKey<SnapMarkAppState> globalKey = GlobalKey<SnapMarkAppState>();

  const SnapMarkApp({super.key});

  static SnapMarkAppState? of([BuildContext? context]) {
    if (context != null) {
      final state = context.findAncestorStateOfType<SnapMarkAppState>();
      if (state != null) return state;
    }
    return globalKey.currentState;
  }

  @override
  State<SnapMarkApp> createState() => SnapMarkAppState();
}

class SnapMarkAppState extends State<SnapMarkApp> {
  AppCurrentScreen _currentScreen = AppCurrentScreen.history;
  Uint8List? _pinnedImageBytes;

  void openCaptureOverlay() {
    setState(() {
      _currentScreen = AppCurrentScreen.captureOverlay;
    });
  }

  void openHistory() async {
    setState(() {
      _currentScreen = AppCurrentScreen.history;
    });
    await WindowController.showStandardWindow(
      size: const Size(900, 600),
      title: 'SnapMark — Capture History',
    );
  }

  void openSettings() async {
    setState(() {
      _currentScreen = AppCurrentScreen.settings;
    });
    await WindowController.showStandardWindow(
      size: const Size(640, 520),
      title: 'SnapMark — Preferences',
    );
  }

  void openAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationLegalese: '© 2026 SnapMark. Lightweight Offline Desktop Screenshot Utility.',
    );
  }

  void pinCurrentCapture(BuildContext context) async {
    final capture = context.read<CaptureProvider>();
    final editor = context.read<EditorProvider>();

    if (capture.baseUiImage == null || capture.selectionRect == null) return;

    try {
      final exportDs = ExportDatasource();
      final bytes = await exportDs.renderCompositeImage(
        baseImage: capture.baseUiImage!,
        selectionRect: capture.selectionRect!,
        elements: editor.elements,
      );

      final rect = capture.selectionRect!;
      _pinnedImageBytes = bytes;
      _currentScreen = AppCurrentScreen.pinned;
      setState(() {});

      await WindowController.showPinnedWindow(
        size: Size(rect.width, rect.height),
        position: rect.topLeft,
      );
    } catch (e) {
      debugPrint('Error pinning window: $e');
    }
  }

  void closePin() async {
    _pinnedImageBytes = null;
    setState(() {});
    await WindowController.hideOverlayWindow();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;

    Widget currentWidget;
    switch (_currentScreen) {
      case AppCurrentScreen.captureOverlay:
        currentWidget = CaptureOverlayView(
          onOpenHistory: openHistory,
          onPin: () => pinCurrentCapture(context),
        );
        break;
      case AppCurrentScreen.history:
        currentWidget = const HistoryView();
        break;
      case AppCurrentScreen.settings:
        currentWidget = const SettingsView();
        break;
      case AppCurrentScreen.pinned:
        currentWidget = _pinnedImageBytes != null
            ? PinnedOverlayView(imageBytes: _pinnedImageBytes!, onClose: closePin)
            : const SizedBox.shrink();
        break;
      case AppCurrentScreen.hidden:
        currentWidget = const SizedBox.shrink();
        break;
    }

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: currentWidget,
    );
  }
}
