import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'core/platform/global_hotkey_service.dart';
import 'core/platform/screen_capture_service.dart';
import 'core/platform/system_tray_service.dart';
import 'core/platform/window_controller.dart';
import 'features/capture/presentation/providers/capture_provider.dart';
import 'features/editor/presentation/providers/editor_provider.dart';
import 'features/editor/presentation/providers/undo_redo_provider.dart';
import 'features/history/data/datasources/history_local_datasource.dart';
import 'features/history/data/repositories/history_repository_impl.dart';
import 'features/history/domain/repositories/history_repository.dart';
import 'features/history/presentation/providers/history_provider.dart';
import 'features/settings/data/datasources/settings_local_datasource.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

final GlobalKey<TrayHandlerWrapperState> trayHandlerKey = GlobalKey<TrayHandlerWrapperState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Desktop Window
  await WindowController.initialize();

  // 2. Initialize Repositories & Services
  final screenCaptureService = ScreenCaptureServiceImpl();
  final settingsRepo = SettingsRepositoryImpl(SettingsLocalDatasource());
  final historyRepo = HistoryRepositoryImpl(HistoryLocalDatasource());

  final settingsProvider = SettingsProvider(settingsRepo);
  final historyProvider = HistoryProvider(historyRepo);
  final captureProvider = CaptureProvider(screenCaptureService);
  final editorProvider = EditorProvider();
  final undoRedoProvider = UndoRedoProvider();

  // Load persistent configurations
  await settingsProvider.loadSettings();
  await historyProvider.loadHistory();

  runApp(
    MultiProvider(
      providers: [
        Provider<ScreenCaptureService>.value(value: screenCaptureService),
        Provider<SettingsRepository>.value(value: settingsRepo),
        Provider<HistoryRepository>.value(value: historyRepo),
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
        ChangeNotifierProvider<HistoryProvider>.value(value: historyProvider),
        ChangeNotifierProvider<CaptureProvider>.value(value: captureProvider),
        ChangeNotifierProvider<EditorProvider>.value(value: editorProvider),
        ChangeNotifierProvider<UndoRedoProvider>.value(value: undoRedoProvider),
      ],
      child: TrayHandlerWrapper(
        key: trayHandlerKey,
        child: const SnapMarkApp(),
      ),
    ),
  );
}

class TrayHandlerWrapper extends StatefulWidget {
  final Widget child;
  const TrayHandlerWrapper({super.key, required this.child});

  @override
  State<TrayHandlerWrapper> createState() => TrayHandlerWrapperState();
}

class TrayHandlerWrapperState extends State<TrayHandlerWrapper>
    with WindowListener
    implements SystemTrayEventListener {
  SystemTrayService? _trayService;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _initTrayAndHotkeys();
  }

  Future<void> _initTrayAndHotkeys() async {
    _trayService = SystemTrayService(listener: this);
    await _trayService?.initialize();

    // Register global hotkey
    await GlobalHotkeyService.initialize();
    await GlobalHotkeyService.registerCaptureHotkey(
      onTrigger: onTakeScreenshotClicked,
    );
  }

  @override
  void onWindowClose() async {
    // Hide to tray instead of quitting
    await windowManager.hide();
  }

  @override
  void onTakeScreenshotClicked() {
    final appState = SnapMarkApp.of(context);
    appState?.openCaptureOverlay();
    context.read<CaptureProvider>().triggerCapture();
  }

  @override
  void onHistoryClicked() {
    final appState = SnapMarkApp.of(context);
    appState?.openHistory();
  }

  @override
  void onPreferencesClicked() {
    final appState = SnapMarkApp.of(context);
    appState?.openSettings();
  }

  @override
  void onAboutClicked() {
    final appState = SnapMarkApp.of(context);
    if (appState != null) {
      appState.openAboutDialog(context);
    }
  }

  @override
  void onQuitClicked() {
    exit(0);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _trayService?.dispose();
    GlobalHotkeyService.unregisterAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
